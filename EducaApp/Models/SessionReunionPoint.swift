//
//  SessionReunionPoint.swift
//  EducaApp
//
//  Created by Alonso on 10/29/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import Foundation
import CoreData

let SessionReunionPointEntityName = "SessionReunionPoint"
let SessionReunionPointSelectedKey = "selected"
let FindSessionReunionPointByIdQuery = "session.id = %d AND reunionPoint.id = %d"
let FindSessionReunionPointBySessionIdQuery = "session.id = %d"

@objc(SessionReunionPoint)
public class SessionReunionPoint: NSManagedObject {
  
  @NSManaged public var selected: Bool
  @NSManaged public var session: Session
  @NSManaged public var reunionPoint: ReunionPoint

}

// MARK: - JSON deserialization

extension SessionReunionPoint: Deserializable {

  public func setDataFromJSON(json: NSDictionary) {
    guard let selected = json[SessionReunionPointSelectedKey] as? Bool else {
      return
    }
    self.selected = selected
  }
  
}

// MARK: - CoreData

extension SessionReunionPoint {
  
  public class func syncWithJsonArray(session:Session, arr: Array<NSDictionary>, ctx: NSManagedObjectContext) -> Array<SessionReunionPoint> {
    // Map JSON to user ids for comparing
    var jsonByReunionPointId = Dictionary<Int, NSDictionary>()
    var reunionPointsByReunionPointId = Dictionary<Int, ReunionPoint>()
    var jsonBysessionReunionPointId = Dictionary<Int, NSDictionary>()
    for json in arr {
      if let id = json["id"] as AnyObject? {
        let sessionReunionPointId = id is Int ? id as! Int : Int(id as! String)!
        let reunionPoint :ReunionPoint = ReunionPoint.updateOrCreateWithJson(json, ctx: ctx)!
        reunionPointsByReunionPointId[sessionReunionPointId] = reunionPoint
        jsonBysessionReunionPointId[sessionReunionPointId] = json
        jsonByReunionPointId[sessionReunionPointId] = json
      }
    }
    
    let ids = Array(jsonByReunionPointId.keys)
    
    // Get SessionUsers from the deal
    let persistedSessionReunionPoints = session.reunionPoints
    var persistedSessionReunionPointsByReunionPointId = Dictionary<Int, SessionReunionPoint>()
    for sessionReunionPoint in persistedSessionReunionPoints {
      persistedSessionReunionPointsByReunionPointId[Int(sessionReunionPoint.reunionPoint.id)] = sessionReunionPoint as? SessionReunionPoint
    }
    
    let persistedIds = Array(persistedSessionReunionPointsByReunionPointId.keys)
    
    // Create new SessionUser objects for new ids
    let newIds = NSMutableSet(array: ids)
    newIds.minusSet(NSSet(array: persistedIds) as Set<NSObject>)
    let newSessionReunionPoints = newIds.allObjects.map({ (id: AnyObject) -> SessionReunionPoint in
      let sessionReunionPoint = NSEntityDescription.insertNewObjectForEntityForName(SessionReunionPointEntityName, inManagedObjectContext: ctx) as! SessionReunionPoint
      sessionReunionPoint.reunionPoint = reunionPointsByReunionPointId[id as! Int]!
      sessionReunionPoint.session = session
      return sessionReunionPoint
    })
    
    // Find existing SessionUser objects
    let updateIds = NSMutableSet(array: ids)
    updateIds.intersectSet(NSSet(array: persistedIds) as Set<NSObject>)
    let updateSessionReunionPoints = updateIds.allObjects.map({ (id: AnyObject) -> SessionReunionPoint in
      return persistedSessionReunionPointsByReunionPointId[id as! Int]!
    })
    
    // Apply json to each
    let validSessionReunionPoints = newSessionReunionPoints + updateSessionReunionPoints
    for sessionReunionPoint in validSessionReunionPoints {
      sessionReunionPoint.setDataFromJSON(jsonBysessionReunionPointId[Int(sessionReunionPoint.reunionPoint.id)]!)
    }
    
    // Delete old items
    let deleteIds = NSMutableSet(array: persistedIds)
    deleteIds.minusSet(NSSet(array: ids) as Set<NSObject>)
    let deleteSessionReunionPoints = deleteIds.allObjects.map({ (id: AnyObject) -> SessionReunionPoint in
      return persistedSessionReunionPointsByReunionPointId[id as! Int]!
    })
    for sessionReunionPoint in deleteSessionReunionPoints {
      ctx.deleteObject(sessionReunionPoint)
    }
    
    return validSessionReunionPoints
  }
  
  public class func createNewSessionReunionPoint(session: Session, reunionPoint: ReunionPoint, ctx: NSManagedObjectContext) -> SessionReunionPoint?{
    var sessionUser: SessionReunionPoint?
    sessionUser = findBySessionAndReunionPoint(session, reunionPoint: reunionPoint, ctx: ctx)
    if (sessionUser == nil){
      let sessionUser = NSEntityDescription.insertNewObjectForEntityForName(SessionUserEntityName, inManagedObjectContext: ctx) as? SessionReunionPoint
      let sessionContext : Session = ctx.objectWithID(session.objectID) as! Session
      let userContext : ReunionPoint = ctx.objectWithID(reunionPoint.objectID) as! ReunionPoint
      sessionUser!.session = sessionContext
      sessionUser!.reunionPoint = userContext
      return sessionUser!
    }
    return nil
  }
  
  public class func findBySessionAndReunionPoint(session: Session, reunionPoint: ReunionPoint, ctx: NSManagedObjectContext) -> SessionReunionPoint? {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName(SessionReunionPointEntityName, inManagedObjectContext: ctx)
    fetchRequest.predicate = NSPredicate(format: FindSessionReunionPointByIdQuery, session.id, reunionPoint.id)
    let sessionReunionPoints = try! ctx.executeFetchRequest(fetchRequest) as? Array<SessionReunionPoint>
    if (sessionReunionPoints != nil && sessionReunionPoints!.count > 0) {
      return sessionReunionPoints![0]
    }
    return nil
  }
  
  public class func findBySession(session: Session, ctx: NSManagedObjectContext) -> Array<SessionReunionPoint> {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName(SessionReunionPointEntityName, inManagedObjectContext: ctx)
    fetchRequest.predicate = NSPredicate(format: FindSessionReunionPointBySessionIdQuery, session.id)
    let sessionReunionPoints = try! ctx.executeFetchRequest(fetchRequest) as? Array<SessionReunionPoint>
    return sessionReunionPoints ?? Array<SessionReunionPoint>()
  }
  
}
