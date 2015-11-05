//
//  DocumentSession.swift
//  EducaApp
//
//  Created by Alonso on 11/3/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import Foundation
import CoreData

let DocumentSessionEntityName = "DocumentSession"
let FindDocumentSessionByIdQuery = "session.id = %d AND document.id = %d"
let FindDocumentSessionBySessionIdQuery = "session.id = %d"

@objc(DocumentSession)
public class DocumentSession: NSManagedObject {
  
  @NSManaged public var session: Session
  @NSManaged public var document: Document

}

// MARK: - CoreData

extension DocumentSession {
  
  public class func syncWithJsonArray(session:Session, arr: Array<NSDictionary>, ctx: NSManagedObjectContext) -> Array<DocumentSession> {
    
    // Map JSON to user ids for comparing
    var jsonByDocumentId = Dictionary<Int, NSDictionary>()
    var documentsByDocumentId = Dictionary<Int, Document>()
    var jsonBysessionDocumentId = Dictionary<Int, NSDictionary>()
    for json in arr {
      if let id = json["id"] as AnyObject? {
        let sessionDocumentId = id is Int ? id as! Int : Int(id as! String)!
        let document :Document = Document.updateOrCreateWithJson(json, ctx: ctx)!
        documentsByDocumentId[sessionDocumentId] = document
        jsonBysessionDocumentId[sessionDocumentId] = json
        jsonByDocumentId[sessionDocumentId] = json
      }
    }
    
    let ids = Array(jsonByDocumentId.keys)
    
    // Get SessionUsers from the deal
    let persistedSessionDocuments = session.documents
    var persistedSessionDocumentsByDocumentId = Dictionary<Int, DocumentSession>()
    for sessionDocument in persistedSessionDocuments {
      persistedSessionDocumentsByDocumentId[Int(sessionDocument.document.id)] = sessionDocument as? DocumentSession
    }
    
    let persistedIds = Array(persistedSessionDocumentsByDocumentId.keys)
    
    // Create new SessionUser objects for new ids
    let newIds = NSMutableSet(array: ids)
    newIds.minusSet(NSSet(array: persistedIds) as Set<NSObject>)
    let newSessionDocuments = newIds.allObjects.map({ (id: AnyObject) -> DocumentSession in
      let sessionDocument = NSEntityDescription.insertNewObjectForEntityForName(DocumentSessionEntityName, inManagedObjectContext: ctx) as! DocumentSession
      sessionDocument.document = documentsByDocumentId[id as! Int]!
      sessionDocument.session = session
      return sessionDocument
    })
    
    // Find existing SessionUser objects
    let updateIds = NSMutableSet(array: ids)
    updateIds.intersectSet(NSSet(array: persistedIds) as Set<NSObject>)
    let updateSessionDocuments = updateIds.allObjects.map({ (id: AnyObject) -> DocumentSession in
      return persistedSessionDocumentsByDocumentId[id as! Int]!
    })
    
    // Apply json to each
    let validSessionDocuments = newSessionDocuments + updateSessionDocuments
    
    // Delete old items
    let deleteIds = NSMutableSet(array: persistedIds)
    deleteIds.minusSet(NSSet(array: ids) as Set<NSObject>)
    let deleteSessionReunionPoints = deleteIds.allObjects.map({ (id: AnyObject) -> DocumentSession in
      return persistedSessionDocumentsByDocumentId[id as! Int]!
    })
    for sessionReunionPoint in deleteSessionReunionPoints {
      ctx.deleteObject(sessionReunionPoint)
    }
    
    return validSessionDocuments
  }
  
  public class func createNewSessionDocument(session: Session, reunionPoint: Document, ctx: NSManagedObjectContext) -> DocumentSession?{
    var sessionUser: DocumentSession?
    sessionUser = findBySessionAndDocument(session, reunionPoint: reunionPoint, ctx: ctx)
    if (sessionUser == nil){
      let sessionUser = NSEntityDescription.insertNewObjectForEntityForName(DocumentSessionEntityName, inManagedObjectContext: ctx) as? DocumentSession
      let sessionContext : Session = ctx.objectWithID(session.objectID) as! Session
      let documentContext : Document = ctx.objectWithID(reunionPoint.objectID) as! Document
      sessionUser!.session = sessionContext
      sessionUser!.document = documentContext
      return sessionUser!
    }
    return nil
  }
  
  public class func findBySessionAndDocument(session: Session, reunionPoint: Document, ctx: NSManagedObjectContext) -> DocumentSession? {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName(DocumentSessionEntityName, inManagedObjectContext: ctx)
    fetchRequest.predicate = NSPredicate(format: FindDocumentSessionByIdQuery, session.id, reunionPoint.id)
    let sessionReunionPoints = try! ctx.executeFetchRequest(fetchRequest) as? Array<DocumentSession>
    if (sessionReunionPoints != nil && sessionReunionPoints!.count > 0) {
      return sessionReunionPoints![0]
    }
    return nil
  }
  
  public class func findBySession(session: Session, ctx: NSManagedObjectContext) -> Array<DocumentSession> {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName(DocumentSessionEntityName, inManagedObjectContext: ctx)
    fetchRequest.predicate = NSPredicate(format: FindDocumentSessionBySessionIdQuery, session.id)
    let sessionDocuments = try! ctx.executeFetchRequest(fetchRequest) as? Array<DocumentSession>
    return sessionDocuments ?? Array<DocumentSession>()
  }
  
}
