//
//  DonationsViewController.swift
//  EducaApp
//
//  Created by Alonso on 9/14/15.
//  Copyright (c) 2015 Alonso. All rights reserved.
//

import UIKit

class DonationsViewController: BaseViewController, PayPalPaymentDelegate, UITextFieldDelegate {
  
  @IBOutlet weak var donationBarButtonItem: UIBarButtonItem!
  
  @IBOutlet weak var donationAmountTextField: UITextField!
  @IBOutlet weak var termsButtonBottomConstraints: NSLayoutConstraint!
  
  var paymentConfig = PayPalConfiguration()
  var isKeyboardVisible = false
  var initialBottonContraintConstant: CGFloat?
  
  // MARK:- Lifecycle
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil);
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil);
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupElements()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    donationAmountTextField.becomeFirstResponder()
    PayPalMobile.preconnectWithEnvironment(PayPalEnvironmentSandbox)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Private
  
  private func setupElements() {
    setupObservers()
    configuratePayment()
    setupAdittionalConstraints()
  }
  
  private func setupObservers() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Constants.KeyboardSelector.WillShow, name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Constants.KeyboardSelector.WillHide, name: UIKeyboardWillHideNotification, object: nil)
  }
  
  private func configuratePayment() {
    paymentConfig.acceptCreditCards = true
    paymentConfig.languageOrLocale = "es"
  }
  
  private func setupAdittionalConstraints() {
    initialBottonContraintConstant = termsButtonBottomConstraints.constant
  }
  
  // MARK: - Actions
  
  @IBAction func donateFixedAmout(sender: AnyObject) {
    let amount = NSDecimalNumber(string: donationAmountTextField.text)
    let payment = PayPalPayment()
    payment.amount = amount
    payment.currencyCode = "USD"
    payment.shortDescription = "Donación"
    if (!payment.processable) {
    } else {
      let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: paymentConfig, delegate: self)
      self.presentViewController(paymentViewController, animated: true, completion: nil)
    }
  }
  
  // MARK: - PayPalPaymentDelegate
  
  func payPalPaymentViewController(paymentViewController: PayPalPaymentViewController!, didCompletePayment completedPayment: PayPalPayment!) {
    print(completedPayment.description)
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func payPalPaymentDidCancel(paymentViewController: PayPalPaymentViewController!) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  // MARK: - Notifications
  
  func keyboardWillShow(notification: NSNotification) {
    guard !isKeyboardVisible else {
      return
    }
    isKeyboardVisible = true
    view.layoutIfNeeded()
    if let keyboardFrame: CGRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
      let keyboardHeight = CGFloat(keyboardFrame.size.height)
      termsButtonBottomConstraints.constant += keyboardHeight
      view.layoutIfNeeded()
    }
  }
  
  func keyboardWillHide(notification: NSNotification) {
    guard isKeyboardVisible else {
      return
    }
    isKeyboardVisible = false
    view.layoutIfNeeded()
    termsButtonBottomConstraints.constant = initialBottonContraintConstant!
    view.layoutIfNeeded()
    view.endEditing(true)
  }
  
  // MARK: - UITextFieldDelegate
  
  func textFieldDidBeginEditing(textField: UITextField) {
    donationBarButtonItem.enabled = true
  }
  
  
  // MARK: - SWRevealViewControllerDelegate
  
  override func revealController(revealController: SWRevealViewController!, willMoveToPosition position: FrontViewPosition) {
    super.revealController(revealController, willMoveToPosition: position)
    if position == FrontViewPosition.Left {
      donationAmountTextField.becomeFirstResponder()
    }
  }
  
}
