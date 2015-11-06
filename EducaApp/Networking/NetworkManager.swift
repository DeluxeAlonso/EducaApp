//
//  NetworkManager.swift
//  EducaApp
//
//  Created by Alonso on 10/31/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class NetworkManager: AFHTTPRequestOperationManager {
  
  struct Singleton {
    static let sharedInstance = NetworkManager(url: NSURL(string: Constants.Path.Development)!)
  }
  
  class var sharedInstance: NetworkManager {
    return Singleton.sharedInstance
  }
  
  init(url:NSURL)
  {
    super.init(baseURL: url)
    let serializer = AFHTTPRequestSerializer()
    self.requestSerializer = serializer
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
}
