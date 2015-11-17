//
//  AppDelegate.swift
//  EducaApp
//
//  Created by Alonso on 9/1/15.
//  Copyright (c) 2015 Alonso. All rights reserved.
//

import UIKit
import CoreData

let GoogleMapsApiKey = "AIzaSyBF2bNxOCwEmwRcBjKoMxQja8cbldZ4CZs"
let GooglePlacesApiKey =  "AIzaSyAE2GOOBEjJA3p_S5Thh8P-0DJF7Y5F1Ww"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
  var deviceToken: String?
  
  lazy var dataLayer = DataLayer()
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: Constants.Notification.SignIn, object: nil);
    NSNotificationCenter.defaultCenter().removeObserver(self, name: Constants.Notification.SignOut, object: nil);
  }
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    if User.isSignedIn() == true {
      registerDeviceToken()
    }
    if let options = launchOptions {
      let notificationOptions: NSDictionary = (options as NSDictionary).objectForKey(UIApplicationLaunchOptionsRemoteNotificationKey) as! NSDictionary
      redirectView(notificationOptions["id"] as! Int)
    } else {
      launch()
    }
    dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.rawValue), 0)) {
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "signIn:", name: Constants.Notification.SignIn, object: nil)
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "signOut:", name: Constants.Notification.SignOut, object: nil)
    }
    PayPalMobile.initializeWithClientIdsForEnvironments([PayPalEnvironmentProduction: Constants.PayPal.Production, PayPalEnvironmentSandbox: Constants.PayPal.SandBox])
    GMSServices.provideAPIKey(GoogleMapsApiKey)
    return true
  }
  
  func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    var deviceTokenStr = deviceToken.description.stringByReplacingOccurrencesOfString(">", withString: "", options: [], range: nil)
    deviceTokenStr = deviceTokenStr.stringByReplacingOccurrencesOfString("<", withString: "", options: [], range: nil)
    deviceTokenStr = deviceTokenStr.stringByReplacingOccurrencesOfString(" ", withString: "", options: [], range: nil)
    deviceTokenStr = deviceTokenStr.lowercaseString
    self.deviceToken = deviceTokenStr
    UserService.sendDeviceToken(self.deviceToken!, completion: {(responseObject: AnyObject?, error: NSError?) in
      print(responseObject)
      print(error?.description)
    })
    print(self.deviceToken)
  }
  
  func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
  }
  
  func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
    Util.showAlertWithTitle(window?.rootViewController, title: "Notificación", message: userInfo["aps"]!["alert"] as! String, buttonTitle: "OK")
  }
  
  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(application: UIApplication) {
    UIApplication.sharedApplication().applicationIconBadgeNumber = 0
  }
  
  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    dataLayer.saveContext()
  }
  
  func registerDeviceToken() {
    let settings = UIUserNotificationSettings(forTypes: [.Sound, .Alert, .Badge], categories: nil)
    UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    UIApplication.sharedApplication().registerForRemoteNotifications()

  }
  
  func clearDeviceToken() {
    UIApplication.sharedApplication().unregisterForRemoteNotifications()
    UserService.signOut({(responseObject: AnyObject?, error: NSError?) in
      print(responseObject)
      print(error?.description)
    })
  }
  
  // Mark: - Private
  
  private func launch() {
    if User.isSignedIn()! {
      window?.rootViewController = getControllerWithIdentifier("MainViewController")
    }else{
      window?.rootViewController = storyboard.instantiateInitialViewController()
    }
    self.window?.makeKeyAndVisible()
  }
  
  private func redirectView(notificationId: Int) {
    switch notificationId {
    case 1:
      window?.rootViewController = getControllerWithIdentifier("SessionsMenuViewController")
    case 2:
      window?.rootViewController = getControllerWithIdentifier("PaymentsMenuViewController")
    case 3:
      window?.rootViewController = getControllerWithIdentifier("DocumentsMenuViewController")
    default:
      window?.rootViewController = getControllerWithIdentifier("PeriodsMenuViewController")
    }
    self.window?.makeKeyAndVisible()
  }
  
  private func getControllerWithIdentifier(identifier: String)-> UIViewController? {
    let controller = self.storyboard.instantiateViewControllerWithIdentifier(identifier)  as UIViewController?
    return controller
  }
  
  // MARK: - Notifications
  
  func signIn(notification: NSNotification) {
    registerDeviceToken()
    let signInViewController = window?.rootViewController
    let initialViewController: UIViewController = getControllerWithIdentifier("MainViewController")!
    
    let signInView: UIView = signInViewController!.view
    let initialView: UIView = initialViewController.view
    
    UIView.transitionFromView(signInView, toView: initialView, duration: 0.4, options: [UIViewAnimationOptions.CurveEaseOut, UIViewAnimationOptions.TransitionCrossDissolve], completion: { (finished: Bool) -> () in
          self.window?.rootViewController = initialViewController
        })
  }
  
  func signOut(notification: NSNotification) {
    clearDeviceToken()
    let settingsViewController = window?.rootViewController
    let signInViewController: UIViewController = getControllerWithIdentifier("SignInViewController")!
    
    let settingsView: UIView = settingsViewController!.view
    let signInView: UIView = signInViewController.view
    
    UIView.transitionFromView(settingsView, toView: signInView, duration: 0.4, options: [UIViewAnimationOptions.CurveEaseOut, UIViewAnimationOptions.TransitionCrossDissolve], completion: { (finished: Bool) -> () in
          self.window?.rootViewController = signInViewController
        })
  }
  
}

