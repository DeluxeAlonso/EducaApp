//
//  School.swift
//  EducaApp
//
//  Created by Alonso on 10/27/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import Foundation
import CoreData

let SchoolIdKey = "id"
let SchoolNameKey = "name"
let SchoolLatitudeKey = "latitude"
let SchoolLongitudeKey = "longitude"

@objc(School)
public class School: NSManagedObject {
  
  @NSManaged public var id: Int32
  @NSManaged public var name: String
  @NSManaged public var latitude: Float
  @NSManaged public var longitude: Float

  var coordinate: CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
  }
  
}

// MARK: - JSON Deserialization

extension School: Deserializable {
  
  func setDataFromJSON(json: NSDictionary) {
    guard let id = json[SchoolIdKey] as AnyObject?, name = json[SchoolNameKey] as? String, latitude = json[SchoolLatitudeKey] as? Float,longitude = json[SchoolLongitudeKey] as? Float else {
      return
    }
    self.id = id is Int ? Int32(id as! Int) : Int32(id as! String)!
    self.name = name
    self.latitude = latitude
    self.longitude = longitude
  }
  
}

// MARK: - CoreData

extension School {
  
  public class func syncWithJsonArray(arr: Array<NSDictionary>, ctx: NSManagedObjectContext) -> Array<School> {
    // Map JSON to ids, for easier access
    var jsonById = Dictionary<Int, NSDictionary>()
    for json in arr {
      if let id = json["id"] as AnyObject? {
        let schoolsId = id is Int ? id as! Int : Int(id as! String)!
        jsonById[schoolsId] = json
      }
    }
    let ids = Array(jsonById.keys)
    
    // Get persisted articles
    let persistedSchools = School.getAllSchools(ctx)
    var persistedSchoolById = Dictionary<Int, School>()
    for art in persistedSchools {
      persistedSchoolById[Int(art.id)] = art
    }
    let persistedIds = Array(persistedSchoolById.keys)
    
    // Create new Article objects for new ids
    
    let newIds = NSMutableSet(array: ids)
    newIds.minusSet(NSSet(array: persistedIds) as Set<NSObject>)
    let newSchools = newIds.allObjects.map({ (id: AnyObject) -> School in
      let newSchools = NSEntityDescription.insertNewObjectForEntityForName("School", inManagedObjectContext: ctx) as! School
      newSchools.id = (Int32(id as! Int))
      return newSchools
    })
    
    // Find existing Article objects
    let updateIds = NSMutableSet(array: ids)
    updateIds.intersectSet(NSSet(array: persistedIds) as Set<NSObject>)
    let updateSchools = updateIds.allObjects.map({ (id: AnyObject) -> School in
      return persistedSchoolById[id as! Int]!
    })
    
    // Apply json to each
    let validSchools = newSchools + updateSchools
    for school in validSchools {
      School.updateOrCreateWithJson(jsonById[Int(school.id)]!,ctx: ctx)
    }
    
    // Delete old items
    let deleteIds = NSMutableSet(array: persistedIds)
    deleteIds.minusSet(NSSet(array: ids) as Set<NSObject>)
    let deleteSchools = deleteIds.allObjects.map({ (id: AnyObject) -> School in
      return persistedSchoolById[id as! Int]!
    })
    for school in deleteSchools {
      ctx.deleteObject(school)
    }
    
    return School.getAllSchools(ctx)
  }
  
  public class func findOrCreateWithId(id: Int32, ctx: NSManagedObjectContext) -> School {
    var school: School? = getSchoolById(id, ctx: ctx)
    if (school == nil) {
      school = NSEntityDescription.insertNewObjectForEntityForName("School", inManagedObjectContext: ctx) as? School
      school!.id = id
    }
    return school!
  }
  
  public class func updateOrCreateWithJson(json: NSDictionary, ctx: NSManagedObjectContext) -> School? {
    var school: School?
    if let id = json["id"] as AnyObject? {
      let schoolId = id is Int ? Int32(id as! Int) : Int32(id as! String)!
      school = findOrCreateWithId(schoolId, ctx: ctx)
      school?.setDataFromJSON(json)
    }
    return school
  }
  
  public class func getAllSchools(ctx: NSManagedObjectContext) -> Array<School> {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName("School", inManagedObjectContext: ctx)
    let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]
    let schools = try! ctx.executeFetchRequest(fetchRequest) as? Array<School>
    return schools ?? Array<School>()
  }
  
  public class func getSchoolById(id: Int32, ctx: NSManagedObjectContext) -> School? {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName("School", inManagedObjectContext: ctx)
    fetchRequest.predicate = NSPredicate(format: "(id = %d)", Int(id))
    let schools = try! ctx.executeFetchRequest(fetchRequest) as? Array<School>
    if (schools != nil && schools!.count > 0) {
      return schools![0]
    }
    return nil
  }
  
}