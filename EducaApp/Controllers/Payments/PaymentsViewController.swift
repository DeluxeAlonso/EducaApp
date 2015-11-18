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
let PendingApprovalPaymentCellIdentifier = "PendingApprovalPaymentCell"

class PaymentsViewController: BaseViewController {
  
  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var customLoader: CustomActivityIndicatorView!
  @IBOutlet weak var noCalendarLabel: UILabel!
  
  let GoToDepositSegueIdentifier = "GoToDepositSegue"
  let ConversionRateApiUrl = "http://download.finance.yahoo.com/d/quotes.csv?s=USDPEN=X&f=nl1d1t1"
  
  var paymentConfig = PayPalConfiguration()
  var payments = [Payment]()
  var selectedPayment: Payment?
  
  // MARK:- Lifecycle
  
  override func viewDidLoad() {
    customLoader.startActivity()
    super.viewDidLoad()
    setupElements()
  }
  
  override func viewWillAppear(animated: Bool) {
    customLoader.startActivity()
    super.viewWillAppear(animated)
    if let currencyFactor = NSUserDefaults.standardUserDefaults().doubleForKey("currency") as Double? where currencyFactor != 0.0 {
      print(currencyFactor)
      setupPayments()
      PayPalMobile.preconnectWithEnvironment(PayPalEnvironmentSandbox)
    } else {
      setupCurrencyFactor()
    }
  }
  
  // MARK: - Private
  
  private func setupElements() {
    setupBarButtonItem()
    configuratePayment()
  }
  
  private func setupCurrencyFactor() {
    let url = NSURL(string: ConversionRateApiUrl);
    let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
      print(NSString(data: data!, encoding: NSUTF8StringEncoding))
      guard let string = NSString(data: data!, encoding: NSUTF8StringEncoding) else {
        return
      }
      NSUserDefaults.standardUserDefaults().setDouble(Double(string.componentsSeparatedByString(",")[1])!, forKey: "currency")
      NSUserDefaults.standardUserDefaults().synchronize()
      self.setupPayments()
      PayPalMobile.preconnectWithEnvironment(PayPalEnvironmentSandbox)
    }
    task.resume()
  }
  
  private func configuratePayment() {
    paymentConfig.acceptCreditCards = true
    paymentConfig.languageOrLocale = "es"
  }
  
  private func setupPayments() {
    payments = Payment.getAllPayments(self.dataLayer.managedObjectContext!)
    guard payments.count == 0 else {
      tableView.hidden = false
      tableView.reloadData()
      getPayments()
      return
    }
    tableView.hidden = true
    customLoader.startActivity()
    getPayments()
  }
  
  private func getPayments() {
    PaymentService.fetchPayments({(responseObject: AnyObject?, error: NSError?) in
      guard let json = responseObject as? Array<NSDictionary> where json.count > 0 else {
        if Util.connectedToNetwork() {
          self.headerView.hidden = true
          self.noCalendarLabel.hidden = false
          self.tableView.hidden = true
        }
        self.customLoader.stopActivity()
        return
      }
      if (json[0][Constants.Api.ErrorKey] == nil) {
        let syncedPayments = Payment.syncWithJsonArray(json , ctx: self.dataLayer.managedObjectContext!)
        self.payments = syncedPayments
        self.dataLayer.saveContext()
        self.tableView.hidden = false
        self.tableView.reloadData()
      }
    })
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.destinationViewController is UINavigationController {
      let navController = segue.destinationViewController as! UINavigationController
      let vc = navController.viewControllers.first as! DepositPaymentTableViewController
      vc.payment = sender as? Payment
    }
  }
  
  // MARK: - Actions
  
  @IBAction func donateFixedAmout(sender: AnyObject) {
    let fmt = NSNumberFormatter()
    fmt.positiveFormat = "0.##"
    let amount = NSDecimalNumber(string: fmt.stringFromNumber(NSNumber(float: sender as! Float)))
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
    return payments.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell: UITableViewCell
    if indexPath.row == payments.count - 1 {
      customLoader.stopActivity()
    }
    switch payments[indexPath.row].status {
    case 0:
      cell = tableView.dequeueReusableCellWithIdentifier(DebtPaymentCellIdentifier, forIndexPath: indexPath)
      (cell as! DebtPaymentTableViewCell).setupPayment(payments[indexPath.row])
    case 1:
      cell = tableView.dequeueReusableCellWithIdentifier(PendingPaymentCellIdentifier, forIndexPath: indexPath)
      (cell as! PendingPaymentTableViewCell).setupPayment(payments[indexPath.row])
    case 2:
      cell = tableView.dequeueReusableCellWithIdentifier(CanceledPaymentCellIdentifier, forIndexPath: indexPath)
      (cell as! CanceledPaymentTableViewCell).setupPayment(payments[indexPath.row])
    default:
      cell = tableView.dequeueReusableCellWithIdentifier(PendingApprovalPaymentCellIdentifier, forIndexPath: indexPath)
      (cell as! PendingApprovalPaymentTableViewCell).setupPayment(payments[indexPath.row])
    }
    return cell
  }
  
}

// MARK: - UITableViewDelegate

extension PaymentsViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let cell = tableView.cellForRowAtIndexPath(indexPath)
    selectedPayment = payments[indexPath.row]
    if (cell is PendingApprovalPaymentTableViewCell || cell is CanceledPaymentTableViewCell) {
      return
    }
    
    let actionSheetController: UIAlertController = UIAlertController(title: "Método de Pago", message: "Seleccione un método de pago.", preferredStyle: .ActionSheet)
    
    let payPalAction: UIAlertAction = UIAlertAction(title: "PayPal", style: .Default) { action -> Void in
      if let currencyFactor = NSUserDefaults.standardUserDefaults().doubleForKey("currency") as Double? {
        self.donateFixedAmout(self.payments[indexPath.row].amount / Float(currencyFactor))
      }
    }
    actionSheetController.addAction(payPalAction)
    
    let depositAction: UIAlertAction = UIAlertAction(title: "Depósito", style: .Default) { action -> Void in
      self.performSegueWithIdentifier(self.GoToDepositSegueIdentifier, sender: self.payments[indexPath.row])
    }
    actionSheetController.addAction(depositAction)
    
    let cancel = UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil)
    actionSheetController.addAction(cancel)
    
    if let popoverController = actionSheetController.popoverPresentationController {
      popoverController.sourceView = cell
      popoverController.sourceRect = cell!.bounds
      
    }
    
    self.presentViewController(actionSheetController, animated: true, completion: nil)
  }
  
}

// MARK: - PayPalPaymentDelegate

extension PaymentsViewController: PayPalPaymentDelegate {
  
  func payPalPaymentViewController(paymentViewController: PayPalPaymentViewController!, didCompletePayment completedPayment: PayPalPayment!) {
    let info = NSMutableDictionary()
    info["amount"] = completedPayment.amount
    info["currency_code"] = completedPayment.currencyCode
    let paymentInfo = info as NSDictionary
    PaymentService.verifyPayment(completedPayment.confirmation["response"]!["id"] as! String, feeID: Int((selectedPayment?.id)!), paymentInfo: paymentInfo, completion: { (responseObject: AnyObject?, error: NSError?) in
      print(responseObject)
      print(error?.description)
      if error == nil {
        self.getPayments()
      }
    })
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func payPalPaymentDidCancel(paymentViewController: PayPalPaymentViewController!) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
}
