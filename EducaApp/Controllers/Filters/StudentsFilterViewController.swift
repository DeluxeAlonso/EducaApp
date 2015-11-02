//
//  StudentsFilterViewController.swift
//  EducaApp
//
//  Created by Alonso on 10/1/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

let GenderFilterCellIdentifier = "GenderFilterCell"
let AgeFilterCellIdentifier = "AgeFilterCell"

protocol StudentsFilterViewControllerDelegate {
  
  func studentsFilterViewController(studentsFilterViewController: StudentsFilterViewController, searchedName name: String, minAge: Int, maxAge: Int, gender: Int)
  
}

class StudentsFilterViewController: UIViewController {

  let rightBarButtonItemTitle = "Buscar"
  let advancedSearchSelector: Selector = "advancedSearch:"
  let popupHeight: CGFloat = 159
  
  var delegate: StudentsFilterViewControllerDelegate?
  var nameSearchText = String()
  var minAgeSearch =  5
  var maxAgeSearch = 14
  var genderSearch = -1
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    self.contentSizeInPopup = CGSizeMake(300, popupHeight)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Private
  
  private func setupNavigationBar() {
    self.title = AssistantCommentFilterTitle
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: rightBarButtonItemTitle, style: UIBarButtonItemStyle.Plain, target: self, action: advancedSearchSelector)
  }
  
  // MARK: - Actions
  
  @IBAction func advancedSearch(sender: AnyObject) {
    delegate?.studentsFilterViewController(self, searchedName: nameSearchText, minAge: minAgeSearch, maxAge: maxAgeSearch, gender: genderSearch)
  }
  
}

// MARK: - UITableViewDataSource

extension StudentsFilterViewController: UITableViewDataSource {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell: UITableViewCell?
    if indexPath.section == 0 {
      switch indexPath.row {
      case 0:
        cell = tableView.dequeueReusableCellWithIdentifier(AuthorContentFilterCellIdentidifer, forIndexPath: indexPath)
        (cell as! AuthorContentTableViewCell)
        (cell as! AuthorContentTableViewCell).setupNameFieldLabel(UsersFilterFields.Name.rawValue, indexPath: indexPath)
      case 1:
        cell = tableView.dequeueReusableCellWithIdentifier(AgeFilterCellIdentifier, forIndexPath: indexPath)
      case 2:
        cell = tableView.dequeueReusableCellWithIdentifier(GenderFilterCellIdentifier, forIndexPath: indexPath)
      default:
        break
      }
    }
    return cell!
  }
  
}

// MARK: - UITableViewDelegate

extension StudentsFilterViewController: UITableViewDelegate {

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }

}

// MARK: - AuthorContentTableViewCellDelegate

extension StudentsFilterViewController: AuthorContentTableViewCellDelegate {
  
  func authorContentTableViewCell(authorContentTableViewCell: AuthorContentTableViewCell, textFieldDidChange textField: UITextField, text: String, indexPath: NSIndexPath) {
    switch indexPath.row {
    case 0:
      nameSearchText = text
    default:
      break
    }
  }
  
}
