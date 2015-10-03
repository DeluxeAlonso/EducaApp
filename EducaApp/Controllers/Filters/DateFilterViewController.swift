//
//  DateFilterViewController.swift
//  EducaApp
//
//  Created by Alonso on 9/30/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class DateFilterViewController: UIViewController {
  
  let rightBarButtonItemTitle = "Seleccionar"
  let advancedSearchSelector: Selector = "selectDate:"
  
  var height: CGFloat?
  
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
    self.popupController?.popViewControllerAnimated(true)
  }
  
}
