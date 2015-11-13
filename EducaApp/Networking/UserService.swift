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
let ReapplyPath = "reapply"
let SendPhotoPath = "?q=photoupload"

class UserService {
  
  class func signInWithEmail(email: String!, password: String!, completion: (responseObject: NSObject?, error: NSError?) -> Void) {
    let manager = AFHTTPRequestOperationManager()
    let parameters = ["username": email, "password": password]
    manager.POST(UrlBuilder.UrlForPath(SignInPath), parameters: parameters, success: { (operation: AFHTTPRequestOperation, responseObject: AnyObject?) in
        completion(responseObject: responseObject! as? NSObject, error: nil)
      }, failure: { (operation: AFHTTPRequestOperation, error: NSError) in
        completion(responseObject: nil, error: error)
    })
  }
  
  class func reapply(period_id: Int, completion: (responseObject: NSObject?, error: NSError?) -> Void){
    let parameters = ["period_id": period_id]
    NetworkManager.sharedInstance.requestSerializer.setValue(User.getAuthToken(), forHTTPHeaderField: Constants.Api.Header)
    NetworkManager.sharedInstance.POST(UrlBuilder.UrlForPath(ReapplyPath), parameters: parameters, success: { (operation: AFHTTPRequestOperation, responseObject: AnyObject?) in
      completion(responseObject: responseObject! as? NSObject, error: nil)
      }, failure: {( operation: AFHTTPRequestOperation, error: NSError) in
        completion(responseObject: nil, error: error)
    })
  }
  
  class func changePassword(oldPassword: String, newPassword: String, completion: (responseObject: NSObject?, error: NSError?) -> Void) {
    let parameters = ["current_password": oldPassword, "new_password": newPassword]
    NetworkManager.sharedInstance.requestSerializer.setValue(User.getAuthToken(), forHTTPHeaderField: Constants.Api.Header)
    NetworkManager.sharedInstance.PUT(UrlBuilder.UrlForPath(ChangePasswordPath), parameters: parameters, success: { (operation: AFHTTPRequestOperation, responseObject: AnyObject?) in
        completion(responseObject: responseObject! as? NSObject, error: nil)
      }, failure: {( operation: AFHTTPRequestOperation, error: NSError) in
        completion(responseObject: nil, error: error)
    })
  }
  
  class func recoverPassword(email: String, completion: (responseObject: NSObject?, error: NSError?) -> Void) {
    let parameters = ["email": email]
    NetworkManager.sharedInstance.requestSerializer.setValue(User.getAuthToken(), forHTTPHeaderField: Constants.Api.Header)
    NetworkManager.sharedInstance.POST(UrlBuilder.UrlForPath(RecoverPasswordPath), parameters: parameters, success: { (operation: AFHTTPRequestOperation, responseObject: AnyObject?) in
      completion(responseObject: responseObject! as? NSObject, error: nil)
      }, failure: {( operation: AFHTTPRequestOperation, error: NSError) in
        completion(responseObject: nil, error: error)
    })
  }
  
  class func fetchUsers(completion: (responseObject: NSObject?, error: NSError?) -> Void) {
    NetworkManager.sharedInstance.requestSerializer.setValue(User.getAuthToken(), forHTTPHeaderField: Constants.Api.Header)
    NetworkManager.sharedInstance.GET(UrlBuilder.UrlForPath(UsersPath), parameters: nil, success: { (operation: AFHTTPRequestOperation, responseObject: AnyObject?) in
      completion(responseObject: responseObject! as? NSObject, error: nil)
      }, failure: {(operation: AFHTTPRequestOperation, error: NSError) in
        completion(responseObject: nil, error: error)
    })
  }
  
  class func sendPhoto(image: UIImage, completion: (responseObject: NSObject?, error: NSError?) -> Void) {
    NetworkManager.sharedInstance.POST(UrlBuilder.UrlForDrupalPath(SendPhotoPath), parameters: nil,
      constructingBodyWithBlock: { (formData: AFMultipartFormData!) in
        if let imageData: NSData = UIImagePNGRepresentation(image)! {
          formData.appendPartWithFileData(imageData, name: "image", fileName: "imagen", mimeType: "image/png")
        }
      },
      success: { (operation: AFHTTPRequestOperation, responseObject: AnyObject?) in
        completion(responseObject: responseObject! as? NSObject, error: nil)
      }, failure: {(operation: AFHTTPRequestOperation, error: NSError) in
        completion(responseObject: nil, error: error)
    })
  }
  
}
