//
//  DocumentService.swift
//  EducaApp
//
//  Created by Alonso on 11/3/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

let DocumentsPath = "documents"
let VisualizateDocumentPath = "visualizations"

class DocumentService {
  
  class func fetchDocuments(completion: (responseObject: NSObject?, error: NSError?) -> Void) {
    NetworkManager.sharedInstance.requestSerializer.setValue(User.getAuthToken(), forHTTPHeaderField: Constants.Api.Header)
    NetworkManager.sharedInstance.GET(UrlBuilder.UrlForPath(DocumentsPath), parameters: nil, success: { (operation: AFHTTPRequestOperation, responseObject: AnyObject?) in
      completion(responseObject: responseObject! as? NSObject, error: nil)
      }, failure: {(operation: AFHTTPRequestOperation, error: NSError) in
        completion(responseObject: nil, error: error)
    })
  }
  
  class func visualizateDocument(documentId: Int, completion: (responseObject: NSObject?, error: NSError?) -> Void) {
    NetworkManager.sharedInstance.requestSerializer.setValue(User.getAuthToken(), forHTTPHeaderField: Constants.Api.Header)
    NetworkManager.sharedInstance.POST(UrlBuilder.UrlForPath("\(DocumentsPath)/\(documentId)/\(VisualizateDocumentPath)"), parameters: nil, success: { (operation: AFHTTPRequestOperation, responseObject: AnyObject?) in
      completion(responseObject: responseObject! as? NSObject, error: nil)
      }, failure: {(operation: AFHTTPRequestOperation, error: NSError) in
        completion(responseObject: nil, error: error)
    })
  }
  
}
