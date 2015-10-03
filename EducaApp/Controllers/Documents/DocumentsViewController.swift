//
//  DocumentsViewController.swift
//  EducaApp
//
//  Created by Alonso on 9/20/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

let DocumentCellIdentifier = "DocumentCell"
let DocumentsNavigationItemTitle = "Documentos"

class DocumentsViewController: BaseFilterViewController, UITableViewDataSource, UITableViewDelegate, DocumentTableViewCellDelegate {
  
  @IBOutlet weak var shadowView: UIView!
  @IBOutlet weak var menuContentView: UIView!
  @IBOutlet weak var menuHeightConstraint: NSLayoutConstraint!
  
  let UserListSegueIdentifier = "GoToUserListSegue"
  
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
    setupSearchBar()
    setupMenuView()
    getDocuments()
  }
  
  override func setupBarButtonItem() {
    super.setupBarButtonItem()
    if self.revealViewController() != nil && session == nil {
      let menuIcon = UIBarButtonItem(title: nil, style: UIBarButtonItemStyle.Plain, target: self.revealViewController(), action: kBarButtonSelector)
      menuIcon.image = UIImage(named: MenuIconImageName)
      self.navigationItem.setLeftBarButtonItem(menuIcon, animated: false)
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
    hideSearchBarAnimated(false)
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
  
  private func hideSearchBarAnimated(animated: Bool) {
    let duration = animated ? 0.3 : 0
    searchBar.resignFirstResponder()
    UIView.animateWithDuration(duration, animations: {
      self.navigationItem.titleView?.alpha = 0
      }, completion: { finished in
          self.setupBarButtonItem()
          self.navigationItem.title = DocumentsNavigationItemTitle
          self.navigationItem.titleView = nil
    })
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
  
  @IBAction func showSearchBar(sender: AnyObject) {
    navigationItem.titleView = searchBar
    searchBar.alpha = 0
    UIView.animateWithDuration(0.5, animations: {
      self.searchBar.alpha = 1
      self.searchBar.becomeFirstResponder()
      }, completion: { finished in
    })
  }
  
  @IBAction func goToUsersList(sender: AnyObject) {
    hideMenuViewWithoutAnimation()
    performSegueWithIdentifier(UserListSegueIdentifier, sender: Document())
  }
  
  // MARK: - Navigation
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.destinationViewController is UsersViewController) {
      let destinationVC = segue.destinationViewController as! UsersViewController;
      destinationVC.document = Document()
    }
  }
  
  // MARK: - UITableViewDataSource
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (documents.count)
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(DocumentCellIdentifier, forIndexPath: indexPath) as! DocumentTableViewCell
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
  
  //MARK: - UISearchBarDelegate
  
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    hideSearchBarAnimated(true)
  }
  
}
