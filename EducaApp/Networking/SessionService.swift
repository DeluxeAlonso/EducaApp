//
//  SessionService.swift
//  EducaApp
//
//  Created by Alonso on 10/21/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

let SessionsPath = "sessions"
let EditReunionPointsPath = "meeting_points"

class SessionService {

  class func fetchSessions(completion: (responseObject: NSObject?, error: NSError?) -> Void) {
    NetworkManager.sharedInstance.GET(UrlBuilder.UrlForPath(SessionsPath), parameters: nil, success: { (operation: AFHTTPRequestOperation, responseObject: AnyObject?) in
      completion(responseObject: responseObject! as? NSObject, error: nil)
      }, failure: {(operation: AFHTTPRequestOperation, error: NSError) in
        completion(responseObject: nil, error: error)
    })
  }
  
  class func editReunionPoints(parameters: NSDictionary, completion: (responseObject: NSObject?, error: NSError?) -> Void) {
    let manager = AFHTTPRequestOperationManager()
    let serializer = AFJSONRequestSerializer()
    serializer.setValue(User.getAuthToken(), forHTTPHeaderField: Constants.Api.Header)
    manager.requestSerializer = serializer
    manager.reachabilityManager.setReachabilityStatusChangeBlock({ (status) in
      if status == AFNetworkReachabilityStatus.ReachableViaWWAN || status == AFNetworkReachabilityStatus.ReachableViaWiFi {
        manager.POST(UrlBuilder.UrlForPath(EditReunionPointsPath), parameters: parameters, success: { (operation: AFHTTPRequestOperation, responseObject: AnyObject?) in
          completion(responseObject: responseObject! as? NSObject, error: nil)
          }, failure: {(operation: AFHTTPRequestOperation, error: NSError) in
            completion(responseObject: nil, error: error)
        })
      }
    })
    manager.reachabilityManager.startMonitoring()
  }

}
