//
//  Document.swift
//  EducaApp
//
//  Created by Alonso on 9/23/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import Foundation
import CoreData

let DocumentEntityName = "Document"
let DocumentIdKey = "id"
let DocumentNameKey = "name"
let DocumentUrlKey = "url"
let DocumentUploadDateKey = "upload_date"
let DocumentSizeKey = "size"
let DocumentUsersKey = "users"

@objc(Document)
public class Document: NSManagedObject {
  
  @NSManaged public var id: Int32
  @NSManaged public var name: String
  @NSManaged public var url: String
  @NSManaged public var size: String
  @NSManaged public var uploadDate: String
  @NSManaged public var users: NSSet
  @NSManaged public var isSaved: Bool

}

// MARK: - JSON Deserialization

extension Document: Deserializable {
  
  func setDataFromJSON(json: NSDictionary) {
    guard let id = json[DocumentIdKey] as AnyObject?, name = json[DocumentNameKey] as? String, url = json[DocumentUrlKey] as? String, uploadDate = json[DocumentUploadDateKey] as? String, size = json[DocumentSizeKey] as? String else {
      return
    }
    self.id = id is Int ? Int32(id as! Int) : Int32(id as! String)!
    self.name = name
    self.url = url
    self.size = size
    self.uploadDate = uploadDate
  }
  
}

// MARK: - CoreData

extension Document {
  
  public class func syncWithJsonArray(arr: Array<NSDictionary>, areSessionDocuments: Bool, ctx: NSManagedObjectContext) -> Array<Document> {
    // Map JSON to ids, for easier access
    var jsonById = Dictionary<Int, NSDictionary>()
    for json in arr {
      if let id = json[DocumentIdKey] as AnyObject? {
        let studentsId = id is Int ? id as! Int : Int(id as! String)!
        jsonById[studentsId] = json
      }
    }
    let ids = Array(jsonById.keys)
    
    // Get persisted articles
    let persistedStudents = areSessionDocuments ? Document.getAllDocuments(ctx) : Document.getAllReports(ctx)
    var persistedStudentById = Dictionary<Int, Document>()
    for art in persistedStudents {
      persistedStudentById[Int(art.id)] = art
    }
    let persistedIds = Array(persistedStudentById.keys)
    
    // Create new objects for new ids
    let newIds = NSMutableSet(array: ids)
    newIds.minusSet(NSSet(array: persistedIds) as Set<NSObject>)
    let newStudents = newIds.allObjects.map({ (id: AnyObject) -> Document in
      let newStudent = NSEntityDescription.insertNewObjectForEntityForName(DocumentEntityName, inManagedObjectContext: ctx) as! Document
      newStudent.id = (Int32(id as! Int))
      return newStudent
    })
    
    // Find existing objects
    let updateIds = NSMutableSet(array: ids)
    updateIds.intersectSet(NSSet(array: persistedIds) as Set<NSObject>)
    let updateStudents = updateIds.allObjects.map({ (id: AnyObject) -> Document in
      return persistedStudentById[id as! Int]!
    })
    
    // Apply json to each
    let validStudents = newStudents + updateStudents
    for student in validStudents {
      Document.updateOrCreateWithJson(jsonById[Int(student.id)]!,ctx: ctx)
    }
    
    // Delete old items
    let deleteIds = NSMutableSet(array: persistedIds)
    deleteIds.minusSet(NSSet(array: ids) as Set<NSObject>)
    let deleteStudents = deleteIds.allObjects.map({ (id: AnyObject) -> Document in
      return persistedStudentById[id as! Int]!
    })
    for student in deleteStudents {
      ctx.deleteObject(student)
    }
    
    return areSessionDocuments ? Document.getAllDocuments(ctx) : Document.getAllReports(ctx)
  }
  
  class func findOrCreateWithId(id: Int32, ctx: NSManagedObjectContext) -> Document {
    var student: Document? = getDocumentsById(id, ctx: ctx)
    if (student == nil) {
      student = NSEntityDescription.insertNewObjectForEntityForName(DocumentEntityName, inManagedObjectContext: ctx) as? Document
    }
    return student!
  }
  
  class func updateOrCreateWithJson(json: NSDictionary, ctx: NSManagedObjectContext) -> Document? {
    var document: Document?
    if let id = json[DocumentIdKey] as AnyObject?  {
      let documentId = id is Int ? Int32(id as! Int) : Int32(id as! String)!
      document = findOrCreateWithId(documentId, ctx: ctx)
      document?.setDataFromJSON(json)
    }
    if let usersJson = json[DocumentUsersKey] as! Array<NSDictionary>? {
      DocumentUser.syncWithJsonArray(document!, arr: usersJson, ctx: ctx)
    }
    return document
  }
  
  class func getAllDocuments(ctx: NSManagedObjectContext) -> Array<Document> {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName(DocumentEntityName, inManagedObjectContext: ctx)
    let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    var students = try! ctx.executeFetchRequest(fetchRequest) as? Array<Document>
    students = students?.filter({ (document) in
      return document.users.count > 0
    })
    return students ?? Array<Document>()
  }
  
  class func getAllReports(ctx: NSManagedObjectContext) -> Array<Document> {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName(DocumentEntityName, inManagedObjectContext: ctx)
    let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    var students = try! ctx.executeFetchRequest(fetchRequest) as? Array<Document>
    students = students?.filter({ (document) in
      return document.users.count == 0
    })
    
    return students ?? Array<Document>()
  }
  
  class func getDocumentsById(id: Int32, ctx: NSManagedObjectContext) -> Document? {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName(DocumentEntityName, inManagedObjectContext: ctx)
    fetchRequest.predicate = NSPredicate(format: "(id = %d)", Int(id))
    let students = try! ctx.executeFetchRequest(fetchRequest) as? Array<Document>
    if (students != nil && students!.count > 0) {
      return students![0]
    }
    return nil
  }
  
  class func searchByName(searchText: String, ctx: NSManagedObjectContext) -> Array<Document> {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName(DocumentEntityName, inManagedObjectContext: ctx)
    fetchRequest.predicate = NSPredicate(format: "name contains[cd] %@", searchText)
    let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    let users = try! ctx.executeFetchRequest(fetchRequest) as? Array<Document>
    
    return users ?? Array<Document>()
  }
  
}
