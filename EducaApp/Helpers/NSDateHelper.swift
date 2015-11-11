//
//  NSDateHelper.swift
//  EducaApp
//
//  Created by Alonso on 11/10/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

extension NSDate {

  func getNumberOfDays() -> Int {
    return Int(self.timeIntervalSince1970 / 86400.0)
  }
  
}
