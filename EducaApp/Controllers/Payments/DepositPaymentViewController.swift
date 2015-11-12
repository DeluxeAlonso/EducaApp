//
//  DepositPaymentViewController.swift
//  EducaApp
//
//  Created by Alonso on 10/8/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class DepositPaymentTableViewController: UITableViewController {
  
  var payment: Payment?
  var selectedDate: NSDate?
  
  @IBOutlet weak var voucherTextField: UITextField!
  @IBOutlet weak var dateTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    setupDatePicker()
  }
  
  func setupNavigationBar() {
    UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
    view.backgroundColor = UIColor.defaultBackgroundColor()
    navigationController?.navigationBar.barTintColor = UIColor.defaultTextColor()
    navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
  }
  
  func setupDatePicker(){
    let datePickerView:UIDatePicker = UIDatePicker()
    datePickerView.datePickerMode = UIDatePickerMode.Date
    datePickerView.backgroundColor = UIColor.whiteColor()
    datePickerView.addTarget(self, action: Selector("datePickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    dateTextField.inputView = datePickerView
  }
  
  func datePickerValueChanged(sender:UIDatePicker) {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
    dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
    dateTextField.text = dateFormatter.stringFromDate(sender.date)
    selectedDate = sender.date
  }
  
  @IBAction func dimissDepositForm(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func registerPayment(sender: AnyObject) {
    let feeId = "\(payment!.id)"
    let voucherCode = voucherTextField.text
    let date = Double(selectedDate!.timeIntervalSince1970)
    PaymentService.registerPayment(feeId, voucherCode: voucherCode!, date: date, completion: {(responseObject: AnyObject?, error: NSError?) in
      print(error?.description)
      let json = responseObject
      if (json != nil && json?["error"]! == nil) {
        Util.showAlertWithTitle(self, title: "Enhorabuena!", message: "Se registro el voucher con éxito", buttonTitle: "OK")
      } else {
        Util.showAlertWithTitle(self, title: "Error", message: "No se puede registrar el voucher", buttonTitle: "OK")
      }
    })
  }
  
}
