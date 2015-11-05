//
//  UsersViewController.swift
//  EducaApp
//
//  Created by Alonso on 10/1/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

let UsersFilterViewControllerIdentifier = "UsersFilterViewController"
let UserTableViewCellIdentifier = "UserCell"

class UsersViewController: BaseFilterViewController {
  
  let UsersViewControllerTitle = "Usuarios"
  let DocumentUserTableViewCellIdentifier = "DocumentUserCell"
  
  var popupViewController: STPopupController?
  var documentUsers: [DocumentUser]?
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  // MARK: - Private
  
  private func setupPopupNavigationBar() {
    STPopupNavigationBar.appearance().barTintColor = UIColor.defaultTextColor()
    STPopupNavigationBar.appearance().tintColor = UIColor.whiteColor()
    STPopupNavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.lightFontWithFontSize(17)]
  }
  
  override func setupBarButtonItem() {
    super.setupBarButtonItem()
    if self.revealViewController() != nil && documentUsers == nil {
      let menuIcon = UIBarButtonItem(title: nil, style: UIBarButtonItemStyle.Plain, target: self.revealViewController(), action: MenuButtonSelector)
      menuIcon.image = UIImage(named: ImageAssets.MenuIcon)
      self.navigationItem.setLeftBarButtonItem(menuIcon, animated: false)
    }
    self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
  }
  
  private func hideSearchBar() {
    let duration = 0.3
    searchBar.resignFirstResponder()
    setupSearchButton()
    UIView.animateWithDuration(duration, animations: {
      self.navigationItem.titleView?.alpha = 0
      }, completion: { finished in
        self.navigationItem.title = self.UsersViewControllerTitle
        self.navigationItem.titleView = nil
    })
  }
  
  // MARK: - Public
  
  func dismissPopup() {
    popupViewController!.dismiss()
  }
  
  // MARK: - Actions
  
  @IBAction func showSearchBar(sender: AnyObject) {
    navigationItem.titleView = searchBar
    searchBar.alpha = 0
    setupAdvancedSearchButton()
    UIView.animateWithDuration(0.5, animations: {
      self.searchBar.alpha = 1
      self.searchBar.becomeFirstResponder()
      }, completion: { finished in
        
    })
  }
  
  @IBAction func showAdvancedSearchPopup(sender: AnyObject) {
    hideSearchBar()
    let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(UsersFilterViewControllerIdentifier) as! UsersFilterViewController
    viewController.delegate = self
    setupPopupNavigationBar()
    popupViewController = STPopupController(rootViewController: viewController)
    popupViewController!.presentInViewController(self)
  }
  
  // MARK: - UISearchBarDelegate
  
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    hideSearchBar()
  }
  
}

// MARK: - UITableViewDataSource

extension UsersViewController: UITableViewDataSource {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return documentUsers!.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(DocumentUserTableViewCellIdentifier, forIndexPath: indexPath) as! DocumentUsersTableViewCell
    cell.setupDocumentUser(documentUsers![indexPath.row])
    return cell
  }
  
}

// MARK: - UsersFilterViewControllerDelegate

extension UsersViewController: UsersFilterViewControllerDelegate {
  
  func usersFilterViewController(usersFilterViewController: UsersFilterViewController, searchedName name: String, searchedDocNumber: String, profile: String) {
    print(name)
    print(searchedDocNumber)
  }
  
}

// MARK: - UIPopoverPresentationControllerDelegate

extension UsersViewController: UIPopoverPresentationControllerDelegate {
  
  func adaptivePresentationStyleForPresentationController(
    controller: UIPresentationController) -> UIModalPresentationStyle {
      return .None
  }
  
}
