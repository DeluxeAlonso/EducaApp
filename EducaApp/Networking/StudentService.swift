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
    NetworkManager.sharedInstance.GET(UrlBuilder.UrlForPath(StudentsPath), parameters: nil, success: { (operation: AFHTTPRequestOperation, responseObject: AnyObject?) in
      completion(responseObject: responseObject! as? NSObject, error: nil)
      }, failure: {(operation: AFHTTPRequestOperation, error: NSError) in
        completion(responseObject: nil, error: error)
    })
  }

  class func fetchStudentComments(studentId: Int32, completion: (responseObject: NSObject?, error: NSError?) -> Void) {
    NetworkManager.sharedInstance.GET(UrlBuilder.UrlForApiaryPath("children/\(studentId)"), parameters: nil, success: { (operation: AFHTTPRequestOperation, responseObject: AnyObject?) in
      completion(responseObject: responseObject! as? NSObject, error: nil)
      }, failure: {(operation: AFHTTPRequestOperation, error: NSError) in
        completion(responseObject: nil, error: error)
    })
  }
  
}
