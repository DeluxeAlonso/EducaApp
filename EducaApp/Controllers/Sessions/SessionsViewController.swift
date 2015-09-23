//
//  SessionsViewController.swift
//  EducaApp
//
//  Created by Alonso on 9/20/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

let kSessionsCellIdentifier =  "SessionCell"
let kSessionDocumentsSegueIdentifier = "GoToDocumentsSegue"
let kSessionVolunteersSegueIdentifier = "GoToVolunteersList"
let kSessionAssistantsSegueIdentifier = "GoToAssistants"

class SessionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SessionTableViewCellDelegate {
  
  @IBOutlet weak var menuIcon: UIBarButtonItem!
  @IBOutlet weak var menuContentView: UIView!
  @IBOutlet weak var menuHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var shadowView: UIView!
  
  var initialHeightConstraintConstant: CGFloat?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupBarButtonItem()
    setupMenuView()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    setupPanGesture()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Private
  
  private func setupBarButtonItem() {
    if self.revealViewController() != nil {
      self.menuIcon.target = self.revealViewController()
      self.menuIcon.action = kBarButtonSelector
    }
  }
  
  private func setupPanGesture() {
    if self.revealViewController() != nil {
      self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
  }
  
  private func setupMenuView() {
    initialHeightConstraintConstant = menuHeightConstraint.constant
    menuContentView.clipsToBounds = true
    menuHeightConstraint.constant = 0
    
  }
  
  private func showMenuView() {
    self.navigationController?.view.addSubview(self.shadowView)
    self.navigationController?.view.addSubview(self.menuContentView)
    UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
      self.shadowView.alpha = 0.35
      self.menuContentView.frame = CGRect(x: self.menuContentView.frame.origin.x, y: self.menuContentView.frame.origin.y - self.initialHeightConstraintConstant!, width: self.menuContentView.frame.width, height: self.initialHeightConstraintConstant!)
      }, completion: nil)
    shadowView.userInteractionEnabled = true
  }
  
  private func hideMenuViewWithoutAnimation () {
    self.shadowView.alpha = 0.0
    self.menuContentView.frame = CGRect(x: self.menuContentView.frame.origin.x, y: self.menuContentView.frame.origin.y + self.initialHeightConstraintConstant!, width: self.menuContentView.frame.width, height: self.initialHeightConstraintConstant!)
  }
  
  // MARK: - Actions
  
  @IBAction func hideMenuView(sender: AnyObject) {
    UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
        self.hideMenuViewWithoutAnimation()
      }, completion: nil)
  }
  
  @IBAction func goToSessionDocuments(sender: AnyObject) {
    hideMenuViewWithoutAnimation()
    performSegueWithIdentifier(kSessionDocumentsSegueIdentifier, sender: nil)
  }
  
  @IBAction func goToSessionMap(sender: AnyObject) {
  }
  
  @IBAction func goToAssistantsList(sender: AnyObject) {
    hideMenuViewWithoutAnimation()
    performSegueWithIdentifier(kSessionAssistantsSegueIdentifier, sender: nil)
  }
  
  @IBAction func goToVolunteersList(sender: AnyObject) {
    hideMenuViewWithoutAnimation()
    performSegueWithIdentifier(kSessionVolunteersSegueIdentifier, sender: nil)
  }
  
  // MARK: - Navigation
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.destinationViewController is DocumentsViewController) {
      let destinationVC = segue.destinationViewController as! DocumentsViewController;
      destinationVC.session = Session()
    }
  }
  
  // MARK: - UITableViewDataSource
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(kSessionsCellIdentifier, forIndexPath: indexPath) as! SessionTableViewCell
    cell.delegate = self
    
    return cell
  }
  
  // MARK: - UITableViewDelegate
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  // MARK: - SessionTableViewCellDelegate
  
  func sessionTableViewCell(sessionTableViewCell: SessionTableViewCell, menuButtonDidTapped button: UIButton) {
    print("menuButtonDidTapped")
    showMenuView()
  }
  
}
