//
//  SessionUser.swift
//  EducaApp
//
//  Created by Alonso on 10/26/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import Foundation
import CoreData

let SessionUserEntityName = "SessionUser"
let SessionUserAttendedKey = "attended"
let FindSessionUserByIdQuery = "user.id = %d AND session.id = %d"

@objc(SessionUser)
public class SessionUser: NSManagedObject {

  @NSManaged public var attended: Bool
  @NSManaged public var session: Session
  @NSManaged public var user: User

}

// MARK: - JSON deserialization

extension SessionUser: Deserializable {
  
  public func setDataFromJSON(json: NSDictionary) {
    guard let attended = json[SessionUserAttendedKey] as AnyObject? else {
      return
    }
    if attended is Bool {
      self.attended = attended as! Bool
    } else if attended is String {
      self.attended = (attended as! String) == "0" ? false : true
       print(self.attended)
    }
  }
  
}

// MARK: - CoreData

extension SessionUser {
  
  public class func syncWithJsonArray(session:Session, arr: Array<NSDictionary>, ctx: NSManagedObjectContext) -> Array<SessionUser> {
    
    // Map JSON to user ids for comparing
    var jsonByUserId = Dictionary<Int, NSDictionary>()
    var usersByUserId = Dictionary<Int, User>()
    var jsonBysessionUserId = Dictionary<Int, NSDictionary>()
    for json in arr {
      if let userJson = json["volunteer"] as? NSDictionary, id = userJson["id"] as AnyObject? {
        let sessionUserId = id is Int ? id as! Int : Int(id as! String)!
        let user :User = User.updateOrCreateWithJson(userJson, ctx: ctx)!
        print(user.description)
        usersByUserId[sessionUserId] = user
        jsonBysessionUserId[sessionUserId] = json
        jsonByUserId[sessionUserId] = userJson
      }
    }
    
    let ids = Array(jsonByUserId.keys)
    
    // Get SessionUsers from the deal
    let persistedSessionUsers = session.volunteers
    var persistedSessionUsersByUserId = Dictionary<Int, SessionUser>()
    for sessionUser in persistedSessionUsers {
      persistedSessionUsersByUserId[Int(sessionUser.user.id)] = sessionUser as? SessionUser
    }

    let persistedIds = Array(persistedSessionUsersByUserId.keys)
    
    // Create new SessionUser objects for new ids
    let newIds = NSMutableSet(array: ids)
    newIds.minusSet(NSSet(array: persistedIds) as Set<NSObject>)
    let newSessionUsers = newIds.allObjects.map({ (id: AnyObject) -> SessionUser in
      let sessionVolunteer = NSEntityDescription.insertNewObjectForEntityForName(SessionUserEntityName, inManagedObjectContext: ctx) as! SessionUser
      sessionVolunteer.user = usersByUserId[id as! Int]!
      sessionVolunteer.session = session
      return sessionVolunteer
    })
    
    // Find existing SessionUser objects
    let updateIds = NSMutableSet(array: ids)
    updateIds.intersectSet(NSSet(array: persistedIds) as Set<NSObject>)
    let updateSessionUsers = updateIds.allObjects.map({ (id: AnyObject) -> SessionUser in
      return persistedSessionUsersByUserId[id as! Int]!
    })
    
    // Apply json to each
    let validSessionUsers = newSessionUsers + updateSessionUsers
    for sessionUser in validSessionUsers {
      sessionUser.setDataFromJSON(jsonBysessionUserId[Int(sessionUser.user.id)]!)
    }
    
    // Delete old items
    let deleteIds = NSMutableSet(array: persistedIds)
    deleteIds.minusSet(NSSet(array: ids) as Set<NSObject>)
    let deleteSessionUsers = deleteIds.allObjects.map({ (id: AnyObject) -> SessionUser in
      return persistedSessionUsersByUserId[id as! Int]!
    })
    for sessionUser in deleteSessionUsers {
      ctx.deleteObject(sessionUser)
    }
    
    return validSessionUsers
  }
  
  public class func createNewSessionUser(session: Session, user: User, ctx: NSManagedObjectContext) -> SessionUser?{
    var sessionUser: SessionUser?
    sessionUser = findBySessionAndUser(session, user: user, ctx: ctx)
    if (sessionUser == nil){
      let sessionUser = NSEntityDescription.insertNewObjectForEntityForName(SessionUserEntityName, inManagedObjectContext: ctx) as? SessionUser
      let sessionContext : Session = ctx.objectWithID(session.objectID) as! Session
      let userContext : User = ctx.objectWithID(user.objectID) as! User
      sessionUser!.session = sessionContext
      sessionUser!.user = userContext
      return sessionUser!
    }
    return nil
  }
  
  public class func findBySessionAndUser(session: Session, user: User, ctx: NSManagedObjectContext) -> SessionUser? {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName(SessionUserEntityName, inManagedObjectContext: ctx)
    fetchRequest.predicate = NSPredicate(format: FindSessionUserByIdQuery, user.id, session.id)
    let sessionUsers = try! ctx.executeFetchRequest(fetchRequest) as? Array<SessionUser>
    if (sessionUsers != nil && sessionUsers!.count > 0) {
      return sessionUsers![0]
    }
    return nil
  }
  
}