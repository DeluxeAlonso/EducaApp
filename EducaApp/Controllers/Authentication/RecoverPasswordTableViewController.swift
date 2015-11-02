//
//  RecoverPasswordTableViewController.swift
//  EducaApp
//
//  Created by Gloria Cisneros on 18/10/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class RecoverPasswordTableViewController: UITableViewController {
  
  @IBOutlet weak var emailTextField: UITextField!
  
  var delegate: SignInViewController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    contentSizeInPopup = CGSizeMake(300, 200)
    setupNavigationBar()
    self.title = "Recuperar Contraseña"
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func setupNavigationBar() {
    UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
    view.backgroundColor = UIColor.defaultBackgroundColor()
    navigationController?.navigationBar.barTintColor = UIColor.defaultTextColor()
    navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
  }
  
  @IBAction func recoverPassword(sender: AnyObject) {
    emailTextField.resignFirstResponder()
    (delegate! as SignInViewController).recoverPassword(emailTextField.text!)
  }
  
}
