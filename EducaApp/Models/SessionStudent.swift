//
//  SessionStudent.swift
//  EducaApp
//
//  Created by Alonso on 10/27/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import Foundation
import CoreData

let SessionStudentEntityName = "SessionStudent"
let SessionStudentCommentedKey = "commented"
let FindSessionStudentByIdQuery = "student.id = %d AND session.id = %d"

@objc(SessionStudent)
public class SessionStudent: NSManagedObject {
  
  @NSManaged public var commented: Bool
  @NSManaged public var session: Session
  @NSManaged public var student: Student
  
}

// MARK: - JSON deserialization

extension SessionStudent: Deserializable {
  
  public func setDataFromJSON(json: NSDictionary) {
    guard let commented = json[SessionStudentCommentedKey] as? Bool else {
      return
    }
    self.commented = commented
  }
  
}

// MARK: - CoreData

extension SessionStudent {
  
  public class func syncWithJsonArray(session:Session, arr: Array<NSDictionary>, ctx: NSManagedObjectContext) -> Array<SessionStudent> {
    
    // Map JSON to user ids for comparing
    var jsonByStudentId = Dictionary<Int, NSDictionary>()
    var studentsByStudentId = Dictionary<Int, Student>()
    var jsonBysessionStudentId = Dictionary<Int, NSDictionary>()
    for json in arr {
      if let userJson = json["child"] as? NSDictionary, id = userJson["id"] as AnyObject? {
        let sessionStudentId = id is Int ? id as! Int : Int(id as! String)!
        let student :Student = Student.updateOrCreateWithJson(userJson, ctx: ctx)!
        studentsByStudentId[sessionStudentId] = student
        jsonBysessionStudentId[sessionStudentId] = json
        jsonByStudentId[sessionStudentId] = userJson
      }
    }
    
    let ids = Array(jsonByStudentId.keys)
    
    // Get SessionUsers from the deal
    let persistedSessionStudents = session.students
    var persistedSessionStudentsByStudentId = Dictionary<Int, SessionStudent>()
    for sessionStudent in persistedSessionStudents {
      persistedSessionStudentsByStudentId[Int(sessionStudent.student.id)] = sessionStudent as? SessionStudent
    }
    
    let persistedIds = Array(persistedSessionStudentsByStudentId.keys)
    
    // Create new SessionUser objects for new ids
    let newIds = NSMutableSet(array: ids)
    newIds.minusSet(NSSet(array: persistedIds) as Set<NSObject>)
    let newSessionStudents = newIds.allObjects.map({ (id: AnyObject) -> SessionStudent in
      let sessionStudent = NSEntityDescription.insertNewObjectForEntityForName(SessionStudentEntityName, inManagedObjectContext: ctx) as! SessionStudent
      sessionStudent.student = studentsByStudentId[id as! Int]!
      sessionStudent.session = session
      return sessionStudent
    })
    
    // Find existing SessionUser objects
    let updateIds = NSMutableSet(array: ids)
    updateIds.intersectSet(NSSet(array: persistedIds) as Set<NSObject>)
    let updateSessionStudents = updateIds.allObjects.map({ (id: AnyObject) -> SessionStudent in
      return persistedSessionStudentsByStudentId[id as! Int]!
    })
    
    // Apply json to each
    let validSessionStudents = newSessionStudents + updateSessionStudents
    for sessionStudent in validSessionStudents {
      sessionStudent.setDataFromJSON(jsonBysessionStudentId[Int(sessionStudent.student.id)]!)
    }
    
    // Delete old items
    let deleteIds = NSMutableSet(array: persistedIds)
    deleteIds.minusSet(NSSet(array: ids) as Set<NSObject>)
    let deleteSessionStudents = deleteIds.allObjects.map({ (id: AnyObject) -> SessionStudent in
      return persistedSessionStudentsByStudentId[id as! Int]!
    })
    for sessionStudent in deleteSessionStudents {
      ctx.deleteObject(sessionStudent)
    }
    
    return validSessionStudents
  }
  
  public class func createNewSessionUser(session: Session, student: Student, ctx: NSManagedObjectContext) -> SessionStudent?{
    var sessionUser: SessionStudent?
    sessionUser = findBySessionAndStudent(session, student: student, ctx: ctx)
    if (sessionUser == nil){
      let sessionUser = NSEntityDescription.insertNewObjectForEntityForName(SessionUserEntityName, inManagedObjectContext: ctx) as? SessionStudent
      let sessionContext : Session = ctx.objectWithID(session.objectID) as! Session
      let userContext : Student = ctx.objectWithID(student.objectID) as! Student
      sessionUser!.session = sessionContext
      sessionUser!.student = userContext
      return sessionUser!
    }
    return nil
  }
  
  public class func findBySessionAndStudent(session: Session, student: Student, ctx: NSManagedObjectContext) -> SessionStudent? {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName(SessionStudentEntityName, inManagedObjectContext: ctx)
    fetchRequest.predicate = NSPredicate(format: FindSessionStudentByIdQuery, student.id, session.id)
    let sessionUsers = try! ctx.executeFetchRequest(fetchRequest) as? Array<SessionStudent>
    if (sessionUsers != nil && sessionUsers!.count > 0) {
      return sessionUsers![0]
    }
    return nil
  }
  
}
