//
//  UsersViewController.swift
//  EducaApp
//
//  Created by Alonso on 10/1/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class UsersViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
  
  @IBOutlet weak var searchBarButtonItem: UIBarButtonItem!
  
  var searchBar = UISearchBar()
  
  var simpleSearchBarButtonItem = UIBarButtonItem()
  var advanceSearchBarButtonItem = UIBarButtonItem()
  
  var popupViewController: STPopupController?
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupElements()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  // MARK: - Private
  
  private func setupElements() {
    setupSearchBar()
  }
  
  override func setupBarButtonItem() {
    super.setupBarButtonItem()
    simpleSearchBarButtonItem.image = UIImage(named: "SearchIcon")
    simpleSearchBarButtonItem.target = self
    simpleSearchBarButtonItem.action = SearchSelector
    advanceSearchBarButtonItem.image = UIImage(named: "AdvancedSearchIcon")
    advanceSearchBarButtonItem.target = self
    advanceSearchBarButtonItem.action = AdvancedSearchSelector
  }
  
  private func setupSearchBar() {
    searchBar.delegate = self
    self.searchBar.showsCancelButton = true
    searchBar.searchBarStyle = UISearchBarStyle.Default
  }
  
  private func setupPopupNavigationBar() {
    STPopupNavigationBar.appearance().barTintColor = UIColor.defaultTextColor()
    STPopupNavigationBar.appearance().tintColor = UIColor.whiteColor()
    STPopupNavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 17) ?? UIFont.systemFontOfSize(17)]
  }
  
  private func hideSearchBar() {
    let duration = 0.3
    searchBar.resignFirstResponder()
    setupSearchButton()
    UIView.animateWithDuration(duration, animations: {
      self.navigationItem.titleView?.alpha = 0
      }, completion: { finished in
        self.navigationItem.title = "Usuarios"
        self.navigationItem.titleView = nil
    })
  }
  
  private func setupSearchButton() {
    navigationItem.setRightBarButtonItem(simpleSearchBarButtonItem, animated: true)
  }
  
  private func setupAdvancedSearchButton() {
    navigationItem.setRightBarButtonItem(advanceSearchBarButtonItem, animated: true)
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
    let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(AssistantCommentsFilterViewIdentifier) as! AssistantCommentsFilterViewController
    viewController.delegate = self
    setupPopupNavigationBar()
    popupViewController = STPopupController(rootViewController: viewController)
    popupViewController!.presentInViewController(self)
  }
  
  // MARK: - UITableViewDataSource
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath)
    return cell
  }
  
  // MARK: - UIPopoverPresentationControllerDelegate
  
  func adaptivePresentationStyleForPresentationController(
    controller: UIPresentationController) -> UIModalPresentationStyle {
      return .None
  }
  
  //MARK: - UISearchBarDelegate
  
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    hideSearchBar()
  }
  
}