//
//  UserService.swift
//  EducaApp
//
//  Created by Alonso on 9/7/15.
//  Copyright (c) 2015 Alonso. All rights reserved.
//

import UIKit

let signInPath = "sign_in"

class UserService: NSObject {
  
  class func signInWithEmail(email: String!, password: String!, completion: (responseObject: NSObject?, error: NSError?) -> Void) {
    let manager = AFHTTPRequestOperationManager()
    let parameters = ["email": email, "password": password]
    
    manager.POST(UrlBuilder.UrlForPath(signInPath), parameters: parameters, success: { (operation: AFHTTPRequestOperation, responseObject: AnyObject?) in
      
        println("JSON: " + responseObject!.description)
        completion(responseObject: responseObject! as? NSObject, error: nil)
      
      }, failure: {(operation: AFHTTPRequestOperation, error: NSError) in
        
        println("Error: " + error.localizedDescription)
        completion(responseObject: nil, error: error)
      
    })
  }
  
}
