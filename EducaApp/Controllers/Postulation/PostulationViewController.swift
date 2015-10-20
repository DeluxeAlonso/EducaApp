//
//  PostulationViewController.swift
//  EducaApp
//
//  Created by Alonso on 10/1/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit
import CoreData

let PostulationCellIdentifier = "PostulationCell"
let PostulationCellTexts = ["¡Postular!"]
let PostulationActionSheetTitle = "¿Está seguro de que desea participar de este periodo?"

class PostulationViewController: BaseViewController {
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: - Private
  
  private func showPostulationSheet() {
    let alertController = UIAlertController(title: PostulationActionSheetTitle, message: nil, preferredStyle: .ActionSheet)
    let ok = UIAlertAction(title: "Aceptar", style: .Default, handler: { (action) -> Void in
    })
    let cancel = UIAlertAction(title: "Cancelar", style: .Destructive, handler: nil)
    
    alertController.addAction(ok)
    alertController.addAction(cancel)
    
    presentViewController(alertController, animated: true, completion: nil)
  }

}

// MARK: - UITableViewDataSource

extension PostulationViewController: UITableViewDataSource {

  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1;
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return PostulationCellTexts.count;
  }
  
  func tableView(tableView: UITableView,
    cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier(PostulationCellIdentifier, forIndexPath: indexPath)
        as! PostulationTableViewCell
      cell.nameLabel.text = PostulationCellTexts[indexPath.row]
      return cell
  }
  
}

// MARK: - UITableViewDelegate

extension PostulationViewController: UITableViewDelegate {

  func tableView(tableView: UITableView,
    didSelectRowAtIndexPath indexPath: NSIndexPath) {
      showPostulationSheet()
      tableView.deselectRowAtIndexPath(indexPath, animated: false)
  }
  
}
