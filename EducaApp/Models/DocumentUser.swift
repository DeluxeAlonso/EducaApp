//
//  DocumentUser.swift
//  EducaApp
//
//  Created by Alonso on 11/3/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import Foundation
import CoreData

let DocumentUserEntityName = "DocumentUser"
let DocumentUserSeenKey = "seen"
let FindDocumentUserByIdQuery = "document.id = %d AND user.id = %d"
let FindDocumentUserByDocumentIdQuery = "document.id = %d"

@objc(DocumentUser)
public class DocumentUser: NSManagedObject {
  
  @NSManaged public var seen: Bool
  @NSManaged public var document: Document
  @NSManaged public var user: User
  
}

// MARK: - JSON deserialization

extension DocumentUser: Deserializable {
  
  public func setDataFromJSON(json: NSDictionary) {
    guard let seen = json[DocumentUserSeenKey] as? Bool else {
      return
    }
    self.seen = seen
  }
  
}

// MARK: - CoreData

extension DocumentUser {
  
  public class func syncWithJsonArray(document:Document, arr: Array<NSDictionary>, ctx: NSManagedObjectContext) -> Array<DocumentUser> {

    // Map JSON to user ids for comparing
    var jsonByDocumentId = Dictionary<Int, NSDictionary>()
    var documentsByDocumentId = Dictionary<Int, User>()
    var jsonBysessionDocumentId = Dictionary<Int, NSDictionary>()
    for json in arr {
      if let id = json["id"] as AnyObject? {
        let sessionDocumentId = id is Int ? id as! Int : Int(id as! String)!
        let document :User = User.updateOrCreateWithJson(json, ctx: ctx)!
        documentsByDocumentId[sessionDocumentId] = document
        jsonBysessionDocumentId[sessionDocumentId] = json
        jsonByDocumentId[sessionDocumentId] = json
      }
    }
    
    let ids = Array(jsonByDocumentId.keys)
    
    // Get SessionUsers from the deal
    let persistedSessionUsers = document.users
    for user in persistedSessionUsers {
      if (user as! DocumentUser).user.id == 0 {
        ctx.deleteObject(user as! NSManagedObject)
      }
    }
    var persistedSessionDocumentsByDocumentId = Dictionary<Int, DocumentUser>()
    for sessionDocument in persistedSessionUsers {
      if sessionDocument.user != nil {
        persistedSessionDocumentsByDocumentId[Int(sessionDocument.user.id)] = sessionDocument as? DocumentUser
      }
    }
    
    let persistedIds = Array(persistedSessionDocumentsByDocumentId.keys)
    
    // Create new SessionUser objects for new ids
    let newIds = NSMutableSet(array: ids)
    newIds.minusSet(NSSet(array: persistedIds) as Set<NSObject>)
    let newDocumentUsers = newIds.allObjects.map({ (id: AnyObject) -> DocumentUser in
      let documentUser = NSEntityDescription.insertNewObjectForEntityForName(DocumentUserEntityName, inManagedObjectContext: ctx) as! DocumentUser
      documentUser.user = documentsByDocumentId[id as! Int]!
      documentUser.document = document
      return documentUser
    })
    
    // Find existing SessionUser objects
    let updateIds = NSMutableSet(array: ids)
    updateIds.intersectSet(NSSet(array: persistedIds) as Set<NSObject>)
    let updateDocumentUsers = updateIds.allObjects.map({ (id: AnyObject) -> DocumentUser in
      return persistedSessionDocumentsByDocumentId[id as! Int]!
    })
    
    // Apply json to each
    let validSessionDocuments = newDocumentUsers + updateDocumentUsers
    for sessionDocument in validSessionDocuments {
      sessionDocument.setDataFromJSON(jsonBysessionDocumentId[Int(sessionDocument.user.id)]!)
    }
    
    // Delete old items
    let deleteIds = NSMutableSet(array: persistedIds)
    deleteIds.minusSet(NSSet(array: ids) as Set<NSObject>)
    let deleteSessionReunionPoints = deleteIds.allObjects.map({ (id: AnyObject) -> DocumentUser in
      return persistedSessionDocumentsByDocumentId[id as! Int]!
    })
    for sessionReunionPoint in deleteSessionReunionPoints {
      ctx.deleteObject(sessionReunionPoint)
    }
    
    return validSessionDocuments
  }
  
  public class func createNewDocumentUser(document: Document, user: User, ctx: NSManagedObjectContext) -> DocumentUser?{
    var sessionUser: DocumentUser?
    sessionUser = findBySessionAndDocument(document, user: user, ctx: ctx)
    if (sessionUser == nil){
      let sessionUser = NSEntityDescription.insertNewObjectForEntityForName(DocumentUserEntityName, inManagedObjectContext: ctx) as? DocumentUser
      let sessionContext : User = ctx.objectWithID(user.objectID) as! User
      let documentContext : Document = ctx.objectWithID(document.objectID) as! Document
      sessionUser!.user = sessionContext
      sessionUser!.document = documentContext
      return sessionUser!
    }
    return nil
  }
  
  public class func findBySessionAndDocument(document: Document, user: User, ctx: NSManagedObjectContext) -> DocumentUser? {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName(DocumentUserEntityName, inManagedObjectContext: ctx)
    fetchRequest.predicate = NSPredicate(format: FindDocumentSessionByIdQuery, document.id, user.id)
    let sessionReunionPoints = try! ctx.executeFetchRequest(fetchRequest) as? Array<DocumentUser>
    if (sessionReunionPoints != nil && sessionReunionPoints!.count > 0) {
      return sessionReunionPoints![0]
    }
    return nil
  }
  
  public class func findBySession(session: Session, ctx: NSManagedObjectContext) -> Array<DocumentUser> {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName(DocumentUserEntityName, inManagedObjectContext: ctx)
    fetchRequest.predicate = NSPredicate(format: FindDocumentUserByDocumentIdQuery, session.id)
    let sessionDocuments = try! ctx.executeFetchRequest(fetchRequest) as? Array<DocumentUser>
    return sessionDocuments ?? Array<DocumentUser>()
  }
  
}

