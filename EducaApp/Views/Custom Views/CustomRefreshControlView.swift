//
//  CustomRefreshControlView.swift
//  EducaApp
//
//  Created by Alonso on 9/19/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class CustomRefreshControlView: UIRefreshControl {
  
  let XibIdentifier = "RefreshContentsView"
  
  var customView: UIView!
  
  var labelsArray: Array<UILabel> = []
  
  var isAnimating = false
  var currentColorIndex = 0
  var currentLabelIndex = 0

  // MARK: - Lifecycle
  
  override init() {
    super.init()
    setupView()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  // MARK: - Private
  
  private func setupView() {
    let refreshContents = NSBundle.mainBundle().loadNibNamed(XibIdentifier, owner: self, options: nil)
    customView = refreshContents[0] as! UIView
    customView.backgroundColor = UIColor.defaultRefreshControlColor()
    customView.frame = self.bounds
    customView.clipsToBounds = true
    self.addSubview(customView)
    self.tintColor = UIColor.clearColor()
    self.backgroundColor = UIColor.clearColor()
    for var i=0; i<customView.subviews.count; ++i {
      labelsArray.append(customView.viewWithTag(i + 1) as! UILabel)
    }
  }

  func animateRefreshFirstStep() {
    isAnimating = true
    UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
      self.labelsArray[self.currentLabelIndex].transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
      self.labelsArray[self.currentLabelIndex].textColor = self.getNextColor()
      
      }, completion: { (finished) -> Void in
        
        UIView.animateWithDuration(0.05, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
          self.labelsArray[self.currentLabelIndex].transform = CGAffineTransformIdentity
          self.labelsArray[self.currentLabelIndex].textColor = UIColor.blackColor()
          
          }, completion: { (finished) -> Void in
            ++self.currentLabelIndex
            
            if self.currentLabelIndex < self.labelsArray.count {
              self.animateRefreshFirstStep()
            }
            else {
              self.animateRefreshSecondStep()
            }
        })
    })
  }
  
  func animateRefreshSecondStep() {
    UIView.animateWithDuration(0.35, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
        self.labelsArray.each { (label) in
          label.transform = CGAffineTransformMakeScale(1.5, 1.5)
        }
      }, completion: { (finished) -> Void in
        UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.labelsArray.each { (label) in
              label.transform = CGAffineTransformIdentity
            }
          }, completion: { (finished) -> Void in
            if self.refreshing {
              self.currentLabelIndex = 0
              self.animateRefreshFirstStep()
            }
            else {
              self.isAnimating = false
              self.currentLabelIndex = 0
              for var i=0; i<self.labelsArray.count; ++i {
                self.labelsArray[i].textColor = UIColor.blackColor()
                self.labelsArray[i].transform = CGAffineTransformIdentity
              }
            }
        })
    })
  }
  
  func getNextColor() -> UIColor {
    var colorsArray: Array<UIColor> = [UIColor.magentaColor(), UIColor.brownColor(), UIColor.yellowColor(), UIColor.redColor(), UIColor.greenColor(), UIColor.blueColor(), UIColor.orangeColor()]
    if currentColorIndex == colorsArray.count {
      currentColorIndex = 0
    }
    let returnColor = colorsArray[currentColorIndex]
    ++currentColorIndex
    return returnColor
  }
  
}
