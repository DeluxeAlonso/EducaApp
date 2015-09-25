//
//  DonationsViewController.swift
//  EducaApp
//
//  Created by Alonso on 9/14/15.
//  Copyright (c) 2015 Alonso. All rights reserved.
//

import UIKit

class DonationsViewController: BaseViewController, PayPalPaymentDelegate {
  
  var paymentConfig = PayPalConfiguration()
  
  // MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupElements()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    PayPalMobile.preconnectWithEnvironment(PayPalEnvironmentSandbox)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Private
  
  private func setupElements() {
    setupBarButtonItem()
    configuratePayment()
  }
  
  private func configuratePayment() {
    paymentConfig.acceptCreditCards = true
    paymentConfig.languageOrLocale = "es"
  }
  
  // MARK: - Actions
  
  @IBAction func donateFixedAmout(sender: AnyObject) {
    let amount = NSDecimalNumber(string: "10.00")
    let payment = PayPalPayment()
    payment.amount = amount
    payment.currencyCode = "USD"
    payment.shortDescription = "AFI Payment"
    if (!payment.processable) {
      print("You messed up!")
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
  
}
