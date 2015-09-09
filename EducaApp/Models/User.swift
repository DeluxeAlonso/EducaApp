//
//  User.swift
//  EducaApp
//
//  Created by Alonso on 9/2/15.
//  Copyright (c) 2015 Alonso. All rights reserved.
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
  
  @NSManaged public var id: Int32
  @NSManaged public var firstName: String
  @NSManaged public var lastName: String
  @NSManaged public var username: String
  @NSManaged public var authToken: String
  
  var fullName: String {
    var name = "\(firstName) \(lastName)"
    return name
  }
  
}

// MARK: - JSON Deserialization

extension User: Deserializable {
  
  func setDataFromJSON(json: NSDictionary) {
    if let id = json["id"] as? Int, firstName = json["first_name"] as? String, lastName = json["last_name"] as? String, username = json["username"] as? String, authToken = json["auth_token"] as? String {
      self.id = Int32(id)
      self.firstName = firstName
      self.lastName = lastName
      self.username = username
      self.authToken = authToken
    }
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
    
    var error: NSError?
    let users = ctx.executeFetchRequest(fetchRequest, error: &error) as? Array<User>
    
    if (error != nil) {
      println("Error fetching all users: \(error)")
    }
    
    return users ?? Array<User>()
  }
  
  class func getAuthenticatedUser(ctx: NSManagedObjectContext) -> User? {
    let defaults = NSUserDefaults.standardUserDefaults()
    if let id = defaults.integerForKey("authenticatedUserId") as Int? {
      return User.getUserById(Int32(id), ctx: ctx)
    }
    return nil
  }
  
  class func getUserById(id: Int32, ctx: NSManagedObjectContext) -> User? {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName("User", inManagedObjectContext: ctx)
    fetchRequest.predicate = NSPredicate(format: "(id = %d)", Int(id))
    var error: NSError?
    let users = ctx.executeFetchRequest(fetchRequest, error: &error) as? Array<User>
    if (users != nil && users!.count > 0) {
      return users![0]
    }
    return nil
  }
  
  class func setAuthenticatedUser(user: User) {
    let defaults = NSUserDefaults.standardUserDefaults()
    defaults.setInteger(Int(user.id), forKey: "authenticatedUserId")
    defaults.setBool(true, forKey: "signed_in")
    defaults.synchronize()
  }
  
  class func logOutClearUser(){
    let defaults = NSUserDefaults.standardUserDefaults()
    defaults.setValue(nil, forKey: "authenticatedUserId")
    defaults.setBool(false, forKey: "signed_in")
    defaults.synchronize()
  }
  
  class func isSignedIn() -> Bool?  {
    var is_signed_in: AnyObject?  =  NSUserDefaults.standardUserDefaults().objectForKey("signed_in")
    return is_signed_in != nil && is_signed_in as! NSNumber == true
  }
  
}