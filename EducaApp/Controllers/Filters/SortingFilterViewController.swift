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
  
  var sortingOptions = ["Más Actual", "Más Antiguo"]
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.contentSizeInPopup = CGSizeMake(300, FilterCellHeight)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - UITableViewDataSource
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sortingOptions.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(SortingFilterCellIdentidifer, forIndexPath: indexPath) as! SortSelectionTableViewCell
    cell.setupSortLabel(sortingOptions[indexPath.row])
    return cell
  }
  
  // MARK: - UITableViewDelegate
  
}
