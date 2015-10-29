//
//  Profile.swift
//  EducaApp
//
//  Created by Alonso on 10/25/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import Foundation
import CoreData

let ProfileEntityName = "Profile"
let ProfileIdKey = "id"
let ProfileNameKey = "name"

@objc(Profile)
public class Profile: NSManagedObject {
  
  @NSManaged public var id: Int32
  @NSManaged public var name: String?
  
}

// MARK: - JSON Deserialization

extension Profile: Deserializable {

  func setDataFromJSON(json: NSDictionary) {
    guard let id = json[ProfileIdKey] as AnyObject?, name = json[ProfileNameKey] as? String else {
      return
    }
    self.id = id is Int ? Int32(id as! Int) : Int32(id as! String)!
    self.name = name
  }
  
}

// MARK: - CordeData

extension Profile {
  
  public class func syncJsonArrayWithUser(user:User, arr: Array<NSDictionary>, ctx: NSManagedObjectContext) {
    let userProfiles = NSMutableArray()
    for json in arr {
      userProfiles.addObject(updateOrCreateWithJson(json, ctx: ctx)!)
    }
    user.profiles = NSSet(array: userProfiles as [AnyObject])
  }
  
  public class func findOrCreateWithId(id: Int32, ctx: NSManagedObjectContext) -> Profile {
    var profile: Profile? = getProfileById(id, ctx: ctx)
    if (profile == nil) {
      profile = NSEntityDescription.insertNewObjectForEntityForName(ProfileEntityName, inManagedObjectContext: ctx) as? Profile
      profile!.id = id
    }
    return profile!
  }
  
  public class func updateOrCreateWithJson(json: NSDictionary, ctx: NSManagedObjectContext) -> Profile? {
    var profile: Profile?
    if let id = json[ProfileIdKey] as AnyObject? {
      let profileId = id is Int ? Int32(id as! Int) : Int32(id as! String)!
      profile = findOrCreateWithId(Int32(profileId), ctx: ctx)
      profile?.setDataFromJSON(json)
    }
    return profile
  }
  
  public class func getProfileById(id: Int32, ctx: NSManagedObjectContext) -> Profile? {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName(ProfileEntityName, inManagedObjectContext: ctx)
    fetchRequest.predicate = NSPredicate(format: "(id = %d)", Int(id))
    let profiles = try! ctx.executeFetchRequest(fetchRequest) as? Array<Profile>
    if (profiles != nil && profiles!.count > 0) {
      return profiles![0]
    }
    return nil
  }
}
