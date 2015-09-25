//
//  BaseViewController.swift
//  EducaApp
//
//  Created by Alonso on 9/24/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

let kBarButtonSelector: Selector = "revealToggle:"

class BaseViewController: UIViewController, SWRevealViewControllerDelegate {
  
  @IBOutlet weak var menuIcon: UIBarButtonItem!
  
  var tapGesture: UITapGestureRecognizer?
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.revealViewController().delegate = self
    // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)
    setupBarButtonItem()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Private
  
   func setupBarButtonItem() {
    if self.revealViewController() != nil {
      menuIcon?.target = self.revealViewController()
      menuIcon?.action = kBarButtonSelector
      tapGesture = UITapGestureRecognizer(target: self.revealViewController(), action: kBarButtonSelector)
      view.addGestureRecognizer(tapGesture!)
      tapGesture?.enabled = false
      view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
  }
  
  // MARK - SWRevealViewControllerDelegate
  
  func revealController(revealController: SWRevealViewController!, willMoveToPosition position: FrontViewPosition) {
    if position == FrontViewPosition.Right {
      self.tapGesture?.enabled = true
    } else if position == FrontViewPosition.Left {
      self.tapGesture?.enabled = false
    }
  }
  
}
