//
//  UsersFilterViewController.swift
//  EducaApp
//
//  Created by Alonso on 10/1/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

enum UsersFilterFields: String {
  case Name = "Nombre:"
  case Document = "DNI:"
  case SortName = "Perfil:"
  case SortResult = "Miembro de AFI"
}

class UsersFilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  let rightBarButtonItemTitle = "Buscar"
  let advancedSearchSelector: Selector = "advancedSearch:"
  let sortingOptions = ["Miembro de AFI", "Voluntario", "Padrino"]
  let sortingViewControllerTitle = "Perfiles"
  
  let popupHeight: CGFloat = 159
  
  var delegate: UIViewController?
  
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
  
  private func goToSortSelection() {
    let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(SortingFilterViewControllerIdentifier) as! SortingFilterViewController
    viewController.height = popupHeight
    viewController.sortingOptions = sortingOptions
    viewController.viewTitle = sortingViewControllerTitle
    self.popupController?.pushViewController(viewController, animated: true)
  }
  
  // MARK: - Actions
  
  @IBAction func advancedSearch(sender: AnyObject) {
    if delegate is AssistantDetailViewController {
      (delegate as! AssistantDetailViewController).dismissPopup()
    } else if delegate is UsersViewController {
      (delegate as! UsersViewController).dismissPopup()
    } else if delegate is PostsViewController {
      (delegate as! PostsViewController).dismissPopup()
    } else if delegate is StudentsViewController {
      (delegate as! StudentsViewController).dismissPopup()
    }
  }
  
  // MARK: - UITableViewDataSource
  
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
        (cell as! AuthorContentTableViewCell).setupNameFieldLabel(UsersFilterFields.Name.rawValue)
      case 1:
        cell = tableView.dequeueReusableCellWithIdentifier(AuthorContentFilterCellIdentidifer, forIndexPath: indexPath)
        (cell as! AuthorContentTableViewCell).setupNameFieldLabel(UsersFilterFields.Document.rawValue)
      case 2:
        cell = tableView.dequeueReusableCellWithIdentifier(SortingFilterCellIdentifier, forIndexPath: indexPath)
        (cell as! SortingFilterTableViewCell).setupFieldNameLabel(UsersFilterFields.SortName.rawValue, fieldType: UsersFilterFields.SortResult.rawValue)
      default:
        break
      }
    }
    return cell!
  }
  
  // MARK: - UITableViewDelegate
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    if indexPath.row == 2 {
      goToSortSelection()
    }
  }

}
