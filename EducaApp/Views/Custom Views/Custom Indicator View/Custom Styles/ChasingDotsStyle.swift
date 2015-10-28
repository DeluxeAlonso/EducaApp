//
//  ChasingDotsStyle.swift
//  EducaApp
//
//  Created by Alonso on 9/13/15.
//  Copyright (c) 2015 Alonso. All rights reserved.
//

import UIKit
import QuartzCore

class ChasingDotsStyle: CustomIndicatorProtocol {

  private let owner: CustomActivityIndicatorView
  
  private let spinnerView = UIView()
  private let ballCount = 5
  private let animationDuration = CFTimeInterval(4)
  
  init(indicatorView: CustomActivityIndicatorView) {
    self.owner = indicatorView
    
    for var index = 0; index < ballCount; ++index {
      let layer = CALayer()
      let layerBall = CALayer()
      layer.opacity = 0.0
      layer.addSublayer(layerBall)
      
      self.spinnerView.layer.addSublayer(layer)
    }
  }
  
  func needLayoutSubviews() {
    self.spinnerView.frame = self.owner.bounds
    
    let ballSize = CGFloat(self.owner.bounds.width / 9)
    
    for var index = 0; index < ballCount; ++index {
      guard let layer = self.spinnerView.layer.sublayers?[index], layerBall = layer.sublayers?[0] else {
        return
      }
      
      layer.frame = self.owner.bounds
      layerBall.frame = CGRect(x: ballSize, y: ballSize, width: ballSize, height: ballSize)
      
      layerBall.cornerRadius = layerBall.frame.size.width/2
    }
  }
  
  func needUpdateColor() {
    for item in self.spinnerView.layer.sublayers! {
      let layer = item 
      guard let layerBall = layer.sublayers?[0] else {
        return
      }
      layerBall.backgroundColor = self.owner.indicatorColor.CGColor
    }
  }
  
  func setUp() {
    //self.spinnerView.layer.shouldRasterize = true
  }
  
  func startActivity() {
    self.owner.addSubview(self.spinnerView)
    
    let beginTime = CACurrentMediaTime();
    let delays = [CFTimeInterval(1.56), CFTimeInterval(0.31), CFTimeInterval(0.62), CFTimeInterval(0.94), CFTimeInterval(1.25)]
    for var index = 0; index < ballCount; ++index {
      guard let layer = self.spinnerView.layer.sublayers?[index] else {
        return
      }
      
      let anim = CAKeyframeAnimation(keyPath: "transform.rotation.z")
      anim.duration = self.animationDuration
      anim.keyTimes = [0.0, 0.07, 0.3, 0.39, 0.7, 0.75, 0.76, 1.0]
      anim.timingFunctions = [
        CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut),
        CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear),
        CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
        CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear),
        CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut),
        CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut),
        CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault),
        CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault),
      ]
      var rotationsValues = [CGFloat(M_PI)]
      rotationsValues.append(CGFloat(rotationsValues[rotationsValues.count-1]) + CGFloat(M_PI*(300.0-180.0)/180.0))
      rotationsValues.append(CGFloat(rotationsValues[rotationsValues.count-1]) + CGFloat(M_PI*(410.0-300.0)/180.0))
      rotationsValues.append(CGFloat(rotationsValues[rotationsValues.count-1]) + CGFloat(M_PI*(645.0-410.0)/180.0))
      rotationsValues.append(CGFloat(rotationsValues[rotationsValues.count-1]) + CGFloat(M_PI*(770.0-645.0)/180.0))
      rotationsValues.append(CGFloat(rotationsValues[rotationsValues.count-1]) + CGFloat(M_PI*(900.0-770.0)/180.0))
      rotationsValues.append(CGFloat(rotationsValues[rotationsValues.count-1]) + CGFloat(0))
      rotationsValues.append(CGFloat(rotationsValues[rotationsValues.count-1]) + CGFloat(0))
      anim.values = rotationsValues
      
      let aniOpacity = CAKeyframeAnimation(keyPath: "opacity")
      aniOpacity.values = [0.0, 1.0, 0.0]
      aniOpacity.keyTimes = [0.0, 0.07, 0.3, 0.39, 0.7, 0.75, 0.76, 1.0]
      aniOpacity.values = [0.0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0]
      
      let aniGroup = CAAnimationGroup();
      aniGroup.fillMode = kCAFillModeForwards;
      aniGroup.removedOnCompletion = false
      aniGroup.repeatCount = HUGE
      aniGroup.duration = self.animationDuration;
      aniGroup.animations = [anim, aniOpacity];
      aniGroup.beginTime = beginTime + delays[index]
      
      layer.addAnimation(aniGroup, forKey: nil)
    }
  }
  
  func stopActivity(animated: Bool) {
    func removeAnimations() {
      self.spinnerView.layer.removeAllAnimations()
      
      for var index = 0; index < ballCount; ++index {
        guard let layer = self.spinnerView.layer.sublayers?[index] else {
          return
        }
        layer.removeAllAnimations()
      }
      
      self.spinnerView.removeFromSuperview()
    }
    
    if (animated) {
      self.spinnerView.layer.dismissAnimated(removeAnimations)
    }
    else {
      removeAnimations()
    }
    
  }
}
