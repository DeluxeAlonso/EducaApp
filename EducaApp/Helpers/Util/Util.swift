//
//  Util.swift
//  EducaApp
//
//  Created by Alonso on 9/26/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class Util {

  class func needsPopoverPresentation(label: UILabel,string: NSString) -> Bool {
    let size = string.sizeWithAttributes([NSFontAttributeName: label.font])
    print(size)
    if size.width > 1000 {
      return true
    }
    return false
  }
  
}
