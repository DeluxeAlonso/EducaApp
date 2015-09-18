//
//  UserService.swift
//  EducaApp
//
//  Created by Alonso on 9/7/15.
//  Copyright (c) 2015 Alonso. All rights reserved.
//

import UIKit

let kSignInPath = "sign_in"

class UserService {
  
  class func signInWithEmail(email: String!, password: String!, completion: (responseObject: NSObject?, error: NSError?) -> Void) {
    let manager = AFHTTPRequestOperationManager()
    let parameters = ["email": email, "password": password]
    manager.POST(UrlBuilder.UrlForPath(kSignInPath), parameters: parameters, success: { (operation: AFHTTPRequestOperation, responseObject: AnyObject?) in
        completion(responseObject: responseObject! as? NSObject, error: nil)
      }, failure: {(operation: AFHTTPRequestOperation, error: NSError) in
        completion(responseObject: nil, error: error)
    })
  }
  
}
