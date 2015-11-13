//
//  UsersFilterViewController.swift
//  EducaApp
//
//  Created by Alonso on 10/1/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

protocol UsersFilterViewControllerDelegate {
  
  func usersFilterViewController(usersFilterViewController: UsersFilterViewController, searchedName name: String, searchedDocNumber: String, profile: String)
  
}

enum UsersFilterFields: String {
  case Name = "Nombre:"
  case Document = "DNI:"
  case SortName = "Perfil:"
  case SortResult = "Todos"
}

class UsersFilterViewController: UIViewController {

  let rightBarButtonItemTitle = "Buscar"
  let advancedSearchSelector: Selector = "advancedSearch:"
  var sortingOptions = [String]()
  let sortingViewControllerTitle = "Perfiles"
  
  let popupHeight: CGFloat = 159
  
  var delegate: UsersFilterViewControllerDelegate?
  
  var nameSearchText = String()
  var nameSearchString: String?
  var docNumberSearchText = String()
  var profileSearch = String()
  
  var selectedProfile = "Todos"

  var profileCell: SortingFilterTableViewCell?
  
  lazy var dataLayer = DataLayer()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    if nameSearchString != nil {
      nameSearchText = nameSearchString!
    }
    let profiles = Profile.getAllProfiles(dataLayer.managedObjectContext!)
    sortingOptions = profiles.map { (profile) in return (profile).name! }
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
  
  private func goToSortSelection() {
    let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(SortingFilterViewControllerIdentifier) as! SortingFilterViewController
    viewController.height = popupHeight
    viewController.selectedProfile = selectedProfile
    viewController.delegate = self
    viewController.sortingOptions = sortingOptions
    viewController.viewTitle = sortingViewControllerTitle
    self.popupController?.pushViewController(viewController, animated: true)
  }
  
  // MARK: - Actions
  
  @IBAction func advancedSearch(sender: AnyObject) {
    delegate?.usersFilterViewController(self, searchedName: nameSearchText, searchedDocNumber: docNumberSearchText, profile: selectedProfile)
  }
  
}

// MARK: - UITableViewDataSource

extension UsersFilterViewController: UITableViewDataSource {
  
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
        (cell as! AuthorContentTableViewCell).delegate = self
        (cell as! AuthorContentTableViewCell).setupNameFieldLabel(UsersFilterFields.Name.rawValue, searchedName: nameSearchString ?? "", indexPath: indexPath)
      case 1:
        cell = tableView.dequeueReusableCellWithIdentifier(AuthorContentFilterCellIdentidifer, forIndexPath: indexPath)
        (cell as! AuthorContentTableViewCell).delegate = self
        (cell as! AuthorContentTableViewCell).setupNameFieldLabel(UsersFilterFields.Document.rawValue, searchedName: "", indexPath: indexPath)
      case 2:
        cell = tableView.dequeueReusableCellWithIdentifier(SortingFilterCellIdentifier, forIndexPath: indexPath)
        profileCell = cell as? SortingFilterTableViewCell
        (cell as! SortingFilterTableViewCell).setupFieldNameLabel(UsersFilterFields.SortName.rawValue, fieldType: selectedProfile)
      default:
        break
      }
    }
    return cell!
  }
  
}

// MARK: - UITableViewDelegate

extension UsersFilterViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    if indexPath.row == 2 {
      goToSortSelection()
    }
  }
  
}

// MARK: - AuthorContentTableViewCellDelegate

extension UsersFilterViewController: AuthorContentTableViewCellDelegate {
  
  func authorContentTableViewCell(authorContentTableViewCell: AuthorContentTableViewCell, textFieldDidChange textField: UITextField, text: String, indexPath: NSIndexPath) {
    switch indexPath.row {
    case 0:
      nameSearchText = text
    case 1:
      docNumberSearchText = text
    default:
      break
    }
  }
  
}

// MARK: - SortingFilterViewControllerDelegate

extension UsersFilterViewController: SortingFilterViewControllerDelegate {
  
  func sortingFilterViewController(sortingFilterViewController: SortingFilterViewController, selectedOptionName: String) {
    selectedProfile = selectedOptionName
    profileCell!.setupFieldNameLabel(UsersFilterFields.SortName.rawValue, fieldType: selectedProfile)
    print(selectedOptionName)
  }
  
}
