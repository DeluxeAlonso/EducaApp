//
//  StudentService.swift
//  EducaApp
//
//  Created by Alonso on 10/27/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

let StudentsPath = "children"
let StudentCommentsPath = "children/{id}"

class StudentService {
  
  class func fetchStudents(completion: (responseObject: NSObject?, error: NSError?) -> Void) {
    NetworkManager.sharedInstance.requestSerializer.setValue(User.getAuthToken(), forHTTPHeaderField: Constants.Api.Header)
    NetworkManager.sharedInstance.GET(UrlBuilder.UrlForPath(StudentsPath), parameters: nil, success: { (operation: AFHTTPRequestOperation, responseObject: AnyObject?) in
      completion(responseObject: responseObject! as? NSObject, error: nil)
      }, failure: {(operation: AFHTTPRequestOperation, error: NSError) in
        completion(responseObject: nil, error: error)
    })
  }

  class func fetchStudentComments(studentId: Int32, completion: (responseObject: NSObject?, error: NSError?) -> Void) {
    NetworkManager.sharedInstance.requestSerializer.setValue(User.getAuthToken(), forHTTPHeaderField: Constants.Api.Header)
    NetworkManager.sharedInstance.GET(UrlBuilder.UrlForPath("children/\(studentId)"), parameters: nil, success: { (operation: AFHTTPRequestOperation, responseObject: AnyObject?) in
      completion(responseObject: responseObject! as? NSObject, error: nil)
      }, failure: {(operation: AFHTTPRequestOperation, error: NSError) in
        completion(responseObject: nil, error: error)
    })
  }
  
  class func commentStudent(sessionStudentId: Int32, parameters: NSDictionary, completion: (responseObject: NSObject?, error: NSError?) -> Void) {
    NetworkManager.sharedInstance.requestSerializer.setValue(User.getAuthToken(), forHTTPHeaderField: Constants.Api.Header)
    NetworkManager.sharedInstance.reachabilityManager.setReachabilityStatusChangeBlock({ (status) in
      if status == AFNetworkReachabilityStatus.ReachableViaWWAN || status == AFNetworkReachabilityStatus.ReachableViaWiFi {
        NetworkManager.sharedInstance.POST(UrlBuilder.UrlForPath("attendance_children/\(sessionStudentId)/comments"), parameters: parameters, success: { (operation: AFHTTPRequestOperation, responseObject: AnyObject?) in
          completion(responseObject: responseObject! as? NSObject, error: nil)
          }, failure: {(operation: AFHTTPRequestOperation, error: NSError) in
            completion(responseObject: nil, error: error)
        })
      }
    })
    NetworkManager.sharedInstance.reachabilityManager.startMonitoring()
  }

}
