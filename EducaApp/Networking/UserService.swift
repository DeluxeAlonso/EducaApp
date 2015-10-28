//
//  UserService.swift
//  EducaApp
//
//  Created by Alonso on 9/7/15.
//  Copyright (c) 2015 Alonso. All rights reserved.
//

import UIKit

let SignInPath = "sign_in"
let ChangePasswordPath = "change_password"
let UsersPath = "users"

class UserService {
  
  class func signInWithEmail(email: String!, password: String!, completion: (responseObject: NSObject?, error: NSError?) -> Void) {
    let manager = AFHTTPRequestOperationManager()
    let parameters = ["username": email, "password": password]
    manager.POST(UrlBuilder.UrlForApiaryPath(SignInPath), parameters: parameters, success: { (operation: AFHTTPRequestOperation, responseObject: AnyObject?) in
      print(responseObject)
        completion(responseObject: responseObject! as? NSObject, error: nil)
      }, failure: { (operation: AFHTTPRequestOperation, error: NSError) in
        completion(responseObject: nil, error: error)
    })
  }
  
  class func changePassword(oldPassword: String, newPassword: String, completion: (responseObject: NSObject?, error: NSError?) -> Void) {
    let manager = AFHTTPRequestOperationManager()
    let serializer = AFHTTPRequestSerializer()
    serializer.setValue(User.getAuthToken(), forHTTPHeaderField: Constants.Api.Header)
    manager.requestSerializer = serializer
    let parameters = ["current_password": oldPassword, "new_password": newPassword]
    manager.PUT(UrlBuilder.UrlForPath(ChangePasswordPath), parameters: parameters, success: { (operation: AFHTTPRequestOperation, responseObject: AnyObject?) in
        completion(responseObject: responseObject! as? NSObject, error: nil)
      }, failure: {( operation: AFHTTPRequestOperation, error: NSError) in
        completion(responseObject: nil, error: error)
    })
  }
  
  class func fetchUsers(completion: (responseObject: NSObject?, error: NSError?) -> Void) {
    let manager = AFHTTPRequestOperationManager()
    let serializer = AFHTTPRequestSerializer()
    serializer.setValue(User.getAuthToken(), forHTTPHeaderField: Constants.Api.Header)
    manager.requestSerializer = serializer
    manager.GET(UrlBuilder.UrlForApiaryPath(UsersPath), parameters: nil, success: { (operation: AFHTTPRequestOperation, responseObject: AnyObject?) in
      completion(responseObject: responseObject! as? NSObject, error: nil)
      }, failure: {(operation: AFHTTPRequestOperation, error: NSError) in
        completion(responseObject: nil, error: error)
    })
  }
  
}
