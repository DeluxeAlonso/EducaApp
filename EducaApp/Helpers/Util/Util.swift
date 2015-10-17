//
//  Util.swift
//  EducaApp
//
//  Created by Alonso on 9/26/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class Util {
  
  class func fadeTransitionWithDuration(duration: Double) -> CATransition {
    let transition: CATransition = CATransition()
    transition.duration = duration
    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    transition.type = kCATransitionFade
    return transition
  }
  
  class func delay(delay: Double, closure:()->()) {
    dispatch_after(
      dispatch_time(
        DISPATCH_TIME_NOW,
        Int64(delay * Double(NSEC_PER_SEC))
      ),
      dispatch_get_main_queue(), closure)
  }

  class func needsPopoverPresentation(label: UILabel,string: NSString) -> Bool {
    let size = string.sizeWithAttributes([NSFontAttributeName: label.font])
    if size.width > 1000 {
      return true
    }
    return false
  }
  
}
