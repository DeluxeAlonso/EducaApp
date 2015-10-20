//
//  BaseFilterViewController.swift
//  EducaApp
//
//  Created by Alonso on 10/1/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class BaseFilterViewController: BaseViewController, UISearchBarDelegate {
  
  @IBOutlet weak var searchBarButtonItem: UIBarButtonItem!
  
  var searchBar = UISearchBar()
  
  var simpleSearchBarButtonItem = UIBarButtonItem()
  var advanceSearchBarButtonItem = UIBarButtonItem()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupSearchBar()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    searchBar.resignFirstResponder()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Public
  
  func setupSearchBar() {
    searchBar.delegate = self
    self.searchBar.showsCancelButton = true
    searchBar.searchBarStyle = UISearchBarStyle.Default
  }
  
  override func setupBarButtonItem() {
    super.setupBarButtonItem()
    simpleSearchBarButtonItem.image = UIImage(named: "SearchIcon")
    simpleSearchBarButtonItem.target = self
    simpleSearchBarButtonItem.action = SearchSelector
    advanceSearchBarButtonItem.image = UIImage(named: "AdvancedSearchIcon")
    advanceSearchBarButtonItem.target = self
    advanceSearchBarButtonItem.action = AdvancedSearchSelector
  }
  
  func setupSearchButton() {
    navigationItem.setRightBarButtonItem(simpleSearchBarButtonItem, animated: true)
  }
  
  func setupAdvancedSearchButton() {
    navigationItem.setRightBarButtonItem(advanceSearchBarButtonItem, animated: true)
  }
  
  // MARK: - SWRevealViewControllerDelegate
  
  override func revealController(revealController: SWRevealViewController!, willMoveToPosition position: FrontViewPosition) {
    super.revealController(revealController, willMoveToPosition: position)
    if position == FrontViewPosition.Right {
      searchBar.delegate?.searchBarCancelButtonClicked!(searchBar)
    }
  }
  
}
