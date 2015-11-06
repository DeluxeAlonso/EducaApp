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
    let alertController:UIAlertController = UIAlertController(title: PostulationActionSheetTitle, message: nil, preferredStyle: .ActionSheet)
    let ok:UIAlertAction = UIAlertAction(title: "Postular", style: .Default) { action -> Void in
      self.reapply(NSNull)
    }
    alertController.addAction(ok)
    let cancel:UIAlertAction = UIAlertAction(title: "Cancelar", style: .Destructive, handler: nil)
    alertController.addAction(cancel)
    
    presentViewController(alertController, animated: true, completion: nil)
  }
  
  @IBAction func reapply(sender: AnyObject) {
    print("comentario")
    reaply(Int((currentUser?.periodId)!))
  }
  
  
  func reaply(idperiod:Int){
    UserService.reapply(idperiod , completion: {(responseObject: AnyObject?, error: NSError?) in
      print(responseObject)
      guard let json = responseObject as? NSDictionary else {
        return
      }
      if (json[Constants.Api.ErrorKey] == nil) {
        self.showAlertWithTitle("Enhorabuena", message: "Has logrado postular con éxito", buttonTitle: "OK")
      }
    })
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
