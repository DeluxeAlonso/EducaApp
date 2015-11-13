//
//  DateFilterViewController.swift
//  EducaApp
//
//  Created by Alonso on 9/30/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

protocol DateFilterViewControllerDelegate {
  
  func dateFilterViewController(dateFilterViewController: DateFilterViewController, selectedDate: NSDate, indexPath: NSIndexPath)
  
}

class DateFilterViewController: UIViewController {
  
  @IBOutlet weak var datePicker: UIDatePicker!
  
  let rightBarButtonItemTitle = "Seleccionar"
  let advancedSearchSelector: Selector = "selectDate:"
  
  var indexPath: NSIndexPath?
  var height: CGFloat?
  var delegate: DateFilterViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    self.contentSizeInPopup = CGSizeMake(300, height!)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Private
  
  private func setupNavigationBar() {
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: rightBarButtonItemTitle, style: UIBarButtonItemStyle.Plain, target: self, action: advancedSearchSelector)
  }
  
  // MARK: - Actions
  
  @IBAction func selectDate(sender: AnyObject) {
    delegate?.dateFilterViewController(self, selectedDate: datePicker.date, indexPath: indexPath!)
    self.popupController?.popViewControllerAnimated(true)
  }
  
}
