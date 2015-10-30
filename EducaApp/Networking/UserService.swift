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
let RecoverPasswordPath = "recover_password"
let UsersPath = "users"

class UserService {
  
  class func signInWithEmail(email: String!, password: String!, completion: (responseObject: NSObject?, error: NSError?) -> Void) {
    let manager = AFHTTPRequestOperationManager()
    let parameters = ["username": email, "password": password]
    manager.POST(UrlBuilder.UrlForPath(SignInPath), parameters: parameters, success: { (operation: AFHTTPRequestOperation, responseObject: AnyObject?) in
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
  
  class func recoverPassword(email: String, completion: (responseObject: NSObject?, error: NSError?) -> Void) {
    let manager = AFHTTPRequestOperationManager()
    let serializer = AFHTTPRequestSerializer()
    manager.requestSerializer = serializer
    let parameters = ["email": email]
    manager.POST(UrlBuilder.UrlForPath(RecoverPasswordPath), parameters: parameters, success: { (operation: AFHTTPRequestOperation, responseObject: AnyObject?) in
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
    manager.GET(UrlBuilder.UrlForPath(UsersPath), parameters: nil, success: { (operation: AFHTTPRequestOperation, responseObject: AnyObject?) in
      completion(responseObject: responseObject! as? NSObject, error: nil)
      }, failure: {(operation: AFHTTPRequestOperation, error: NSError) in
        completion(responseObject: nil, error: error)
    })
  }
  
}
