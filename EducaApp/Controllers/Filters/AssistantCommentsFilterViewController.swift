//
//  AssistantCommentsFilterViewController.swift
//  EducaApp
//
//  Created by Alonso on 9/30/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

let DatePickerViewControllerIdentifier = "DateFilterViewController"
let SortingFilterViewControllerIdentifier = "SortingFilterViewController"

let AuthorContentFilterCellIdentidifer = "AuthorContentFilterCell"
let DateFilterCellIdentifier = "DateFilterCell"
let SortingFilterCellIdentifier = "SortingFilterCell"

let AssistantCommentFilterTitle = "Búsqueda"

class AssistantCommentsFilterViewController: UIViewController {
  
  let rightBarButtonItemTitle = "Buscar"
  let advancedSearchSelector: Selector = "advancedSearch:"
  let sortingOptions = ["Más Actual", "Más Antiguo"]
  let sortingViewControllerTitle = "Ordenar por"
  
  let popupHeight: CGFloat = 212
  
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
  
  private func goToDatePickerView() {
    let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(DatePickerViewControllerIdentifier) as! DateFilterViewController
    viewController.height = popupHeight
    self.popupController?.pushViewController(viewController, animated: true)
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
    }
  }
  
}

// MARK: - UITableViewDataSource

extension AssistantCommentsFilterViewController: UITableViewDataSource {

  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return section == 0 ? 3 : 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell: UITableViewCell?
    if indexPath.section == 0 {
      switch indexPath.row {
      case 0:
        cell = tableView.dequeueReusableCellWithIdentifier(AuthorContentFilterCellIdentidifer, forIndexPath: indexPath)
      case 1:
        cell = tableView.dequeueReusableCellWithIdentifier(DateFilterCellIdentifier, forIndexPath: indexPath)
        (cell as! DateFilterTableViewCell).setupLabels(DateFilterType.From.rawValue)
      case 2:
        cell = tableView.dequeueReusableCellWithIdentifier(DateFilterCellIdentifier, forIndexPath: indexPath)
        (cell as! DateFilterTableViewCell).setupLabels(DateFilterType.To.rawValue)
      default:
        break
      }
    } else if indexPath.section == 1 {
      switch indexPath.row {
      case 0:
        cell = tableView.dequeueReusableCellWithIdentifier(SortingFilterCellIdentifier, forIndexPath: indexPath)
      default:
        break
      }
    }
    return cell!
  }
  
}

// MARK: - UITableViewDelegate

extension AssistantCommentsFilterViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    if indexPath.section == 0 {
      switch indexPath.row {
      case 1:
        goToDatePickerView()
      case 2:
        goToDatePickerView()
      default:
        break
      }
    } else if indexPath.section == 1 {
      switch indexPath.row {
      case 0:
        goToSortSelection()
      default:
        break
      }
    }
  }
  
}
