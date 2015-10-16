//
//  User.swift
//  EducaApp
//
//  Created by Alonso on 9/2/15.
//  Copyright (c) 2015 Alonso. All rights reserved.
//

import Foundation
import CoreData

enum UserType: Int {
  case Member
  case Volunteer
  case Godfather
}

@objc(User)
public class User: NSManagedObject {
  
  @NSManaged public var id: Int32
  @NSManaged public var firstName: String
  @NSManaged public var lastName: String
  @NSManaged public var username: String
  @NSManaged public var imageProfileUrl: String
  @NSManaged public var type: Int32
  @NSManaged public var favoriteArticles: NSMutableArray
  
  var fullName: String {
    let name = "\(firstName) \(lastName)"
    return name
  }
  
}

// MARK: - JSON Deserialization

extension User: Deserializable {
  
  func setDataFromJSON(json: NSDictionary) {
    if let id = json["id"] as? Int, firstName = json["first_name"] as? String, lastName = json["last_name"] as? String, username = json["username"] as? String , imageProfileUrl = json["image_profile_url"] as? String, type = json["type"] as? Int{
      self.id = Int32(id)
      self.firstName = firstName
      self.lastName = lastName
      self.username = username
      self.imageProfileUrl = imageProfileUrl
      self.type = Int32(type)
      if let authToken = json["auth_token"] as? String {
        User.setAuthToken(authToken)
      }
    }
  }
  
  func updateFavoriteArticle(article: Article, favorited: Bool, ctx: NSManagedObjectContext) {
    var articleUser: ArticleUser?
    articleUser = ArticleUser.findByArticleAndUser(article, user: self, ctx: ctx)
    favorited ? (article.favoritedByCurrentUser = true) : (article.favoritedByCurrentUser = false)
    articleUser?.favorite = favorited
  }
  
}

// MARK: - CoreData

extension User {
  
  class func findOrCreateWithId(id: Int32, ctx: NSManagedObjectContext) -> User {
    var user: User? = getUserById(id, ctx: ctx)
    if (user == nil) {
      user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: ctx) as? User
    }
    return user!
  }
  
  class func updateOrCreateWithJson(json: NSDictionary, ctx: NSManagedObjectContext) -> User? {
    var user: User?
    if let id = json["id"] as? Int {
      let userId = Int32(id)
      user = findOrCreateWithId(userId, ctx: ctx)
      user?.setDataFromJSON(json)
    }
    return user
  }
  
  class func getAllUsers(ctx: NSManagedObjectContext) -> Array<User> {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName("User", inManagedObjectContext: ctx)
    let users = try! ctx.executeFetchRequest(fetchRequest) as? Array<User>
    
    return users ?? Array<User>()
  }
  
  class func getUserById(id: Int32, ctx: NSManagedObjectContext) -> User? {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName("User", inManagedObjectContext: ctx)
    fetchRequest.predicate = NSPredicate(format: "(id = %d)", Int(id))
    let users = try! ctx.executeFetchRequest(fetchRequest) as? Array<User>
    if (users != nil && users!.count > 0) {
      return users![0]
    }
    return nil
  }
  
  class func getAuthenticatedUser(ctx: NSManagedObjectContext) -> User? {
    let defaults = NSUserDefaults.standardUserDefaults()
    if let id = defaults.integerForKey("authenticatedUserId") as Int? {
      return User.getUserById(Int32(id), ctx: ctx)
    }
    return nil
  }
  
  class func setAuthenticatedUser(user: User) {
    let defaults = NSUserDefaults.standardUserDefaults()
    defaults.setInteger(Int(user.id), forKey: "authenticatedUserId")
    defaults.setBool(true, forKey: "signed_in")
    defaults.synchronize()
  }
  
  class func signOut(){
    let defaults = NSUserDefaults.standardUserDefaults()
    defaults.setValue(nil, forKey: "authenticatedUserId")
    defaults.setBool(false, forKey: "signed_in")
    defaults.synchronize()
  }
  
  class func isSignedIn() -> Bool?  {
    let is_signed_in: AnyObject?  =  NSUserDefaults.standardUserDefaults().objectForKey("signed_in")
    return is_signed_in != nil && is_signed_in as! NSNumber == true
  }
  
}

// MARK: - KeychainWrapper

let keychainWrapper = KeychainWrapper()
  
extension User {
  
  class func setAuthToken(token: String) {
    keychainWrapper.mySetObject(token, forKey: kSecValueData)
    keychainWrapper.writeToKeychain()
  }
  
  class func getAuthToken() -> String {
    return keychainWrapper.myObjectForKey(Constants.Keychain.AuthTokenKey) as! String
  }
  
}
