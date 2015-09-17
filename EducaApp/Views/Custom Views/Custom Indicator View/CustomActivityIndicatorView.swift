//
//  CustomActivityIndicatorView.swift
//  EducaApp
//
//  Created by Alonso on 9/13/15.
//  Copyright (c) 2015 Alonso. All rights reserved.
//

import UIKit
import QuartzCore
import Foundation

@IBDesignable
class CustomActivityIndicatorView: UIView {
  
  private var runningWithinInterfaceBuilder: Bool = false
  private var activityStarted: Bool = false
  private var currentAnimation: CustomIndicatorProtocol? = nil
  
  @IBInspectable var indicatorColor: UIColor = UIColor.whiteColor() {
    didSet {
      if (self.currentAnimation != nil) {
        self.currentAnimation!.needUpdateColor()
      }
    }
  }
  
  @IBInspectable var indicatorStyle: String = CustomIndicatorStyle.convInv(.defaultValue)
  
  // MARK: - Lifecycle
  
  override init(frame: CGRect) {
    super.init(frame: frame);
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  deinit {
    if (self.activityStarted) {
      self.stopActivity(false)
    }
  }
  
  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    self.runningWithinInterfaceBuilder = true
    setUpColors();
  }
  
  override func layoutSubviews() {
    if (self.currentAnimation != nil) {
      currentAnimation!.needLayoutSubviews()
    }
  }
  
  override func drawRect(rect: CGRect) {
    super.drawRect(rect)
    
    if (self.runningWithinInterfaceBuilder) {
      let context = UIGraphicsGetCurrentContext()
      CGContextSaveGState(context)
      
      var arrayOfDashLength: [CGFloat] = [2.0, 2.0]
      CGContextSetStrokeColorWithColor(context, self.indicatorColor.CGColor)
      var dash = { (phase: CGFloat, lengths: UnsafePointer<CGFloat>, count: Int) -> Void in
        CGContextSetLineDash(context, phase, lengths, count)
      }
      dash(0.0, arrayOfDashLength, arrayOfDashLength.count)
      
      CGContextStrokeRect(context, self.bounds)
      
      CGContextRestoreGState(context)
    }
  }
  
  override func sizeThatFits(size: CGSize) -> CGSize {
    if (size.width < 20.0) {
      return CGSize(width: 20.0, height: 20.0)
    }
    // force width = height
    return CGSize(width: size.width, height: size.width)
  }
  
  // MARK: - Private
  
  private func setUpAnimation() {
    let style = CustomIndicatorStyle.conv(self.indicatorStyle)
    
    switch style {
    case .chasingDots:self.currentAnimation = ChasingDotsStyle(indicatorView: self)
    case .spotifyLike:self.currentAnimation = SpotifyLikeStyle(indicatorView: self)
    }
    
    self.setUpColors()
  }
  
  private func setUpColors() {
    self.backgroundColor = UIColor.clearColor()
    
    if (self.currentAnimation != nil) {
      self.currentAnimation!.needUpdateColor()
    }
  }
  
  // MARK: - Public
  
  func startActivity() {
    if (self.activityStarted) {
      return
    }
    
    self.activityStarted = true
    self.setUpAnimation()
    
    currentAnimation!.needLayoutSubviews()
    currentAnimation!.setUp()
    currentAnimation!.startActivity()
  }
  
  func stopActivity(animated: Bool) {
    if (!self.activityStarted) {
      return
    }
    
    self.activityStarted = false;
    currentAnimation!.stopActivity(animated)
  }
  
  func stopActivity() {
    self.stopActivity(true)
  }
  
}

