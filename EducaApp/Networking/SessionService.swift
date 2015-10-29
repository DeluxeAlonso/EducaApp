//
//  SessionService.swift
//  EducaApp
//
//  Created by Alonso on 10/21/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

let SessionsPath = "sessions"

class SessionService {

  class func fetchSessions(completion: (responseObject: NSObject?, error: NSError?) -> Void) {
    let manager = AFHTTPRequestOperationManager()
    let serializer = AFHTTPRequestSerializer()
    serializer.setValue(User.getAuthToken(), forHTTPHeaderField: Constants.Api.Header)
    manager.requestSerializer = serializer
    manager.GET(UrlBuilder.UrlForPath(SessionsPath), parameters: nil, success: { (operation: AFHTTPRequestOperation, responseObject: AnyObject?) in
      completion(responseObject: responseObject! as? NSObject, error: nil)
      }, failure: {(operation: AFHTTPRequestOperation, error: NSError) in
        completion(responseObject: nil, error: error)
    })
  }
  
}
