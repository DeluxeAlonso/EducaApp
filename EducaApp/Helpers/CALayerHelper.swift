//
//  CALayerHelper.swift
//  EducaApp
//
//  Created by Alonso on 9/13/15.
//  Copyright (c) 2015 Alonso. All rights reserved.
//

import UIKit
import QuartzCore

let kAnimationScalePath = "transform.scale"
let kAnimationFacePath = "opacity"

extension CALayer {
  func dismissAnimated(completionBlock: () -> Void) {
    CATransaction.begin()
    CATransaction.setCompletionBlock { () -> Void in
      completionBlock()
    }
    let aniScale = CABasicAnimation()
    aniScale.keyPath = kAnimationScalePath
    aniScale.toValue = 0.0;
    
    let aniFade = CABasicAnimation()
    aniFade.keyPath = kAnimationFacePath
    aniFade.toValue = 0.0
    
    let aniGroup = CAAnimationGroup();
    aniGroup.removedOnCompletion = false
    aniGroup.animations = [aniScale, aniFade];
    aniGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    aniGroup.duration = CFTimeInterval(0.25)
    aniGroup.fillMode = kCAFillModeForwards
    
    self.addAnimation(aniGroup, forKey: nil)
    CATransaction.commit()
  }
}

protocol CustomIndicatorProtocol {
  func needUpdateColor()
  func needLayoutSubviews()
  func setUp()
  
  func startActivity()
  func stopActivity(animated: Bool)
}