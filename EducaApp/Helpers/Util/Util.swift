//
//  Util.swift
//  EducaApp
//
//  Created by Alonso on 9/26/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit
import SystemConfiguration

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
  
  class func showAlertWithTitle(controller: UIViewController?,title: String, message: String, buttonTitle: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    let defaultAction = UIAlertAction(title: buttonTitle, style: .Default, handler: nil)
    alertController.addAction(defaultAction)
    controller!.presentViewController(alertController, animated: true, completion: nil)
  }
  
  class func showNoInternetAlert(controller: UIViewController) {
    Util.showAlertWithTitle(controller, title: "No se encontro una red.", message: "Tus cambios seran enviados cuando la señal sea detectada.", buttonTitle: "OK")
  }
  
  class func connectedToNetwork() -> Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    guard let defaultRouteReachability = withUnsafePointer(&zeroAddress, {
      SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
    }) else {
      return false
    }
    
    var flags : SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
      return false
    }
    
    let isReachable = flags.contains(.Reachable)
    let needsConnection = flags.contains(.ConnectionRequired)
    return (isReachable && !needsConnection)
  }
  
}
