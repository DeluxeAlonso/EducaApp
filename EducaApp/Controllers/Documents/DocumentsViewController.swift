//
//  DocumentsViewController.swift
//  EducaApp
//
//  Created by Alonso on 9/20/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class DocumentsViewController: UIViewController {
  
  var session:Session?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupElements()
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Private
  
  private func setupElements() {
    setupBarButtonItem()
  }
  
  private func setupBarButtonItem() {
    if self.revealViewController() != nil && session == nil{
      let menuIcon = UIBarButtonItem(title: nil, style: UIBarButtonItemStyle.Plain, target: self.revealViewController(), action: kBarButtonSelector)
      menuIcon.image = UIImage(named: "MenuIcon")
      self.navigationItem.leftBarButtonItem = menuIcon
    }
    self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
  }
  
  // MARK: - Actions
  
  @IBAction func goBack(sender: AnyObject) {
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
}
