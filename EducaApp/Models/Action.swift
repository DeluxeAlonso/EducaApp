//
//  Action.swift
//  EducaApp
//
//  Created by Alonso on 10/27/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import Foundation
import CoreData

let ActionEntityName = "Action"
let ActionIdKey = "id"

@objc(Action)
public class Action: NSManagedObject {

  @NSManaged public var id: Int32
  
}

// MARK: - JSON Deserialization

extension Action: Deserializable {
  
  func setDataFromJSON(json: NSDictionary) {
    guard let id = json[ActionIdKey] as AnyObject? else {
      return
    }
    self.id = id is Int ? Int32(id as! Int) : Int32(id as! String)!
  }
  
}

// MARK: - CordeData

extension Action {
  
  public class func syncJsonArrayWithUser(user:User, arr: Array<NSDictionary>, ctx: NSManagedObjectContext) {
    let userActions = NSMutableArray()
    for json in arr {
      userActions.addObject(updateOrCreateWithJson(json, ctx: ctx)!)
    }
    user.actions = NSSet(array: userActions as [AnyObject])
  }
  
  public class func findOrCreateWithId(id: Int32, ctx: NSManagedObjectContext) -> Action {
    var action: Action? = getActionById(id, ctx: ctx)
    if (action == nil) {
      action = NSEntityDescription.insertNewObjectForEntityForName(ActionEntityName, inManagedObjectContext: ctx) as? Action
      action!.id = id
    }
    return action!
  }
  
  public class func updateOrCreateWithJson(json: NSDictionary, ctx: NSManagedObjectContext) -> Action? {
    var action: Action?
    if let id = json[ActionIdKey] as AnyObject? {
      let actionId = id is Int ? Int32(id as! Int) : Int32(id as! String)!
      action = findOrCreateWithId(Int32(actionId), ctx: ctx)
      action?.setDataFromJSON(json)
    }
    return action
  }
  
  public class func getActionById(id: Int32, ctx: NSManagedObjectContext) -> Action? {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName(ActionEntityName, inManagedObjectContext: ctx)
    fetchRequest.predicate = NSPredicate(format: "(id = %d)", Int(id))
    let actions = try! ctx.executeFetchRequest(fetchRequest) as? Array<Action>
    if (actions != nil && actions!.count > 0) {
      return actions![0]
    }
    return nil
  }
}
