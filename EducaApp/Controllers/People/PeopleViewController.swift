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
    mapBarButtonItem = mapButton
    selectedSegmentIndex = SelectedSegmentIndex.Users.hashValue
    advanceSearchBarButtonItem.action = userAdvancedSearchSelector
    setupTableView()
  }
  
  private func setupTableView() {
    tableView.addSubview(refreshControl)
    refreshControl.addTarget(self, action: refreshDataSelector, forControlEvents: UIControlEvents.ValueChanged)
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
      if (json[0][Constants.Api.ErrorKey] == nil) {
        let syncedUsers = User.syncWithJsonArray(json , ctx: self.dataLayer.managedObjectContext!)
        self.users = syncedUsers
        self.dataLayer.saveContext()
        self.reloadData()
      } else {
        //Show Error Message
      }
    })
  }
  
  private func setupStudents() {
    students = Student.getAllStudents(self.dataLayer.managedObjectContext!)
    guard students.count == 0 else {
      getStudents()
      return
    }
    self.tableView.hidden = true
    customLoader.startActivity()
    getStudents()
  }
  
  private func getStudents() {
    StudentService.fetchStudents({(responseObject: AnyObject?, error: NSError?) in
      self.refreshControl.endRefreshing()
      self.isRefreshing = false
      guard let json = responseObject as? Array<NSDictionary> else {
        return
      }
      if (json[0][Constants.Api.ErrorKey] == nil) {
        let syncedStudents = Student.syncWithJsonArray(json , ctx: self.dataLayer.managedObjectContext!)
        self.students = syncedStudents
        self.dataLayer.saveContext()
        self.reloadData()
      } else {
        //Show Error Message
      }
    })
  }
  
  private func refreshTableView() {
    if isRefreshing {
      refreshControl.endRefreshing()
      isRefreshing = false
      Util.delay(0.5) {
        self.tableView.reloadData()
      }
    } else {
        tableView.reloadData()
    }
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
  
  // MARK: - Public
  
  func refreshData() {
    isRefreshing = true
    Util.delay(2.0) {
      self.selectedSegmentIndex == SelectedSegmentIndex.Users.rawValue ? self.getUsers() : self.getStudents()
    }
  }
  
  func reloadData() {
    guard !self.isRefreshing else {
      self.tableView.reloadData()
      return
    }
    Util.delay(0.5) {
      self.customLoader.stopActivity()
      self.tableView.hidden = false
      self.tableView.reloadData()
    }
  }
  
  // MARK: - Actions
  
  @IBAction func selectedControlIndexChanged(sender: AnyObject) {
    selectedSegmentIndex = segmentedControl.selectedSegmentIndex
    advanceSearchBarButtonItem.action = selectedSegmentIndex == SelectedSegmentIndex.Users.rawValue ? userAdvancedSearchSelector : studentAdvancedSearchSelector
    refreshTableView()
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

// MARK: - UIScrollViewDelegate

extension ArticlesViewController: UIScrollViewDelegate {
  
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    guard refreshControl.refreshing && !refreshControl.isAnimating else {
      return
    }
    refreshControl.animateRefreshFirstStep()
  }
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    let offset = scrollView.contentOffset.y * -1
    var alpha = CGFloat(0.0)
    if offset > 30 {
      alpha = ((offset) / 100)
      if alpha > 100 {
        alpha = 1.0
      }
    }
    refreshControl.customView.alpha = alpha
  }
  
}

// MARK: - UIPopoverPresentationControllerDelegate

extension PeopleViewController: UIPopoverPresentationControllerDelegate {
  
  func adaptivePresentationStyleForPresentationController(
    controller: UIPresentationController) -> UIModalPresentationStyle {
      return .None
  }
  
}
