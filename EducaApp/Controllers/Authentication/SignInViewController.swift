//
//  SignInViewController.swift
//  EducaApp
//
//  Created by Alonso on 9/3/15.
//  Copyright (c) 2015 Alonso. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
  
  @IBOutlet weak var logoImageView: UIImageView!
  
  @IBOutlet weak var usernameContainerView: UIView!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var usernameTextField: UITextField!
  
  @IBOutlet weak var passwordContainerView: UIView!
  @IBOutlet weak var passwordLabel: UILabel!
  @IBOutlet weak var passwordTextField: UITextField!
  
  @IBOutlet weak var signInButton: UIButton!
  
  @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
  
  var initialBottomHeight: CGFloat!
  
  // MARK: - Lifecycle
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil);
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil);
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupElements()
  }
  
  // MARK: - Private
  
  private func setupElements() {
    setupObservers()
    setupInputFields()
    setupAdditionalConstraints()
  }
  
  private func setupObservers() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:",
      name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
  }
  
  private func setupInputFields() {
    usernameLabel.textColor = UIColor.lightGrayColor()
    passwordLabel.textColor = UIColor.lightGrayColor()
    usernameContainerView.layer.borderColor = UIColor.defaultBorderFieldColor().CGColor
    passwordContainerView.layer.borderColor = UIColor.defaultBorderFieldColor().CGColor
  }
  
  private func setupAdditionalConstraints() {
    var screenRect: CGRect = UIScreen.mainScreen().bounds
    initialBottomHeight = screenRect.size.height / 3
    bottomConstraint.constant = initialBottomHeight
  }
  
  // MARK: - Actions
  
  @IBAction func hideKeyboard(sender: AnyObject) {
    usernameTextField.resignFirstResponder()
    passwordTextField.resignFirstResponder()
  }
  
  // MARK: - Notifications
  
  func keyboardWillShow(notification: NSNotification) {
    view.layoutIfNeeded()
    if let keyboardFrame: CGRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
      var keyboardHeight = CGFloat(keyboardFrame.size.height) + CGFloat(20)
      var diff: CGFloat = keyboardHeight - CGFloat(bottomConstraint.constant)
      if diff > 0 {
        bottomConstraint.constant = keyboardFrame.size.height + 20
        if let logoOffSet = logoImageView?.frame.origin.y {
          if (logoOffSet - diff < 20) {
            self.logoImageView.alpha = 0.0
          }
        }
        view.layoutIfNeeded()
      }
    }
  }
  
  func keyboardWillHide(notification: NSNotification) {
    view.layoutIfNeeded()
    bottomConstraint.constant = self.initialBottomHeight;
    logoImageView.alpha = 1.0;
    view.layoutIfNeeded()
    view.endEditing(true)
  }
  
}
