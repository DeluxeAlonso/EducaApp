//
//  Student.swift
//  EducaApp
//
//  Created by Alonso on 10/1/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import Foundation
import CoreData

let StudentEntityName = "Student"
let StudentIdKey = "id"
let StudentNameKey = "names"
let StudentLastNameKey = "last_name"
let StudentAgeKey = "age"
let StudentGenderKey = "gender"

@objc(Student)
public class Student: NSManagedObject {
  
  @NSManaged public var id: Int32
  @NSManaged public var firstName: String
  @NSManaged public var lastName: String
  @NSManaged public var age: Int32
  @NSManaged public var gender: Int32
  
  var fullName: String {
    let name = "\(firstName) \(lastName)"
    return name
  }

}

// MARK: - JSON Deserialization

extension Student: Deserializable {
  
  func setDataFromJSON(json: NSDictionary) {
    guard let id = json[StudentIdKey] as? Int, firstName = json[StudentNameKey] as? String, lastName = json[StudentLastNameKey] as? String, age = json[StudentAgeKey] as? Int, gender = json[StudentGenderKey] as? Int else {
        return
    }
    self.id = Int32(id)
    self.firstName = firstName
    self.lastName = lastName
    self.age = Int32(age)
    self.gender = Int32(gender)
  }
  
  func wasCommented(session: Session, ctx: NSManagedObjectContext) -> Bool {
    return (SessionStudent.findBySessionAndStudent(session, student: self, ctx: ctx)?.commented)!
  }
  
}

// MARK: - CoreData

extension Student {
  
  public class func syncWithJsonArray(arr: Array<NSDictionary>, ctx: NSManagedObjectContext) -> Array<Student> {
    // Map JSON to ids, for easier access
    var jsonById = Dictionary<Int, NSDictionary>()
    for json in arr {
      if let id = json[StudentIdKey] as AnyObject? {
        let studentsId = id is Int ? id as! Int : Int(id as! String)!
        jsonById[studentsId] = json
      }
    }
    let ids = Array(jsonById.keys)
    
    // Get persisted articles
    let persistedStudents = Student.getAllStudents(ctx)
    var persistedStudentById = Dictionary<Int, Student>()
    for art in persistedStudents {
      persistedStudentById[Int(art.id)] = art
    }
    let persistedIds = Array(persistedStudentById.keys)
    
    // Create new objects for new ids
    let newIds = NSMutableSet(array: ids)
    newIds.minusSet(NSSet(array: persistedIds) as Set<NSObject>)
    let newStudents = newIds.allObjects.map({ (id: AnyObject) -> Student in
      let newStudent = NSEntityDescription.insertNewObjectForEntityForName(StudentEntityName, inManagedObjectContext: ctx) as! Student
      newStudent.id = (Int32(id as! Int))
      return newStudent
    })
    
    // Find existing objects
    let updateIds = NSMutableSet(array: ids)
    updateIds.intersectSet(NSSet(array: persistedIds) as Set<NSObject>)
    let updateStudents = updateIds.allObjects.map({ (id: AnyObject) -> Student in
      return persistedStudentById[id as! Int]!
    })
    
    // Apply json to each
    let validStudents = newStudents + updateStudents
    for student in validStudents {
      Student.updateOrCreateWithJson(jsonById[Int(student.id)]!,ctx: ctx)
    }
    
    return Student.getAllStudents(ctx)
  }
  
  class func findOrCreateWithId(id: Int32, ctx: NSManagedObjectContext) -> Student {
    var student: Student? = getStudentById(id, ctx: ctx)
    if (student == nil) {
      student = NSEntityDescription.insertNewObjectForEntityForName(StudentEntityName, inManagedObjectContext: ctx) as? Student
    }
    return student!
  }
  
  class func updateOrCreateWithJson(json: NSDictionary, ctx: NSManagedObjectContext) -> Student? {
    var student: Student?
    if let id = json[StudentIdKey] as AnyObject?  {
      let studentId = id is Int ? Int32(id as! Int) : Int32(id as! String)!
      student = findOrCreateWithId(studentId, ctx: ctx)
      student?.setDataFromJSON(json)
    }
    return student
  }
  
  class func getAllStudents(ctx: NSManagedObjectContext) -> Array<Student> {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName(StudentEntityName, inManagedObjectContext: ctx)
    let sortDescriptor = NSSortDescriptor(key: "firstName", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    let students = try! ctx.executeFetchRequest(fetchRequest) as? Array<Student>
    
    return students ?? Array<Student>()
  }
  
  class func getStudentById(id: Int32, ctx: NSManagedObjectContext) -> Student? {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName(StudentEntityName, inManagedObjectContext: ctx)
    fetchRequest.predicate = NSPredicate(format: "(id = %d)", Int(id))
    let students = try! ctx.executeFetchRequest(fetchRequest) as? Array<Student>
    if (students != nil && students!.count > 0) {
      return students![0]
    }
    return nil
  }
  
}
