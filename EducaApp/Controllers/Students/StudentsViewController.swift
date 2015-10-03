//
//  StudentsViewController.swift
//  EducaApp
//
//  Created by Alonso on 10/1/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

let StudentCellIdentifier = "StudentCell"
let StudentsFilterViewControllerIdentifier = "StudentsFilterViewController"

class StudentsViewController: BaseFilterViewController, UITableViewDelegate, UITableViewDataSource {
  
  var popupViewController: STPopupController?
  
  var students: NSMutableArray = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getStudents()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Private
  
  private func getStudents() {
    for i in 0..<Int((Constants.MockData.StudentsName.count)) {
      let student = Student()
      student.name = (Constants.MockData.StudentsName[i] as? String)!
      student.age = Constants.MockData.StudentsAge[i] as? String
      student.gender = Constants.MockData.StudentsGender[i] as? Int
      students.addObject(student)
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
        self.navigationItem.title = "Niños"
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
    let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(StudentsFilterViewControllerIdentifier) as! StudentsFilterViewController
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
    return students.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(StudentCellIdentifier, forIndexPath: indexPath) as! StudentTableViewCell
    cell.setupStudent(students[indexPath.row] as! Student)
    return cell
  }
  
  // MARK: - UIPopoverPresentationControllerDelegate
  
  func adaptivePresentationStyleForPresentationController(
    controller: UIPresentationController) -> UIModalPresentationStyle {
      return .None
  }
  
  // MARK: - UISearchBarDelegate
  
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    hideSearchBar()
  }

}
