//
//  Article.swift
//  EducaApp
//
//  Created by Alonso on 9/17/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import Foundation
import CoreData

@objc(Article)
public class Article: NSManagedObject {
  
  @NSManaged public var id: Int32
  @NSManaged public var title: String
  @NSManaged public var postTime: String
  @NSManaged public var imageUrl: String
  @NSManaged public var author: User

}

// MARK: - JSON Deserialization

extension Article: Deserializable {
  
  func setDataFromJSON(json: NSDictionary) {
    guard let id = json["id"] as? Int, title = json["title"] as? String,
      postTime = json["post_time"] as? String, imageUrl = json["image"] as? String else {
      return
    }
    self.id = Int32(id)
    self.title = title
    self.postTime = postTime
    self.imageUrl = imageUrl
  }
  
}

// MARK: - CoreData

extension Article {
  
  public class func syncWithJsonArray(arr: Array<NSDictionary>, ctx: NSManagedObjectContext) -> Array<Article> {
    
    // Map JSON to ids, for easier access
    var jsonById = Dictionary<Int, NSDictionary>()
    for json in arr {
      if let id = json["id"] as? Int {
        jsonById[id] = json
      }
    }
    let ids = Array(jsonById.keys)
    
    // Get persisted articles
    let persistedArticles = Article.getAllArticles(ctx)
    var persistedArticleById = Dictionary<Int, Article>()
    for art in persistedArticles {
      persistedArticleById[Int(art.id)] = art
    }
    let persistedIds = Array(persistedArticleById.keys)
    
    // Create new Article objects for new ids
    
    let newIds = NSMutableSet(array: ids)
    newIds.minusSet(NSSet(array: persistedIds) as Set<NSObject>)
    let newArticles = newIds.allObjects.map({ (id: AnyObject) -> Article in
      let e = NSEntityDescription.insertNewObjectForEntityForName("Article", inManagedObjectContext: ctx) as! Article
      e.id = (Int32(id as! Int))
      return e
    })
    
    // Find existing Article objects
    let updateIds = NSMutableSet(array: ids)
    updateIds.intersectSet(NSSet(array: persistedIds) as Set<NSObject>)
    let updateArticles = updateIds.allObjects.map({ (id: AnyObject) -> Article in
      return persistedArticleById[id as! Int]!
    })
    
    // Apply json to each
    let validArticles = newArticles + updateArticles
    for article in validArticles {
      Article.updateOrCreateWithJson(jsonById[Int(article.id)]!,ctx: ctx)
    }
    
    return Article.getAllArticles(ctx)
  }
  
  public class func findOrCreateWithId(id: Int32, ctx: NSManagedObjectContext) -> Article {
    var article: Article? = getArticleById(id, ctx: ctx)
    
    if (article == nil) {
      article = NSEntityDescription.insertNewObjectForEntityForName("Article", inManagedObjectContext: ctx) as? Article
      article!.id = id
    }
    
    return article!
  }
  
  public class func updateOrCreateWithJson(json: NSDictionary, ctx: NSManagedObjectContext) -> Article? {
    var article: Article?
    if let id = json["id"] as? Int {
      article = findOrCreateWithId(Int32(id), ctx: ctx)
      article?.setDataFromJSON(json)
    }
    if let authorJson = json["author"] as? Array<NSDictionary>, jsonInfo = authorJson[0] as NSDictionary! {
      let user = User.updateOrCreateWithJson(jsonInfo, ctx: ctx)
      print(user?.description)
      article?.author = user!
    }

    return article
  }
  
  public class func getAllArticles(ctx: NSManagedObjectContext) -> Array<Article> {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName("Article", inManagedObjectContext: ctx)
    let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]
    let articles = try! ctx.executeFetchRequest(fetchRequest) as? Array<Article>
    
    return articles ?? Array<Article>()
  }
  
  public class func getArticleById(id: Int32, ctx: NSManagedObjectContext) -> Article? {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName("Article", inManagedObjectContext: ctx)
    fetchRequest.predicate = NSPredicate(format: "(id = %d)", Int(id))
    let articles = try! ctx.executeFetchRequest(fetchRequest) as? Array<Article>
    if (articles != nil && articles!.count > 0) {
      return articles![0]
    }
    
    return nil
  }
  
}
