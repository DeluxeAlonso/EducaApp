//
//  BaseTableViewController.swift
//  EducaApp
//
//  Created by Alonso on 10/21/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: - Public
  
  func showAlertWithTitle(title: String, message: String, buttonTitle: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    let defaultAction = UIAlertAction(title: buttonTitle, style: .Default, handler: nil)
    alertController.addAction(defaultAction)
    presentViewController(alertController, animated: true, completion: nil)
  }
  
}
