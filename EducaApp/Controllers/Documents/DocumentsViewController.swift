//
//  DocumentsViewController.swift
//  EducaApp
//
//  Created by Alonso on 9/20/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

let kDocumentCellIdentifier = "DocumentCell"

class DocumentsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, DocumentTableViewCellDelegate {
  
  @IBOutlet weak var shadowView: UIView!
  @IBOutlet weak var menuContentView: UIView!
  
  @IBOutlet weak var menuHeightConstraint: NSLayoutConstraint!
  var session:Session?
  var documents: NSMutableArray = []
  var initialHeightConstraintConstant: CGFloat?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupElements()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Private
  
  private func setupElements() {
    setupBarButtonItem()
    setupMenuView()
    getDocuments()
  }
  
  override func setupBarButtonItem() {
    super.setupBarButtonItem()
    if self.revealViewController() != nil && session == nil {
      let menuIcon = UIBarButtonItem(title: nil, style: UIBarButtonItemStyle.Plain, target: self.revealViewController(), action: kBarButtonSelector)
      menuIcon.image = UIImage(named: "MenuIcon")
      self.navigationItem.leftBarButtonItem = menuIcon
    }
    self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
  }
  
  private func setupMenuView() {
    initialHeightConstraintConstant = menuHeightConstraint.constant
    menuContentView.clipsToBounds = true
    menuHeightConstraint.constant = 0
  }
  
  private func getDocuments() {
    for i in 0..<Int((Constants.MockData.DocumentsName.count)) {
      let document = Document()
      document.title = Constants.MockData.DocumentsName[i] as? String
      document.size = Constants.MockData.DocumentsSize[i] as? String
      document.uploadDate = Constants.MockData.DocumentsUploadTime[i] as? String
      document.imageIcon = UIImage(named: (Constants.MockData.DocumentsImage[i] as? String)!)
      documents.addObject(document)
    }
  }
  
  private func showMenuView() {
    self.shadowView.translatesAutoresizingMaskIntoConstraints = true
    self.menuContentView.translatesAutoresizingMaskIntoConstraints = true
    self.navigationController?.interactivePopGestureRecognizer?.enabled = false
    self.navigationController?.view.addSubview(self.shadowView)
    self.navigationController?.view.addSubview(self.menuContentView)
    UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
      self.shadowView.alpha = 0.35
      self.menuContentView.frame = CGRect(x: self.menuContentView.frame.origin.x, y: self.menuContentView.frame.origin.y - self.initialHeightConstraintConstant!, width: self.menuContentView.frame.width, height: self.initialHeightConstraintConstant!)
      }, completion: nil)
    shadowView.userInteractionEnabled = true
  }
  
  private func hideMenuViewWithoutAnimation () {
    self.navigationController?.interactivePopGestureRecognizer?.enabled = true
    self.shadowView.alpha = 0.0
    self.menuContentView.frame = CGRect(x: self.menuContentView.frame.origin.x, y: self.menuContentView.frame.origin.y + self.initialHeightConstraintConstant!, width: self.menuContentView.frame.width, height: self.initialHeightConstraintConstant!)
  }
  
  // MARK: - Actions
  
  @IBAction func goBack(sender: AnyObject) {
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  @IBAction func hideMenuView(sender: AnyObject) {
    self.navigationController?.interactivePopGestureRecognizer?.enabled = true
    UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
      self.hideMenuViewWithoutAnimation()
      }, completion: nil)
  }
  
  // MARK: - UITableViewDataSource
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (documents.count)
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(kDocumentCellIdentifier, forIndexPath: indexPath) as! DocumentTableViewCell
    cell.setupDocument(documents[indexPath.row] as! Document)
    cell.delegate = self
    return cell
  }
  
  // MARK: - UITableViewDelegate
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  // MARK: - DocumentTableViewCellDelegate
  
  func documentTableViewCell(documentTableViewCell: DocumentTableViewCell, menuButtonDidTapped button: UIButton) {
    showMenuView()
  }
  
}
