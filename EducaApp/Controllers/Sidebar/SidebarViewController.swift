//
//  SidebarViewController.swift
//  EducaApp
//
//  Created by Alonso on 9/14/15.
//  Copyright (c) 2015 Alonso. All rights reserved.
//

import UIKit

class MenuController: UITableViewController {
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func tableView(tableView: UITableView,
    didSelectRowAtIndexPath indexPath: NSIndexPath) {
      if indexPath.row == 1 {
        let actionSheetController: UIAlertController = UIAlertController(title: "¿Está seguro de que desea participar en este periodo?", message: nil, preferredStyle: .Alert)
        let payPalAction: UIAlertAction = UIAlertAction(title: "Cancelar", style:UIAlertActionStyle.Cancel, handler: nil)
        actionSheetController.addAction(payPalAction)
        let depositAction: UIAlertAction = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default) { action -> Void in
        }
        actionSheetController.addAction(depositAction)
        self.presentViewController(actionSheetController, animated: true, completion: nil)
      }
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
}

