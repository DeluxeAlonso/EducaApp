//
//  VolunteersViewController.swift
//  EducaApp
//
//  Created by Alonso on 9/22/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

let kVolunteerCellIdentifier = "VolunteerCell"

class VolunteersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  var volunteers: NSMutableArray = ["Alonso Alvarez", "Fernando Banda", "Luis Barcena", "Daekef Abarca", "Gloria Cisneros", "Diego Malpartida", "Luis Incio", "Gabriel Tovar"]
  var checkedVolunteers: NSMutableArray = []
  
  let uncheckImageName = "UncheckMark"
  let checkImageName = "CheckAssistanceIcon"
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupPanGesture()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Private
  
  private func setupPanGesture() {
    if self.revealViewController() != nil {
      self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
  }
  
  // MARK: - UITableViewDataSource
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return volunteers.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(kVolunteerCellIdentifier, forIndexPath: indexPath) as! VolunteerTableViewCell
    cell.setupVolunteer(volunteers[indexPath.row] as! String)
    if checkedVolunteers.containsObject(volunteers[indexPath.row]) {
      cell.setupVolunteerWithImage(checkImageName, animated: false)
    } else {
      cell.setupVolunteerWithImage(uncheckImageName, animated: false)
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
      selectedCell.setupVolunteerWithImage(uncheckImageName, animated: true)
    } else {
      checkedVolunteers.addObject(selectedName)
      selectedCell.setupVolunteerWithImage(checkImageName, animated: true)
    }
  }
  
}