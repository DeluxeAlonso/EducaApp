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
  
  let userAdvancedSearchSelector: Selector = "showAdvancedUserSearchPopup:"
  let studentAdvancedSearchSelector: Selector = "showAdvancedStudentSearchPopup:"
  
  var popupViewController: STPopupController?
  var selectedSegmentIndex: Int?
  var people: NSMutableArray = []
  
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
    selectedSegmentIndex = SelectedSegmentIndex.Users.hashValue
    getUsers()
    tableView.reloadData()
  }
  
  private func getUsers() {
    let users: NSMutableArray = []
    for i in 0..<Int((Constants.MockData.UsersName.count)) {
      let user = Student()
      user.name = (Constants.MockData.UsersName[i] as? String)!
      user.document = (Constants.MockData.UsersDoc[i] as? String)!
      users.addObject(user)
    }
    people = users
  }
  
  private func getStudents() {
    let students: NSMutableArray = []
    for i in 0..<Int((Constants.MockData.StudentsName.count)) {
      let student = Student()
      student.name = (Constants.MockData.StudentsName[i] as? String)!
      student.age = Constants.MockData.StudentsAge[i] as? String
      student.gender = Constants.MockData.StudentsGender[i] as? Int
      students.addObject(student)
    }
    people = students
  }
  
  private func refreshTableView() {
    selectedSegmentIndex == SelectedSegmentIndex.Users.rawValue ? getUsers() : getStudents()
    tableView.reloadData()
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
        self.navigationItem.title = "Personas"
        self.navigationItem.titleView = nil
    })
  }
  
  // MARK: - Actions
  
  @IBAction func selectedControlIndexChanged(sender: AnyObject) {
    selectedSegmentIndex = segmentedControl.selectedSegmentIndex
    advanceSearchBarButtonItem.action = selectedSegmentIndex == SelectedSegmentIndex.Users.rawValue ? userAdvancedSearchSelector : studentAdvancedSearchSelector
    refreshTableView()
  }
  
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
    return people.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell: UITableViewCell?
    switch selectedSegmentIndex {
    case SelectedSegmentIndex.Users.rawValue?:
      cell = tableView.dequeueReusableCellWithIdentifier(UserTableViewCellIdentifier, forIndexPath: indexPath)
      (cell as! UserTableViewCell).setupUser(people[indexPath.row] as! Student)
    default:
      cell = tableView.dequeueReusableCellWithIdentifier(StudentCellIdentifier, forIndexPath: indexPath) as! StudentTableViewCell
      (cell as! StudentTableViewCell).setupStudent(people[indexPath.row] as! Student)
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
