//
//  Session.swift
//
//
//  Created by Alonso on 10/21/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

let SessionEntityName = "Session"
let SessionIdKey = "id"
let SessionNameKey = "name"
let SessionDateKey = "date"
let SessionLocationKey = "location"
let SessionLatitudeKey = "latitude"
let SessionLongitudeKey = "longitude"
let SessionAttendanceVolunteerKey = "attendance_volunteers"
let SessionAttendanceChildrenKey = "attendance_children"
let SessionReunionPointKey = "points_of_reunion"
let SessionMeetingPointsKey = "meeting_points"
let SessionDocumentsKey = "documents"
let SessionVolunteersKey = "volunteers"

@objc(Session)
public class Session: NSManagedObject {
  
  @NSManaged public var name: String
  @NSManaged public var date: NSDate
  @NSManaged public var id: Int32
  @NSManaged public var latitude: Float
  @NSManaged public var longitude: Float
  @NSManaged public var volunteers: NSSet
  @NSManaged public var students: NSSet
  @NSManaged public var reunionPoints: NSSet
  @NSManaged public var documents: NSSet
  
  var coordinate: CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
  }
  
}

// MARK: - JSON Deserialization

extension Session: Deserializable {
  
  func setDataFromJSON(json: NSDictionary) {
    guard let id = json[SessionIdKey] as AnyObject?, name = json[SessionNameKey] as? String, locationJson = json[SessionLocationKey] as? NSDictionary, latitude = locationJson[SessionLatitudeKey] as? Float,longitude = locationJson[SessionLongitudeKey] as? Float, date = json[SessionDateKey] as? Double else {
        return
    }
    self.id = id is Int ? Int32(id as! Int) : Int32(id as! String)!
    self.name = name
    self.latitude = latitude
    self.longitude = longitude
    self.date = NSDate(timeIntervalSince1970: date)
  }
  
  func selectReunionPoint(reunionPoint: ReunionPoint, selected: Bool, ctx: NSManagedObjectContext) {
    let sessionReunionPoint = SessionReunionPoint.findBySessionAndReunionPoint(self, reunionPoint: reunionPoint, ctx: ctx)
    sessionReunionPoint?.selected = selected
  }
  
}

// MARK: - CoreData

extension Session {
  
  public class func syncWithJsonArray(arr: Array<NSDictionary>, ctx: NSManagedObjectContext) -> Array<Session> {
    // Map JSON to ids, for easier access
    var jsonById = Dictionary<Int, NSDictionary>()
    for json in arr {
      if let id = json["id"] as AnyObject? {
        let sessionsId = id is Int ? id as! Int : Int(id as! String)!
        jsonById[sessionsId] = json
      }
    }
    let ids = Array(jsonById.keys)
    
    // Get persisted articles
    let persistedSessions = Session.getAllSessions(ctx)
    var persistedSessionById = Dictionary<Int, Session>()
    for art in persistedSessions {
      persistedSessionById[Int(art.id)] = art
    }
    let persistedIds = Array(persistedSessionById.keys)
    
    // Create new Article objects for new ids
    
    let newIds = NSMutableSet(array: ids)
    newIds.minusSet(NSSet(array: persistedIds) as Set<NSObject>)
    let newSessions = newIds.allObjects.map({ (id: AnyObject) -> Session in
      let newSession = NSEntityDescription.insertNewObjectForEntityForName(SessionEntityName, inManagedObjectContext: ctx) as! Session
      newSession.id = (Int32(id as! Int))
      return newSession
    })
    
    // Find existing Article objects
    let updateIds = NSMutableSet(array: ids)
    updateIds.intersectSet(NSSet(array: persistedIds) as Set<NSObject>)
    let updateSessions = updateIds.allObjects.map({ (id: AnyObject) -> Session in
      return persistedSessionById[id as! Int]!
    })
    
    // Apply json to each
    let validSessions = newSessions + updateSessions
    for session in validSessions {
      Session.updateOrCreateWithJson(jsonById[Int(session.id)]!,ctx: ctx)
    }
    
    // Delete old items
    let deleteIds = NSMutableSet(array: persistedIds)
    deleteIds.minusSet(NSSet(array: ids) as Set<NSObject>)
    let deleteSessionUsers = deleteIds.allObjects.map({ (id: AnyObject) -> Session in
      return persistedSessionById[id as! Int]!
    })
    for sessionUser in deleteSessionUsers {
      ctx.deleteObject(sessionUser)
    }
    
    return Session.getAllSessions(ctx)
  }
  
  public class func findOrCreateWithId(id: Int32, ctx: NSManagedObjectContext) -> Session {
    var session: Session? = getSessionById(id, ctx: ctx)
    if (session == nil) {
      session = NSEntityDescription.insertNewObjectForEntityForName(SessionEntityName, inManagedObjectContext: ctx) as? Session
      session!.id = id
    }
    return session!
  }
  
  public class func updateOrCreateWithJson(json: NSDictionary, ctx: NSManagedObjectContext) -> Session? {
    var session: Session?
    if let id = json["id"] as AnyObject? {
      let sessionId = id is Int ? Int32(id as! Int) : Int32(id as! String)!
      session = findOrCreateWithId(sessionId, ctx: ctx)
      session?.setDataFromJSON(json)
    }
    if let volunteersJson = json[SessionAttendanceVolunteerKey] as! Array<NSDictionary>? {
      SessionUser.syncWithJsonArray(session!, arr: volunteersJson, ctx: ctx)
    }
    if let studentsJson = json[SessionAttendanceChildrenKey] as! Array<NSDictionary>? {
      SessionStudent.syncWithJsonArray(session!, arr: studentsJson, ctx: ctx)
    }
    if let reunionPointsJson = json[SessionMeetingPointsKey] as! Array<NSDictionary>? {
      SessionReunionPoint.syncWithJsonArray(session!, arr: reunionPointsJson, ctx: ctx)
    }
    if let documentsJson = json[SessionDocumentsKey] as! Array<NSDictionary>? {
      DocumentSession.syncWithJsonArray(session!, arr: documentsJson, ctx: ctx)
    }
    return session
  }
  
  public class func updateOrCreateReunionPointsWithJson(json: NSDictionary, ctx: NSManagedObjectContext) -> Session? {
    var session: Session?
    if let id = json["session_id"] as AnyObject? {
      let sessionId = id is Int ? Int32(id as! Int) : Int32(id as! String)!
      session = findOrCreateWithId(sessionId, ctx: ctx)
    }
    if let reunionPointsJson = json[SessionMeetingPointsKey] as! Array<NSDictionary>? {
      SessionReunionPoint.syncWithJsonArray(session!, arr: reunionPointsJson, ctx: ctx)
    }
    return session
  }
  
  public class func updateOrCreateVolunteersWithJson(json: NSDictionary, ctx: NSManagedObjectContext) -> Session? {
    var session: Session?
    if let id = json["session_id"] as AnyObject? {
      let sessionId = id is Int ? Int32(id as! Int) : Int32(id as! String)!
      session = findOrCreateWithId(sessionId, ctx: ctx)
    }
    if let volunteersJson = json[SessionVolunteersKey] as! Array<NSDictionary>? {
      SessionUser.syncVolunteersWithJsonArray(session!, arr: volunteersJson, ctx: ctx)
    }
    return session
  }
  
  public class func getAllSessions(ctx: NSManagedObjectContext) -> Array<Session> {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName(SessionEntityName, inManagedObjectContext: ctx)
    let sortDescriptor = NSSortDescriptor(key: SessionIdKey, ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]
    let sessions = try! ctx.executeFetchRequest(fetchRequest) as? Array<Session>
    return sessions ?? Array<Session>()
  }
  
  public class func getSessionById(id: Int32, ctx: NSManagedObjectContext) -> Session? {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName(SessionEntityName, inManagedObjectContext: ctx)
    fetchRequest.predicate = NSPredicate(format: "(id = %d)", Int(id))
    let sessions = try! ctx.executeFetchRequest(fetchRequest) as? Array<Session>
    if (sessions != nil && sessions!.count > 0) {
      return sessions![0]
    }
    return nil
  }
  
}
