//
//  PeopleViewController.swift
//  EducaApp
//
//  Created by Alonso on 10/19/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

enum SelectedSegmentIndex: Int {
  case Users
  case Students
}

class PeopleViewController: BaseFilterViewController {
  
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var mapButton: UIBarButtonItem!
  @IBOutlet weak var customLoader: CustomActivityIndicatorView!
  
  let userAdvancedSearchSelector: Selector = "showAdvancedUserSearchPopup:"
  let studentAdvancedSearchSelector: Selector = "showAdvancedStudentSearchPopup:"
  let refreshDataSelector: Selector = "refreshData"
  let refreshControl = CustomRefreshControlView()
  
  var isRefreshing = false
  var popupViewController: STPopupController?
  var selectedSegmentIndex: Int?
  var users = [User]()
  var students = [Student]()
  
  var mapBarButtonItem = UIBarButtonItem()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupElements()
    setupUsers()
  }
  
  // MARK: - Private
  
  private func setupElements() {
    if currentUser?.hasPermissionWithId(28) == false {
      mapButton.image = nil
      mapButton.enabled = false
    }
    mapBarButtonItem = mapButton
    selectedSegmentIndex = SelectedSegmentIndex.Users.hashValue
    advanceSearchBarButtonItem.action = userAdvancedSearchSelector
  }
  
  private func setupUsers() {
    users = User.getAllUsers(self.dataLayer.managedObjectContext!)
    students = Student.getAllStudents(self.dataLayer.managedObjectContext!)
    guard users.count == 0 else {
      getUsers()
      getStudents()
      return
    }
    self.tableView.hidden = true
    customLoader.startActivity()
    getUsers()
  }
  
  private func getUsers() {
    UserService.fetchUsers({(responseObject: AnyObject?, error: NSError?) in
      self.refreshControl.endRefreshing()
      self.isRefreshing = false
      guard let json = responseObject as? Array<NSDictionary> else {
        return
      }
      guard json.count > 0 else {
        self.customLoader.stopActivity()
        self.tableView.hidden = false
        return
      }
      if (json[0][Constants.Api.ErrorKey] == nil) {
        let syncedUsers = User.syncWithJsonArray(json , ctx: self.dataLayer.managedObjectContext!)
        self.users = syncedUsers
        self.dataLayer.saveContext()
        self.tableView.reloadData()
      }
    })
  }
  
  private func getStudents() {
    StudentService.fetchStudents({(responseObject: AnyObject?, error: NSError?) in
      self.refreshControl.endRefreshing()
      self.isRefreshing = false
      guard let json = responseObject as? Array<NSDictionary> else {
        return
      }
      guard json.count > 0 else {
        return
      }
      
      if (json[0][Constants.Api.ErrorKey] == nil) {
        let syncedStudents = Student.syncWithJsonArray(json , ctx: self.dataLayer.managedObjectContext!)
        self.students = syncedStudents
        self.dataLayer.saveContext()
        self.tableView.reloadData()
      } else {
        //Show Error Message
      }
    })
  }
  
  private func setupPopupNavigationBar() {
    STPopupNavigationBar.appearance().barTintColor = UIColor.defaultTextColor()
    STPopupNavigationBar.appearance().tintColor = UIColor.whiteColor()
    STPopupNavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.lightFontWithFontSize(17)]
  }
  
  private func hideSearchBar() {
    let duration = 0.3
    searchBar.resignFirstResponder()
    setupSearchButton()
    UIView.animateWithDuration(duration, animations: {
      self.navigationItem.titleView?.alpha = 0
      }, completion: { finished in
        self.navigationItem.setRightBarButtonItems([self.simpleSearchBarButtonItem, self.mapBarButtonItem], animated: true)
        self.navigationItem.title = "Personas"
        self.navigationItem.titleView = nil
    })
  }
  
  // MARK: - Actions
  
  @IBAction func selectedControlIndexChanged(sender: AnyObject) {
    selectedSegmentIndex = segmentedControl.selectedSegmentIndex
    advanceSearchBarButtonItem.action = selectedSegmentIndex == SelectedSegmentIndex.Users.rawValue ? userAdvancedSearchSelector : studentAdvancedSearchSelector
    tableView.reloadData()
  }
  
  @IBAction func showSearchBar(sender: AnyObject) {
    navigationItem.titleView = searchBar
    navigationItem.setRightBarButtonItems([advanceSearchBarButtonItem], animated: true)
    searchBar.alpha = 0
    setupAdvancedSearchButton()
    UIView.animateWithDuration(0.5, animations: {
      self.searchBar.alpha = 1
      self.searchBar.becomeFirstResponder()
      }, completion: { finished in
        
    })
  }
  
  @IBAction func showAdvancedUserSearchPopup(sender: AnyObject) {
    hideSearchBar()
    let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(UsersFilterViewControllerIdentifier) as! UsersFilterViewController
    viewController.delegate = self
    setupPopupNavigationBar()
    popupViewController = STPopupController(rootViewController: viewController)
    popupViewController!.presentInViewController(self)
  }
  
  @IBAction func showAdvancedStudentSearchPopup(sender: AnyObject) {
    hideSearchBar()
    let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(StudentsFilterViewControllerIdentifier) as! StudentsFilterViewController
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

extension PeopleViewController: UITableViewDataSource {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return selectedSegmentIndex! == SelectedSegmentIndex.Users.rawValue ? users.count : (students.count)
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell: UITableViewCell?
    switch selectedSegmentIndex {
    case SelectedSegmentIndex.Users.rawValue?:
      cell = tableView.dequeueReusableCellWithIdentifier(UserTableViewCellIdentifier, forIndexPath: indexPath)
      (cell as! UserTableViewCell).setupUser(users[indexPath.row] )
    default:
      cell = tableView.dequeueReusableCellWithIdentifier(StudentCellIdentifier, forIndexPath: indexPath) as! StudentTableViewCell
      (cell as! StudentTableViewCell).setupStudent(students[indexPath.row])
    }
    return cell!
  }
  
}

// MARK: - UIPopoverPresentationControllerDelegate

extension PeopleViewController: UIPopoverPresentationControllerDelegate {
  
  func adaptivePresentationStyleForPresentationController(
    controller: UIPresentationController) -> UIModalPresentationStyle {
      return .None
  }
  
}
