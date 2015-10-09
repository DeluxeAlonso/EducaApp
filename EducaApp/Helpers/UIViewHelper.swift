//
//  UIViewHelper.swift
//  EducaApp
//
//  Created by Alonso on 9/28/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

extension UIView {
  
  func scaleToSize(scaleSize: CGFloat, duration: NSTimeInterval) {
    UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.25, initialSpringVelocity: 5.0, options: [], animations: {
        self.transform = CGAffineTransformMakeScale(scaleSize, scaleSize)
      }, completion: nil)
  }
  
  func restoreWithDuration(duration: NSTimeInterval) {
    UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5.0, options: [], animations: {
        self.transform = CGAffineTransformIdentity
      }, completion: nil)
  }
  
  func fadeOut(duration: NSTimeInterval) {
    UIView.animateWithDuration(duration) {
      self.alpha = 0.0
    }
  }
  
  func fadeIn(duration: NSTimeInterval) {
    UIView.animateWithDuration(duration) {
      self.alpha = 1.0
    }
  }
  
  class func viewFromNibName(name: String) -> UIView? {
    let views = NSBundle.mainBundle().loadNibNamed(name, owner: nil, options: nil)
    return views.first as? UIView
  }
  
  func setShadowBorder() {
    self.layer.shadowColor = UIColor.blackColor().CGColor
    self.layer.shadowOffset = CGSizeMake(1, 1)
    self.layer.shadowRadius = 2
    self.layer.shadowOpacity = 0.5
  }
  
}
