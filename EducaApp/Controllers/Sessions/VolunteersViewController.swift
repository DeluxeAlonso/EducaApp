//
//  VolunteersViewController.swift
//  EducaApp
//
//  Created by Alonso on 9/22/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

let VolunteerCellIdentifier = "VolunteerCell"

class VolunteersViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  let UncheckImageName = "UncheckMark"
  let CheckImageName = "CheckAssistanceIcon"
  
  var volunteers: NSMutableArray = ["Alonso Alvarez", "Daekef Abarca", "Diego Malpartida","Fernando Banda", "Gabriel Tovar", "Gloria Cisneros", "Luis Barcena", "Luis Incio"]
  var checkedVolunteers: NSMutableArray = []
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  
  // MARK: - UITableViewDataSource
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return volunteers.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(VolunteerCellIdentifier, forIndexPath: indexPath) as! VolunteerTableViewCell
    cell.setupVolunteer(volunteers[indexPath.row] as! String)
    if checkedVolunteers.containsObject(volunteers[indexPath.row]) {
      cell.setupVolunteerWithImage(CheckImageName, animated: false)
    } else {
      cell.setupVolunteerWithImage(UncheckImageName, animated: false)
    }
    return cell
  }
  
  // MARK: - UITableViewDelegate
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    let selectedName = volunteers[indexPath.row]
    let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as! VolunteerTableViewCell
    if checkedVolunteers.containsObject(selectedName) {
      checkedVolunteers.removeObject(selectedName)
      selectedCell.setupVolunteerWithImage(UncheckImageName, animated: true)
    } else {
      checkedVolunteers.addObject(selectedName)
      selectedCell.setupVolunteerWithImage(CheckImageName, animated: true)
    }
  }
  
}
