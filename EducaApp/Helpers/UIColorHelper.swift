//
//  UIColorHelper.swift
//  EducaApp
//
//  Created by Alonso on 9/4/15.
//  Copyright (c) 2015 Alonso. All rights reserved.
//

import Foundation

extension UIColor {
  
  class func colorWithR(r: Int, green g:Int, blue b: Int, alpha a:Float) -> UIColor {
    return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(a))
  }
  
  class func defaultBorderFieldColor() -> UIColor {
    return UIColor.colorWithR(193, green: 193, blue: 193, alpha: 1)
  }
  
  class func defaultBlackBorderFieldColor() -> UIColor {
    return UIColor.blackColor()
  }
  
}
