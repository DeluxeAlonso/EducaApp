//
//  DepositPaymentViewController.swift
//  EducaApp
//
//  Created by Alonso on 10/8/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class DepositPaymentTableViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
  }
  
  func setupNavigationBar() {
    UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
    view.backgroundColor = UIColor.defaultBackgroundColor()
    navigationController?.navigationBar.barTintColor = UIColor.defaultTextColor()
    navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
  }
  
  @IBAction func dimissDepositForm(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
}
