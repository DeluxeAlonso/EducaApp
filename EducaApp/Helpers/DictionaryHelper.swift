//
//  DictionaryHelper.swift
//  EducaApp
//
//  Created by Alonso on 9/6/15.
//  Copyright (c) 2015 Alonso. All rights reserved.
//

import Foundation

func toString(object: AnyObject) ->String {
  return String(format: "%@", object as! NSObject)
}

func urlEncode(object: AnyObject) -> String {
  let string = toString(object)
  return string.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
}

extension Dictionary {
  
  func urlEncodedString() -> String {
    let parts: NSMutableArray = NSMutableArray()
    for (key, value) in self {
      let part = String(format: "%@=%@", urlEncode(key as! NSObject), urlEncode(value as! NSObject))
      parts.addObject(part)
    }
    
    return parts.componentsJoinedByString("&")
  }
  
}
