//
//  DeserializationHelper.swift
//  EducaApp
//
//  Created by Alonso on 9/8/15.
//  Copyright (c) 2015 Alonso. All rights reserved.
//

import Foundation

///Interface for model classes to parse JSON from the API.
protocol Deserializable {
  
  func setDataFromJSON(json: NSDictionary)
  
}
