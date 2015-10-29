//
//  ReunionPoint.swift
//  EducaApp
//
//  Created by Alonso on 10/27/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import Foundation
import CoreData

let ReunionPointEntityName = "ReunionPoint"
let ReunionPointIdKey = "id"
let ReunionPointLatitudeKey = "latitude"
let ReunionPointLongitudeKey = "longitude"
let ReunionPointMeetingPoint = "meeting_point"

@objc(ReunionPoint)
public class ReunionPoint: NSManagedObject {
  
  @NSManaged public var id: Int32
  @NSManaged public var latitude: Float
  @NSManaged public var longitude: Float
  
  var coordinate: CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
  }

}

// MARK: - JSON Deserialization

extension ReunionPoint: Deserializable {
  
  func setDataFromJSON(json: NSDictionary) {
    guard let id = json[ReunionPointIdKey] as AnyObject?, latitude = json[ReunionPointLatitudeKey] as? Float, longitude = json[ReunionPointLongitudeKey] as? Float else {
      return
    }
    self.id = id is Int ? Int32(id as! Int) : Int32(id as! String)!
    self.latitude = latitude
    self.longitude = longitude
  }
  
}

// MARK: - CoreData

extension ReunionPoint {
  
  public class func syncJsonArrayWithSession(session:Session, arr: Array<NSDictionary>, ctx: NSManagedObjectContext) {
    let sessionReunionPoints = NSMutableArray()
    for json in arr {
      if let reunionPointJson = json[ReunionPointMeetingPoint] as? NSDictionary {
       sessionReunionPoints.addObject(updateOrCreateWithJson(reunionPointJson, ctx: ctx)!)
      }
    }
    session.reunionPoints = NSSet(array: sessionReunionPoints as [AnyObject])
  }
  
  /*public class func syncWithJsonArray(session:Session, arr: Array<NSDictionary>, ctx: NSManagedObjectContext) -> Array<ReunionPoint> {
    // Map JSON to ids, for easier access
    var jsonById = Dictionary<Int, NSDictionary>()
    for json in arr {
      if let reunionPointJson = json[ReunionPointMeetingPoint], id = reunionPointJson[ReunionPointIdKey] as AnyObject? {
        let studentsId = id is Int ? id as! Int : Int(id as! String)!
        jsonById[studentsId] = json
      }
    }
    let ids = Array(jsonById.keys)
    
    // Get persisted articles
    let persistedStudents = ReunionPoint.getAllReunionPoints(ctx)
    var persistedStudentById = Dictionary<Int, ReunionPoint>()
    for art in persistedStudents {
      persistedStudentById[Int(art.id)] = art
    }
    let persistedIds = Array(persistedStudentById.keys)
    
    // Create new objects for new ids
    let newIds = NSMutableSet(array: ids)
    newIds.minusSet(NSSet(array: persistedIds) as Set<NSObject>)
    let newReunionPoints = newIds.allObjects.map({ (id: AnyObject) -> ReunionPoint in
      let newReunionPoint = NSEntityDescription.insertNewObjectForEntityForName(ReunionPointEntityName, inManagedObjectContext: ctx) as! ReunionPoint
      newReunionPoint.id = (Int32(id as! Int))
      //newReunionPoint.session = session
      return newReunionPoint
    })
    
    // Find existing objects
    let updateIds = NSMutableSet(array: ids)
    updateIds.intersectSet(NSSet(array: persistedIds) as Set<NSObject>)
    let updateReunionPoints = updateIds.allObjects.map({ (id: AnyObject) -> ReunionPoint in
      return persistedStudentById[id as! Int]!
    })
    
    // Apply json to each
    let validReunionPoints = newReunionPoints + updateReunionPoints
    for reunionPoint in validReunionPoints {
      ReunionPoint.updateOrCreateWithJson(jsonById[Int(reunionPoint.id)]!,ctx: ctx)
    }
    
    return ReunionPoint.getAllReunionPoints(ctx)
  }*/
  
  class func findOrCreateWithId(id: Int32, ctx: NSManagedObjectContext) -> ReunionPoint {
    var student: ReunionPoint? = getReunionPointById(id, ctx: ctx)
    if (student == nil) {
      student = NSEntityDescription.insertNewObjectForEntityForName(ReunionPointEntityName, inManagedObjectContext: ctx) as? ReunionPoint
    }
    return student!
  }
  
  class func updateOrCreateWithJson(json: NSDictionary, ctx: NSManagedObjectContext) -> ReunionPoint? {
    var student: ReunionPoint?
    if let id = json[ReunionPointIdKey] as AnyObject?  {
      let studentId = id is Int ? Int32(id as! Int) : Int32(id as! String)!
      student = findOrCreateWithId(studentId, ctx: ctx)
      student?.setDataFromJSON(json)
    }
    return student
  }
  
  class func getAllReunionPoints(ctx: NSManagedObjectContext) -> Array<ReunionPoint> {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName(ReunionPointEntityName, inManagedObjectContext: ctx)
    let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    let students = try! ctx.executeFetchRequest(fetchRequest) as? Array<ReunionPoint>
    
    return students ?? Array<ReunionPoint>()
  }
  
  class func getReunionPointById(id: Int32, ctx: NSManagedObjectContext) -> ReunionPoint? {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName(ReunionPointEntityName, inManagedObjectContext: ctx)
    fetchRequest.predicate = NSPredicate(format: "(id = %d)", Int(id))
    let students = try! ctx.executeFetchRequest(fetchRequest) as? Array<ReunionPoint>
    if (students != nil && students!.count > 0) {
      return students![0]
    }
    return nil
  }
  
}
