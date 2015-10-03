//
//  SortingFilterViewController.swift
//  EducaApp
//
//  Created by Alonso on 9/30/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

let SortingFilterCellIdentidifer = "SortingNameCell"

class SortingFilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  var sortingOptions: NSArray?
  var height: CGFloat?
  var viewTitle: String?
  
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
  
  // MARK: - UITableViewDataSource
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sortingOptions!.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(SortingFilterCellIdentidifer, forIndexPath: indexPath) as! SortSelectionTableViewCell
    cell.accessoryType = UITableViewCellAccessoryType.None
    if indexPath.row == 0 {
      cell.accessoryType = UITableViewCellAccessoryType.Checkmark
    }
    cell.setupSortLabel(sortingOptions?[indexPath.row] as! String)
    return cell
  }
  
}
