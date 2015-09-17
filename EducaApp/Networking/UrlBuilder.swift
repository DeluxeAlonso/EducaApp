//
//  UrlBuilder.swift
//  EducaApp
//
//  Created by Alonso on 9/6/15.
//  Copyright (c) 2015 Alonso. All rights reserved.
//

import UIKit

class UrlBuilder: NSObject {
  
  class func UrlForPath (path: String) -> String {
    return self.UrlForPathWithParameters(path: path, parameters: nil)
  }
  
  class func UrlForPathWithParameters (path path: String, parameters: Dictionary<String,String>?) -> String {
    var stringUrl: String
    if (parameters == nil) {
      stringUrl = String(format: "%@%@", Constants.Path.Development, path)
    } else {
      stringUrl = String(format: "%@%@?%@", Constants.Path.Development, path, parameters!)
    }
    
    return stringUrl
  }
   
}
