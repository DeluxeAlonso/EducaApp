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
  @NSManaged public var postDate: NSDate
  @NSManaged public var imageUrl: String
  @NSManaged public var content: String
  @NSManaged public var author: User
  @NSManaged public var favoritedByCurrentUser: Bool
  @NSManaged public var favoriteBy: NSSet

}

// MARK: - JSON Deserialization

extension Article: Deserializable {
  
  func setDataFromJSON(json: NSDictionary) {
    guard let id = json["id"] as AnyObject?, title = json["title"] as? String,
      postDate = json["post_date"] as? Double, imageUrl = json["image_url"] as? String, content = json["content"] as? String else {
      return
    }
    self.id = id is Int ? Int32(id as! Int) : Int32(id as! String)!
    self.title = title
    self.postDate = NSDate(timeIntervalSince1970: postDate)
    self.imageUrl = imageUrl
    self.content = content
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
      let newArticle = NSEntityDescription.insertNewObjectForEntityForName("Article", inManagedObjectContext: ctx) as! Article
      newArticle.id = (Int32(id as! Int))
      return newArticle
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
