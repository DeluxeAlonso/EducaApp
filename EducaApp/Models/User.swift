//
//  User.swift
//  EducaApp
//
//  Created by Alonso on 9/2/15.
//  Copyright (c) 2015 Alonso. All rights reserved.
//

import Foundation
import CoreData

let UserEntityName = "User"
let UserIdKey = "id"
let UserNamesKey = "names"
let UserLastNameKey = "last_name"
let UserUsernameKey = "username"
let UserAuthTokenKey = "auth_token"
let UserLatitudeKey = "latitude"
let UserLongitudeKey = "longitude"
let UserProfilesKey = "profiles"
let UserActionsKey = "actions"

@objc(User)
public class User: NSManagedObject {
  
  @NSManaged public var id: Int32
  @NSManaged public var firstName: String
  @NSManaged public var lastName: String
  @NSManaged public var username: String
  @NSManaged public var latitude: Float
  @NSManaged public var longitude: Float
  @NSManaged public var profiles: NSSet
  @NSManaged public var actions: NSSet
  
  var fullName: String {
    let name = "\(firstName) \(lastName)"
    return name
  }
  
  var coordinate: CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
  }
  
}

// MARK: - JSON Deserialization

extension User: Deserializable {
  
  func setDataFromJSON(json: NSDictionary) {
    if let id = json[UserIdKey] as AnyObject?, firstName = json[UserNamesKey] as? String, lastName = json[UserLastNameKey] as? String, username = json[UserUsernameKey] as? String {
      self.id = id is Int ? Int32(id as! Int) : Int32(id as! String)!
      self.firstName = firstName
      self.lastName = lastName
      self.username = username
      if let authToken = json[UserAuthTokenKey] as? String {
        if User.isSignedIn() == false {
          User.setAuthToken(authToken)
        }
      }
      if let latitude = json[UserLatitudeKey] as? Float, longitude = json[UserLongitudeKey] as? Float {
        self.latitude = latitude
        self.longitude = longitude
      }
    }
  }
  
  func updateFavoriteArticle(article: Article, favorited: Bool, ctx: NSManagedObjectContext) {
    favorited ? (article.favoritedByCurrentUser = true) : (article.favoritedByCurrentUser = false)
  }
  
  func assistedToSession(session: Session, ctx: NSManagedObjectContext) -> Bool {
    return (SessionUser.findBySessionAndUser(session, user: self, ctx: ctx)?.attended)!
  }
  
  func markAttendanceToSession(session: Session, attended: Bool, ctx: NSManagedObjectContext) {
    let sessionUser = SessionUser.findBySessionAndUser(session, user: self, ctx: ctx)
    sessionUser?.attended = attended
  }
  
  func canListAssistantsComments() -> Bool {
    return true
  }
  
}

// MARK: - CoreData

extension User {
  
  public class func syncWithJsonArray(arr: Array<NSDictionary>, ctx: NSManagedObjectContext) -> Array<User> {
    // Map JSON to ids, for easier access
    var jsonById = Dictionary<Int, NSDictionary>()
    for json in arr {
      if let id = json[UserIdKey] as AnyObject? {
        let usersId = id is Int ? id as! Int : Int(id as! String)!
        jsonById[usersId] = json
      }
    }
    let ids = Array(jsonById.keys)
    
    // Get persisted articles
    let persistedUsers = User.getAllUsers(ctx)
    var persistedUserById = Dictionary<Int, User>()
    for art in persistedUsers {
      persistedUserById[Int(art.id)] = art
    }
    let persistedIds = Array(persistedUserById.keys)
    
    // Create new objects for new ids
    let newIds = NSMutableSet(array: ids)
    newIds.minusSet(NSSet(array: persistedIds) as Set<NSObject>)
    let newUsers = newIds.allObjects.map({ (id: AnyObject) -> User in
      let newUser = NSEntityDescription.insertNewObjectForEntityForName(UserEntityName, inManagedObjectContext: ctx) as! User
      newUser.id = (Int32(id as! Int))
      return newUser
    })
    
    // Find existing objects
    let updateIds = NSMutableSet(array: ids)
    updateIds.intersectSet(NSSet(array: persistedIds) as Set<NSObject>)
    let updateUsers = updateIds.allObjects.map({ (id: AnyObject) -> User in
      return persistedUserById[id as! Int]!
    })
    
    // Apply json to each
    let validUsers = newUsers + updateUsers
    for user in validUsers {
      User.updateOrCreateWithJson(jsonById[Int(user.id)]!,ctx: ctx)
    }
    
    return User.getAllUsers(ctx)
  }
  
  class func findOrCreateWithId(id: Int32, ctx: NSManagedObjectContext) -> User {
    var user: User? = getUserById(id, ctx: ctx)
    if (user == nil) {
      user = NSEntityDescription.insertNewObjectForEntityForName(UserEntityName, inManagedObjectContext: ctx) as? User
    }
    return user!
  }
  
  class func updateOrCreateWithJson(json: NSDictionary, ctx: NSManagedObjectContext) -> User? {
    var user: User?
    if let id = json[UserIdKey] as AnyObject?  {
      let userId = id is Int ? Int32(id as! Int) : Int32(id as! String)!
      user = findOrCreateWithId(userId, ctx: ctx)
      user?.setDataFromJSON(json)
    }
    if let profiles = json[UserProfilesKey] as? Array<NSDictionary> {
      Profile.syncJsonArrayWithUser(user!,arr: profiles, ctx: ctx)
    }
    if let actions = json[UserActionsKey] as? Array<NSDictionary> {
      if User.isSignedIn() == false {
        Action.syncJsonArrayWithUser(user!, arr: actions, ctx: ctx)
      }
    }
    return user
  }
  
  class func getAllUsers(ctx: NSManagedObjectContext) -> Array<User> {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName(UserEntityName, inManagedObjectContext: ctx)
    let sortDescriptor = NSSortDescriptor(key: "firstName", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    let users = try! ctx.executeFetchRequest(fetchRequest) as? Array<User>
    
    return users ?? Array<User>()
  }
  
  class func getUserById(id: Int32, ctx: NSManagedObjectContext) -> User? {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName(UserEntityName, inManagedObjectContext: ctx)
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
