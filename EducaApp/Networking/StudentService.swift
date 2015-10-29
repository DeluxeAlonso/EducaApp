//
//  StudentService.swift
//  EducaApp
//
//  Created by Alonso on 10/27/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

let StudentsPath = "children"

class StudentService {
  
  class func fetchStudents(completion: (responseObject: NSObject?, error: NSError?) -> Void) {
    let manager = AFHTTPRequestOperationManager()
    let serializer = AFHTTPRequestSerializer()
    serializer.setValue(User.getAuthToken(), forHTTPHeaderField: Constants.Api.Header)
    manager.requestSerializer = serializer
    manager.GET(UrlBuilder.UrlForPath(StudentsPath), parameters: nil, success: { (operation: AFHTTPRequestOperation, responseObject: AnyObject?) in
      completion(responseObject: responseObject! as? NSObject, error: nil)
      }, failure: {(operation: AFHTTPRequestOperation, error: NSError) in
        completion(responseObject: nil, error: error)
    })
  }

}
