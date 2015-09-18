//
//  ArticleService.swift
//  EducaApp
//
//  Created by Alonso on 9/17/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

let kArticlesPath = "articles"

class ArticleService {
  
  class func fetchArticles( completion: (responseObject: NSObject?, error: NSError?) -> Void) {
    let manager = AFHTTPRequestOperationManager()
    manager.GET(UrlBuilder.UrlForPath(kArticlesPath), parameters: nil, success: { (operation: AFHTTPRequestOperation, responseObject: AnyObject?) in
      print(responseObject)
      completion(responseObject: responseObject! as? NSObject, error: nil)
      }, failure: {(operation: AFHTTPRequestOperation, error: NSError) in
        completion(responseObject: nil, error: error)
    })
  }

}
