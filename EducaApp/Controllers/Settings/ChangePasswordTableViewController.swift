//
//  ChangePasswordTableViewController.swift
//  EducaApp
//
//  Created by Alonso on 10/21/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

enum ChangePasswordFieldsIndex: Int {
  case OldPassword
  case NewPassword
  case ConfirmPassword
}

class ChangePasswordTableViewController: BaseTableViewController {
  
  @IBOutlet var collectionOfViews: Array<UITextField>?
  @IBOutlet weak var customActivityIndicator: CustomActivityIndicatorView!
  @IBOutlet weak var changePasswordButton: UIButton!
  
  let ConfirmPasswordErrorAlertTitle = "Error"
  let ConfirmPasswordErrorAlertMessage = "Tu nueva contraseña no coincide con la contraseña confirmada."
  let ConfirmPasswordErrorAlertButton = "Ok"
  
  let ConfirmPasswordSuccessMessage = "!Se ha cambiado la contraseña de forma exitosa!"
  
  let ConfirmPasswordEmptyAlertMessage = "Todos los campos son obligatorios."
  
  let ChangePasswordButtonTitle = "Cambiar Contraseña"
  
  let changePasswordSelector: Selector = "changePassword:"
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Private
  
  private func enableSignInButton() {
    customActivityIndicator?.stopActivity()
    customActivityIndicator?.hidden = true
    changePasswordButton.userInteractionEnabled = true
    changePasswordButton.setTitle(ChangePasswordButtonTitle, forState: UIControlState.Normal)
  }
  
  private func disableSignInButton() {
    changePasswordButton.setTitle("", forState: UIControlState.Normal)
    customActivityIndicator?.startActivity()
    customActivityIndicator?.hidden = false
    changePasswordButton.userInteractionEnabled = false
  }
  
  private func clearTextFields() {
    collectionOfViews?.each { (textField) in
      textField.text = ""
    }
    view.endEditing(true)
  }
  
  private func changePassword() {
    disableSignInButton()
    let oldPassword = collectionOfViews?[ChangePasswordFieldsIndex.OldPassword.rawValue].text
    let newPassword = collectionOfViews?[ChangePasswordFieldsIndex.NewPassword.rawValue].text
    UserService.changePassword(oldPassword!, newPassword: newPassword!, completion: {(responseObject: AnyObject?, error: NSError?) in
      self.enableSignInButton()
      let json = responseObject
      if (json != nil && json?["error"]! == nil) {
        self.clearTextFields()
        let alertController = UIAlertController(title: self.ConfirmPasswordSuccessMessage, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        let defaultAction = UIAlertAction(title: self.ConfirmPasswordErrorAlertButton, style: UIAlertActionStyle.Default) { action -> Void in
          self.navigationController?.popViewControllerAnimated(true)
        }
        alertController.addAction(defaultAction)
        self.presentViewController(alertController, animated: true, completion: nil)
      } else {
        self.showAlertWithTitle(self.ConfirmPasswordErrorAlertTitle, message: json?["error"] as! String, buttonTitle: self.ConfirmPasswordErrorAlertButton)
      }
    })
  }
  
  // MARK: - Actions
  
  @IBAction func changePassword(sender: AnyObject) {
    let oldPassword = collectionOfViews?[ChangePasswordFieldsIndex.OldPassword.rawValue].text
    let newPassword = collectionOfViews?[ChangePasswordFieldsIndex.NewPassword.rawValue].text
    let confirmPassword = collectionOfViews?[ChangePasswordFieldsIndex.ConfirmPassword.rawValue].text
    guard oldPassword?.characters.count != 0 && newPassword?.characters.count != 0 && confirmPassword?.characters.count != 0 else {
      showAlertWithTitle(ConfirmPasswordErrorAlertTitle, message: ConfirmPasswordEmptyAlertMessage, buttonTitle: ConfirmPasswordErrorAlertButton)
      return
    }
    guard newPassword == confirmPassword else {
      showAlertWithTitle(ConfirmPasswordErrorAlertTitle, message: ConfirmPasswordErrorAlertMessage, buttonTitle: ConfirmPasswordErrorAlertButton)
      return
    }
    changePassword()
  }
  
}

// MARK: - UITextFieldDelegates

extension ChangePasswordTableViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    switch textField.tag {
    case 1:
      collectionOfViews?[ChangePasswordFieldsIndex.NewPassword.rawValue].becomeFirstResponder()
    case 2:
      collectionOfViews?[ChangePasswordFieldsIndex.ConfirmPassword.rawValue].becomeFirstResponder()
    case 3:
      collectionOfViews?[ChangePasswordFieldsIndex.ConfirmPassword.rawValue].resignFirstResponder()
      changePassword(NSNull)
    default:
      break
    }
    return true
  }
  
}
