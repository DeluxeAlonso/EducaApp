//
//  UIFontHelper.swift
//  EducaApp
//
//  Created by Alonso on 9/30/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

extension UIFont {

  class func regularFontWithFontSize(size: CGFloat) -> UIFont {
    return UIFont(name: "HelveticaNeue", size: size)!
  }
  
  class func lightFontWithFontSize(size: CGFloat) -> UIFont {
    return UIFont(name: "HelveticaNeue-Light", size: size)!
  }
  
}
