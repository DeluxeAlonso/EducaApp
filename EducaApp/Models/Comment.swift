//
//  Comment.swift
//  EducaApp
//
//  Created by Alonso on 11/4/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import Foundation
import CoreData

@objc(Comment)
public class Comment: NSManagedObject {
  
  @NSManaged public var id: Int32
  @NSManaged public var sessionId: Int32
  @NSManaged public var author: User
  @NSManaged public var student: Student
  @NSManaged public var message: String
  @NSManaged public var face: Int32

}

// MARK: - JSON Deserialization

extension Comment: Deserializable {
  
  func setDataFromJSON(json: NSDictionary) {
    guard let id = json["id"] as AnyObject?, sessionId = json["session_id"] as AnyObject?,
      message = json["message"] as? String, face = json["face"] as AnyObject? else {
        return
    }
    self.id = id is Int ? Int32(id as! Int) : Int32(id as! String)!
    self.sessionId = sessionId is Int ? Int32(sessionId as! Int) : Int32(sessionId as! String)!
    self.message =  message
    self.face = face is Int ? Int32(face as! Int) : Int32(face as! String)!
  }
  
}

// MARK: - CoreData

extension Comment {
  
  public class func syncWithJsonArray(student: Student, arr: Array<NSDictionary>, ctx: NSManagedObjectContext) -> Array<Comment> {
    
    // Map JSON to ids, for easier access
    var jsonById = Dictionary<Int, NSDictionary>()
    for json in arr {
      if let id = json["id"] as? Int {
        jsonById[id] = json
      }
    }
    let ids = Array(jsonById.keys)
    
    // Get persisted articles
    let persistedArticles = Comment.getAllComments(ctx)
    var persistedArticleById = Dictionary<Int, Comment>()
    for art in persistedArticles {
      persistedArticleById[Int(art.id)] = art
    }
    let persistedIds = Array(persistedArticleById.keys)
    
    // Create new Article objects for new ids
    
    let newIds = NSMutableSet(array: ids)
    newIds.minusSet(NSSet(array: persistedIds) as Set<NSObject>)
    let newArticles = newIds.allObjects.map({ (id: AnyObject) -> Comment in
      let newArticle = NSEntityDescription.insertNewObjectForEntityForName("Comment", inManagedObjectContext: ctx) as! Comment
      newArticle.id = (Int32(id as! Int))
      newArticle.student = student
      return newArticle
    })
    
    // Find existing Article objects
    let updateIds = NSMutableSet(array: ids)
    updateIds.intersectSet(NSSet(array: persistedIds) as Set<NSObject>)
    let updateArticles = updateIds.allObjects.map({ (id: AnyObject) -> Comment in
      return persistedArticleById[id as! Int]!
    })
    
    // Apply json to each
    let validArticles = newArticles + updateArticles
    for article in validArticles {
      Comment.updateOrCreateWithJson(jsonById[Int(article.id)]!,ctx: ctx)
    }
    
    // Delete old items
    let deleteIds = NSMutableSet(array: persistedIds)
    deleteIds.minusSet(NSSet(array: ids) as Set<NSObject>)
    let deleteSessionUsers = deleteIds.allObjects.map({ (id: AnyObject) -> Comment in
      return persistedArticleById[id as! Int]!
    })
    for sessionUser in deleteSessionUsers {
      ctx.deleteObject(sessionUser)
    }
    
    return Comment.getAllComments(ctx)
  }
  
  public class func findOrCreateWithId(id: Int32, ctx: NSManagedObjectContext) -> Comment {
    var article: Comment? = getCommentById(id, ctx: ctx)
    if (article == nil) {
      article = NSEntityDescription.insertNewObjectForEntityForName("Comment", inManagedObjectContext: ctx) as? Comment
      article!.id = id
    }
    return article!
  }
  
  public class func updateOrCreateWithJson(json: NSDictionary, ctx: NSManagedObjectContext) -> Comment? {
    var article: Comment?
    if let id = json["id"] as? Int {
      article = findOrCreateWithId(Int32(id), ctx: ctx)
      article?.setDataFromJSON(json)
    }
    if let authorJson = json["author"] as? NSDictionary {
      let user = User.updateOrCreateWithJson(authorJson, ctx: ctx)
      article?.author = user!
    }
    return article
  }
  
  public class func getAllComments(ctx: NSManagedObjectContext) -> Array<Comment> {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName("Comment", inManagedObjectContext: ctx)
    let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]
    let articles = try! ctx.executeFetchRequest(fetchRequest) as? Array<Comment>
    return articles ?? Array<Comment>()
  }
  
  public class func getCommentById(id: Int32, ctx: NSManagedObjectContext) -> Comment? {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName("Comment", inManagedObjectContext: ctx)
    fetchRequest.predicate = NSPredicate(format: "(id = %d)", Int(id))
    let articles = try! ctx.executeFetchRequest(fetchRequest) as? Array<Comment>
    if (articles != nil && articles!.count > 0) {
      return articles![0]
    }
    return nil
  }
  
}
