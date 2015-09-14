//
//  SignInViewController.swift
//  EducaApp
//
//  Created by Alonso on 9/3/15.
//  Copyright (c) 2015 Alonso. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var logoImageView: UIImageView!
  @IBOutlet weak var trailingLogoConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var usernameContainerView: UIView!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var usernameTextField: UITextField!
  
  @IBOutlet weak var passwordContainerView: UIView!
  @IBOutlet weak var passwordLabel: UILabel!
  @IBOutlet weak var passwordTextField: UITextField!
  
  @IBOutlet weak var signInButton: UIButton!
  @IBOutlet weak var loaderIndicator: CustomActivityIndicatorView!
  
  @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
  
  var initialBottomHeight: CGFloat!
  
  lazy var dataLayer = DataLayer()
  
  let kAlertMessageTitle = "Error"
  let kEmptyUsernamePasswordMessage = "Username and Password cannot be blank."
  
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
    usernameTextField.delegate = self
    passwordTextField.delegate = self
    usernameLabel.textColor = UIColor.grayColor()
    passwordLabel.textColor = UIColor.grayColor()
    usernameContainerView.layer.borderColor = UIColor.defaultBorderFieldColor().CGColor
    passwordContainerView.layer.borderColor = UIColor.defaultBorderFieldColor().CGColor
  }
  
  private func setupAdditionalConstraints() {
    var screenRect: CGRect = UIScreen.mainScreen().bounds
    initialBottomHeight = screenRect.size.height / 3
    bottomConstraint.constant = initialBottomHeight
  }
  
  private func showEmptyUsernameOrPasswordAlert() {
    let alertController = UIAlertController(title: kAlertMessageTitle, message: kEmptyUsernamePasswordMessage, preferredStyle: UIAlertControllerStyle.Alert)
    
    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
    alertController.addAction(defaultAction)
    
    presentViewController(alertController, animated: true, completion: nil)
  }
  
  private func enableSignInButton() {
    loaderIndicator?.stopActivity()
    loaderIndicator?.hidden = true
    signInButton.userInteractionEnabled = true
    signInButton.setTitle("Iniciar Sesión", forState: UIControlState.Normal)
  }
  
  private func disableSignInButton() {
    signInButton.setTitle("", forState: UIControlState.Normal)
    loaderIndicator?.startActivity()
    loaderIndicator?.hidden = false
    signInButton.userInteractionEnabled = false
  }
  
  // MARK: - Actions
  
  @IBAction func hideKeyboard(sender: AnyObject) {
    usernameTextField.resignFirstResponder()
    passwordTextField.resignFirstResponder()
  }
  
  @IBAction func signIn(sender: AnyObject) {
    let email = usernameTextField.text
    let password = passwordTextField.text
    if ( count(email) == 0 || count(password) == 0 ) {
      showEmptyUsernameOrPasswordAlert()
    } else {
      disableSignInButton()
      UserService.signInWithEmail(email, password: password, completion: {(responseObject: AnyObject?, error: NSError?) in
        self.enableSignInButton()
        if let json = responseObject as? NSDictionary {
          if json["error"] == nil {
            let user = User.updateOrCreateWithJson(json, ctx: self.dataLayer.managedObjectContext!)
            self.dataLayer.saveContext()
            User.setAuthenticatedUser(user!)
            print(User.getAuthenticatedUser(self.dataLayer.managedObjectContext!)?.description)
            NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notification.SignIn, object: self, userInfo: nil)
          } else {
            //Show Error Message
          }
        }
      })
    }
  }
  
  // MARK:- UITextFieldDelegates
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    switch textField.tag {
    case 1:
      passwordTextField.becomeFirstResponder()
      break
    case 2:
      textField.resignFirstResponder()
      signIn(NSNull)
      break
    default:
      break
    }
    return true
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
