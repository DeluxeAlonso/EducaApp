//
//  DepositPaymentViewController.swift
//  EducaApp
//
//  Created by Alonso on 10/8/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class DepositPaymentTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
  
  var payment: Payment?
  var selectedDate: NSDate?
  var pickerOption = ["BANCO DE CREDITO DEL PERU", "BBVA BANCO CONTINENTAL", "INTERBANK", "SCOTIABANK"]
  
  @IBOutlet weak var voucherTextField: UITextField!
  @IBOutlet weak var dateTextField: UITextField!
  @IBOutlet weak var bankTextField: UITextField!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    setupDatePicker()
    setupBankPicker()
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
  
  func setupBankPicker(){
    let bankPickerView = UIPickerView()
    bankPickerView.delegate = self
    bankPickerView.backgroundColor = UIColor.whiteColor()
    bankTextField.inputView = bankPickerView
  }
  
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return pickerOption.count
  }
  
  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return pickerOption[row]
  }
  
  func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    bankTextField.text = pickerOption[row]
  }

  
  @IBAction func dimissDepositForm(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func registerPayment(sender: AnyObject) {
    let feeId = "\(payment!.id)"
    let voucherCode = voucherTextField.text
    selectedDate = selectedDate ?? NSDate()
    let date = Double(selectedDate!.timeIntervalSince1970)
    let bank = bankTextField.text
    
    guard ( voucherCode!.characters.count != 0 && dateTextField.text!.characters.count != 0 && bankTextField.text!.characters.count != 0) else {
      Util.showAlertWithTitle(self, title: "Error", message: "Los campos no pueden estar en blanco.", buttonTitle: "OK")
      return
    }
    
    PaymentService.registerPayment(feeId, voucherCode: voucherCode!, bank: bank!, date: date, completion: {(responseObject: AnyObject?, error: NSError?) in
      print(error?.description)
      let json = responseObject
      
      if (json != nil && json?["error"]! == nil) {
        let alertController = UIAlertController(title: "Enhorabuena!", message: "Se registro el voucher con éxito", preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { action -> Void in
          self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(okAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
      } else {
        Util.showAlertWithTitle(self, title: "Error", message: "No se puede registrar el voucher", buttonTitle: "OK")
      }
    })
  }
  
}
