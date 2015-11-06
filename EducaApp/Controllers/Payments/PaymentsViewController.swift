//
//  PaymentsViewController.swift
//  EducaApp
//
//  Created by Alonso on 10/8/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

let PendingPaymentCellIdentifier = "PendingPaymentCell"
let CanceledPaymentCellIdentifier = "CanceledPaymentCell"
let DebtPaymentCellIdentifier = "DebtPaymentCell"

class PaymentsViewController: BaseViewController {

  @IBOutlet weak var tableView: UITableView!
  let GoToDepositSegueIdentifier = "GoToDepositSegue"
  
  var paymentConfig = PayPalConfiguration()
  
  var payments = [Payment]()
  
  // MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupElements()
    setupPayments()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    PayPalMobile.preconnectWithEnvironment(PayPalEnvironmentSandbox)
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
  
  private func setupPayments() {
    PaymentService.fetchPayments({(responseObject: AnyObject?, error: NSError?) in
      print(responseObject)
      guard let json = responseObject as? Array<NSDictionary> where json.count > 0 else {
        return
      }
      if (json[0][Constants.Api.ErrorKey] == nil) {
        let syncedPayments = Payment.syncWithJsonArray(json , ctx: self.dataLayer.managedObjectContext!)
        self.payments = syncedPayments
        print(self.payments.count)
        self.dataLayer.saveContext()
        self.tableView.reloadData()
      }
    })
  }
  
  // MARK: - Actions
  
  @IBAction func donateFixedAmout(sender: AnyObject) {
    let amount = NSDecimalNumber(string: "90.00")
    let payment = PayPalPayment()
    payment.amount = amount
    payment.currencyCode = "USD"
    payment.shortDescription = "Pago de Padrino"
    if (!payment.processable) {
    } else {
      let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: paymentConfig, delegate: self)
      self.presentViewController(paymentViewController, animated: true, completion: nil)
    }
  }
  
}

// MARK: - UITableViewDataSource

extension PaymentsViewController: UITableViewDataSource {

  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell: UITableViewCell
    if indexPath.row == 2 {
      cell = tableView.dequeueReusableCellWithIdentifier(PendingPaymentCellIdentifier, forIndexPath: indexPath)
    } else if indexPath.row == 3 {
      cell = tableView.dequeueReusableCellWithIdentifier(CanceledPaymentCellIdentifier, forIndexPath: indexPath)
    } else {
      cell = tableView.dequeueReusableCellWithIdentifier(DebtPaymentCellIdentifier, forIndexPath: indexPath)
    }
    return cell
  }
  
}

// MARK: - UITableViewDelegate

extension PaymentsViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let actionSheetController: UIAlertController = UIAlertController(title: "Método de Pago", message: "Seleccione un método de pago.", preferredStyle: .Alert)
    let payPalAction: UIAlertAction = UIAlertAction(title: "PayPal", style: .Default) { action -> Void in
      self.donateFixedAmout(NSNull)
    }
    actionSheetController.addAction(payPalAction)
    let depositAction: UIAlertAction = UIAlertAction(title: "Depósito", style: .Default) { action -> Void in
      self.performSegueWithIdentifier(self.GoToDepositSegueIdentifier, sender: nil)
    }
    actionSheetController.addAction(depositAction)
    self.presentViewController(actionSheetController, animated: true, completion: nil)
  }
  
}

// MARK: - PayPalPaymentDelegate

extension PaymentsViewController: PayPalPaymentDelegate {

  func payPalPaymentViewController(paymentViewController: PayPalPaymentViewController!, didCompletePayment completedPayment: PayPalPayment!) {
    print(completedPayment.description)
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func payPalPaymentDidCancel(paymentViewController: PayPalPaymentViewController!) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }

}
