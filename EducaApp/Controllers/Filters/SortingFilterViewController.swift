//
//  SortingFilterViewController.swift
//  EducaApp
//
//  Created by Alonso on 9/30/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

protocol SortingFilterViewControllerDelegate {
  
  func sortingFilterViewController(sortingFilterViewController: SortingFilterViewController, selectedOptionName: String)
  
}

let SortingFilterCellIdentidifer = "SortingNameCell"

class SortingFilterViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var sortingOptions: NSArray?
  var height: CGFloat?
  var viewTitle: String?
  var selectedProfile: String?
  var delegate: SortingFilterViewControllerDelegate?
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    self.contentSizeInPopup = CGSizeMake(300, height!)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Private
  
  private func setupNavigationBar() {
    self.title = viewTitle
  }
  
}

// MARK: - UITableViewDataSource

extension SortingFilterViewController: UITableViewDataSource {

  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return delegate is UsersViewController ? sortingOptions!.count + 1 : sortingOptions!.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(SortingFilterCellIdentidifer, forIndexPath: indexPath) as! SortSelectionTableViewCell
    cell.accessoryType = UITableViewCellAccessoryType.None
    if indexPath.row == 0 && delegate is UsersViewController {
     cell.accessoryType = selectedProfile == "Todos" ? UITableViewCellAccessoryType.Checkmark :  UITableViewCellAccessoryType.None
    } else {
      let index = delegate is UsersViewController ? indexPath.row - 1 : indexPath.row
      cell.accessoryType = sortingOptions![index] as? String == selectedProfile ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None
    }
    let index = delegate is UsersViewController ? indexPath.row - 1 : indexPath.row
    (indexPath.row == 0 && delegate is UsersViewController) ? cell.setupSortLabel("Todos") : cell.setupSortLabel(sortingOptions?[index] as! String)
    return cell
  }
  
}

// MARK: - UITableViewDelegate

extension SortingFilterViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let profile: String
    if delegate is UsersViewController {
      profile = indexPath.row == 0 ? "Todos" : sortingOptions![indexPath.row - 1] as! String
    } else {
      profile = sortingOptions![indexPath.row] as! String
    }
    delegate?.sortingFilterViewController(self, selectedOptionName: profile)
    self.popupController?.popViewControllerAnimated(true)
  }
  
}
