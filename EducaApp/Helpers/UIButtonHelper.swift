//
//  UIButtonHelper.swift
//  EducaApp
//
//  Created by Alonso on 9/1/15.
//  Copyright (c) 2015 Alonso. All rights reserved.
//

import Foundation

extension UIButton {
  
  func setBorderShadow() {
    self.layer.shadowColor = UIColor.blackColor().CGColor
    self.layer.shadowOffset = CGSizeMake(1, 1)
    self.layer.shadowRadius = 2
    self.layer.shadowOpacity = 0.5
  }
  
}