//
//  AssistantCommentsFilterViewController.swift
//  EducaApp
//
//  Created by Alonso on 9/30/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

protocol AssistantCommentsFilterViewControllerDelegate {
  
  func assistantCommentsFilterViewController(assistantCommentsFilterViewController: AssistantCommentsFilterViewController, searchedAuthor: String, minDate: NSDate?, maxDate: NSDate?, sortType: String)
  
}

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
  
  var nameSearchText = String()
  var nameSearchString: String?
  var delegate: AssistantCommentsFilterViewControllerDelegate?
  var sortCell: SortingFilterTableViewCell?
  var minDate: NSDate?
  var maxDate: NSDate?
  
  var minCellDate:  DateFilterTableViewCell?
  var maxCellDate: DateFilterTableViewCell?
  
  var selectedSort = "Más Actual"
  
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
    //nameSearchText = nameSearchString ?? ""
    self.title = AssistantCommentFilterTitle
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: rightBarButtonItemTitle, style: UIBarButtonItemStyle.Plain, target: self, action: advancedSearchSelector)
  }
  
  private func goToDatePickerView(indexPath: NSIndexPath) {
    let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(DatePickerViewControllerIdentifier) as! DateFilterViewController
    viewController.height = popupHeight
    viewController.indexPath = indexPath
    viewController.delegate = self
    self.popupController?.pushViewController(viewController, animated: true)
  }
  
  private func goToSortSelection() {
    let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(SortingFilterViewControllerIdentifier) as! SortingFilterViewController
    viewController.height = popupHeight
    viewController.sortingOptions = sortingOptions
    viewController.viewTitle = sortingViewControllerTitle
    viewController.delegate = self
    self.popupController?.pushViewController(viewController, animated: true)
  }
  
  // MARK: - Actions
  
  @IBAction func advancedSearch(sender: AnyObject) {
    delegate?.assistantCommentsFilterViewController(self, searchedAuthor: nameSearchText, minDate: minDate, maxDate: maxDate, sortType: selectedSort)
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
        (cell as! AuthorContentTableViewCell).delegate = self
        (cell as! AuthorContentTableViewCell).setupNameFieldLabel("Autor o Contenido", searchedName: nameSearchString ?? "", indexPath: indexPath)
      case 1:
        cell = tableView.dequeueReusableCellWithIdentifier(DateFilterCellIdentifier, forIndexPath: indexPath)
        (cell as! DateFilterTableViewCell).setupLabels(DateFilterType.From.rawValue)
        minCellDate = cell as? DateFilterTableViewCell
      case 2:
        cell = tableView.dequeueReusableCellWithIdentifier(DateFilterCellIdentifier, forIndexPath: indexPath)
        (cell as! DateFilterTableViewCell).setupLabels(DateFilterType.To.rawValue)
        maxCellDate = cell as? DateFilterTableViewCell
      default:
        break
      }
    } else if indexPath.section == 1 {
      switch indexPath.row {
      case 0:
        cell = tableView.dequeueReusableCellWithIdentifier(SortingFilterCellIdentifier, forIndexPath: indexPath)
        sortCell = cell as? SortingFilterTableViewCell
        (sortCell)!.setupFieldNameLabel("Ordenar por:", fieldType: selectedSort)
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
        goToDatePickerView(indexPath)
      case 2:
        goToDatePickerView(indexPath)
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

// MARK: - AuthorContentTableViewCellDelegate

extension AssistantCommentsFilterViewController: AuthorContentTableViewCellDelegate {
  
  func authorContentTableViewCell(authorContentTableViewCell: AuthorContentTableViewCell, textFieldDidChange textField: UITextField, text: String, indexPath: NSIndexPath) {
    switch indexPath.row {
    case 0:
      nameSearchText = text
    default:
      break
    }
  }
  
}

// MARK: - DateFilterViewControllerDelegate

extension AssistantCommentsFilterViewController: DateFilterViewControllerDelegate {
  
  func dateFilterViewController(dateFilterViewController: DateFilterViewController, selectedDate: NSDate, indexPath: NSIndexPath) {
    if indexPath.row == 1 {
      minDate = selectedDate
      minCellDate?.setupDateText(selectedDate)
    } else {
      maxDate = selectedDate
      maxCellDate?.setupDateText(selectedDate)
    }
  }
  
}

// MARK: - SortingFilterViewControllerDelegate

extension AssistantCommentsFilterViewController: SortingFilterViewControllerDelegate {
  
  func sortingFilterViewController(sortingFilterViewController: SortingFilterViewController, selectedOptionName: String) {
    print(selectedOptionName)
    sortCell?.setupFieldNameLabel("Ordernar por:", fieldType: selectedOptionName)
    selectedSort = selectedOptionName
  }
  
}
