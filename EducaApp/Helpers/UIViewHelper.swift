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
  
}
