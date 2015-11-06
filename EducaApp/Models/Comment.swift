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
    guard let id = json["id"] as AnyObject?, message = json["message"] as? String, face = json["face"] as AnyObject? else {
        return
    }
    self.id = id is Int ? Int32(id as! Int) : Int32(id as! String)!
    self.message =  message
    self.face = face is Int ? Int32(face as! Int) : Int32(face as! String)!
    if let sessionId = json["session_id"] as AnyObject? {
      self.sessionId = sessionId is Int ? Int32(sessionId as! Int) : Int32(sessionId as! String)!
    }
  }
  
}

// MARK: - CoreData

extension Comment {
  
  public class func syncWithJsonArray(student: Student, arr: Array<NSDictionary>, ctx: NSManagedObjectContext) -> Array<Comment> {
    // Map JSON to ids, for easier access
    var jsonById = Dictionary<Int, NSDictionary>()
    for json in arr {
      if let id = json["id"] as AnyObject? {
        let commentId = id is Int ? Int32(id as! Int) : Int32(id as! String)!
        jsonById[Int(commentId)] = json
      }
    }
    let ids = Array(jsonById.keys)
    
    // Get persisted articles
    let persistedArticles = Comment.getCommentsByStudent(student, ctx: ctx)
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
    print(validArticles.count)
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
    var comment: Comment?
    if let id = json["id"] as AnyObject? {
      let commentId = id is Int ? Int32(id as! Int) : Int32(id as! String)!
      comment = findOrCreateWithId(commentId, ctx: ctx)
      comment?.setDataFromJSON(json)
    }
    if let authorJson = json["author"] as? NSDictionary {
      let user = User.updateOrCreateWithJson(authorJson, ctx: ctx)
      comment?.author = user!
    }
    return comment
  }
  
  
  public class func syncSingleCommentWithJsonArray(session:Session, student: Student, author: User, json: NSDictionary, ctx: NSManagedObjectContext) -> Array<Comment> {
    // Map JSON to ids, for easier access
    var jsonById = Dictionary<Int, NSDictionary>()
    if let id = json["id"] as AnyObject? {
    let commentId = id is Int ? Int32(id as! Int) : Int32(id as! String)!
      jsonById[Int(commentId)] = json
    }
    let ids = Array(jsonById.keys)
    
    // Get persisted articles
    let persistedArticles = Comment.getCommentsByStudent(student, ctx: ctx)
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
      Comment.updateOrCreateWithJsonAndUser(session, author: author ,json: jsonById[Int(article.id)]!,ctx: ctx)
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
  
  public class func updateOrCreateWithJsonAndUser(session:Session, author: User,json: NSDictionary, ctx: NSManagedObjectContext) -> Comment? {
    var comment: Comment?
    if let id = json["id"] as AnyObject? {
      let commentId = id is Int ? Int32(id as! Int) : Int32(id as! String)!
      comment = findOrCreateWithId(commentId, ctx: ctx)
      comment?.setDataFromJSON(json)
    }
    comment?.sessionId = session.id
    comment?.author = author
    return comment
  }
  
  public class func createNewComment(sessionStudent: SessionStudent, message: String, face: Int, ctx: NSManagedObjectContext) -> Comment? {
    var comment = getCommentBySessionAndStudentAndAuthor(sessionStudent.session, student: sessionStudent.student, author: User.getAuthenticatedUser(ctx)!, ctx: ctx)
    if (comment == nil){
      comment = NSEntityDescription.insertNewObjectForEntityForName("Comment", inManagedObjectContext: ctx) as? Comment
    }
    let sessionContext : Session = ctx.objectWithID(sessionStudent.session.objectID) as! Session
    let userContext : User = ctx.objectWithID(User.getAuthenticatedUser(ctx)!.objectID) as! User
    let studentContext: Student = ctx.objectWithID(sessionStudent.student.objectID) as! Student
    comment!.sessionId = sessionContext.id
    comment!.student = studentContext
    comment?.author = userContext
    comment?.message = message
    comment?.face = Int32(face)
    return comment!
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
  
  public class func getCommentsBySessionAndStudent(session: Session, student: Student, ctx: NSManagedObjectContext) -> Array<Comment> {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName("Comment", inManagedObjectContext: ctx)
    fetchRequest.predicate = NSPredicate(format: "(sessionId = %d AND student.id = %d)", Int(session.id), Int(student.id))
    let comments = try! ctx.executeFetchRequest(fetchRequest) as? Array<Comment>
    return comments ?? Array<Comment>()
  }
  
  public class func getCommentsByStudent(student: Student, ctx: NSManagedObjectContext) -> Array<Comment> {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName("Comment", inManagedObjectContext: ctx)
    fetchRequest.predicate = NSPredicate(format: "(student.id = %d)", Int(student.id))
    let comments = try! ctx.executeFetchRequest(fetchRequest) as? Array<Comment>
    return comments ?? Array<Comment>()
  }
  
  public class func getCommentBySessionAndStudentAndAuthor(session: Session, student: Student, author: User, ctx: NSManagedObjectContext) -> Comment? {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName("Comment", inManagedObjectContext: ctx)
    fetchRequest.predicate = NSPredicate(format: "(sessionId = %d AND student.id = %d AND author.id = %d)", Int(session.id), Int(student.id), Int(author.id))
    let comments = try! ctx.executeFetchRequest(fetchRequest) as? Array<Comment>
    if (comments != nil && comments!.count > 0) {
      return comments![0]
    }
    return nil
  }
  
}
