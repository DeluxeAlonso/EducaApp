//
//  ArticleUser.swift
//  EducaApp
//
//  Created by Alonso on 10/11/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import Foundation
import CoreData

@objc(ArticleUser)
public class ArticleUser: NSManagedObject {
  
  @NSManaged public var favorite: Bool
  @NSManaged public var article: Article
  @NSManaged public var user: User

}

// MARK: - CoreData

let ArticleUserEntityName = "ArticleUser"
let FindArticleUserByIdQuery = "user.id = %d AND article.id = %d"

extension ArticleUser {
  
  public class func createNewArticleUser(article: Article, user: User, ctx: NSManagedObjectContext) -> ArticleUser?{
    var articleUser: ArticleUser?
    articleUser = findByArticleAndUser(article, user: user, ctx: ctx)
    if (articleUser == nil){
      let articleUser = NSEntityDescription.insertNewObjectForEntityForName(ArticleUserEntityName, inManagedObjectContext: ctx) as? ArticleUser
      let articleContext : Article = ctx.objectWithID(article.objectID) as! Article
      let userContext : User = ctx.objectWithID(user.objectID) as! User
      articleUser!.article = articleContext
      articleUser!.user = userContext
      articleUser?.favorite = false
      return articleUser!
    }
    return nil
  }
  
  public class func findByArticleAndUser(article: Article, user: User, ctx: NSManagedObjectContext) -> ArticleUser? {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName(ArticleUserEntityName, inManagedObjectContext: ctx)
    fetchRequest.predicate = NSPredicate(format: "user.id = %d AND article.id = %d", user.id, article.id)
    let articleUsers = try! ctx.executeFetchRequest(fetchRequest) as? Array<ArticleUser>
    if (articleUsers != nil && articleUsers!.count > 0) {
      return articleUsers![0]
    }
    return nil
  }
  
}