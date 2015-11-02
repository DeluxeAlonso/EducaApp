//
//  ArticleService.swift
//  EducaApp
//
//  Created by Alonso on 9/17/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

let ArticlesPath = "articles"

class ArticleService {
  
  class func fetchArticles( completion: (responseObject: NSObject?, error: NSError?) -> Void) {
    NetworkManager.sharedInstance.GET(UrlBuilder.UrlForApiaryPath(ArticlesPath), parameters: nil, success: { (operation: AFHTTPRequestOperation, responseObject: AnyObject?) in
      completion(responseObject: responseObject! as? NSObject, error: nil)
      }, failure: {(operation: AFHTTPRequestOperation, error: NSError) in
        completion(responseObject: nil, error: error)
    })
  }

}
