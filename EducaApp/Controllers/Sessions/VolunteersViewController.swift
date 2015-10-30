//
//  VolunteersViewController.swift
//  EducaApp
//
//  Created by Alonso on 9/22/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

let VolunteerCellIdentifier = "VolunteerCell"
let RateVolunteerViewControllerIdentifier = "RateVolunteerViewController"

class VolunteersViewController: BaseViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  let UncheckImageName = "UncheckMark"
  let CheckImageName = "CheckAssistanceIcon"
  let RateButtonTitle = "Calificar"

  var session: Session?
  var volunteers = [User]()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: - Private
  
  private func setupPopupNavigationBar() {
    STPopupNavigationBar.appearance().barTintColor = UIColor.defaultTextColor()
    STPopupNavigationBar.appearance().tintColor = UIColor.whiteColor()
    STPopupNavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.lightFontWithFontSize(17)]
  }
  
  private func checkVolunteer(volunteer:User, cell: VolunteerTableViewCell, attended: Bool) {
    volunteer.markAttendanceToSession(session!, attended: attended, ctx: self.dataLayer.managedObjectContext!)
    attended ? cell.setupVolunteerWithImage(CheckImageName, animated: false) : cell.setupVolunteerWithImage(UncheckImageName, animated: false)
    self.dataLayer.saveContext()
  }
  
}

// MARK: - UITableViewDataSource

extension VolunteersViewController: UITableViewDataSource {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return volunteers.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(VolunteerCellIdentifier, forIndexPath: indexPath) as! VolunteerTableViewCell
    guard let volunteers = self.volunteers as Array<User>? else {
      return cell
    }
    cell.setupVolunteer(volunteers[indexPath.row])
    volunteers[indexPath.row].assistedToSession(session!, ctx: self.dataLayer.managedObjectContext!) ?  cell.setupVolunteerWithImage(CheckImageName, animated: false) : cell.setupVolunteerWithImage(UncheckImageName, animated: false)
    return cell
  }
  
}

// MARK: - UITableViewDelegate

extension VolunteersViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    guard let volunteers = self.volunteers as Array<User>? else {
      return
    }
    let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as! VolunteerTableViewCell
    volunteers[indexPath.row].assistedToSession(session!, ctx: self.dataLayer.managedObjectContext!) ? checkVolunteer(volunteers[indexPath.row], cell: selectedCell, attended: false) :
      checkVolunteer(volunteers[indexPath.row], cell: selectedCell, attended: true)
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
  }
  
  func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
    let rateAction = UITableViewRowAction(style: .Normal, title: RateButtonTitle, handler: { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
      let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(RateVolunteerViewControllerIdentifier) as! RateVolunteerViewController
      self.setupPopupNavigationBar()
      viewController.volunteer = self.volunteers[indexPath.row]
      let ratePopupViewController = STPopupController(rootViewController: viewController)
      ratePopupViewController!.presentInViewController(self)
    })
    rateAction.backgroundColor = UIColor.defaultTextColor()
    return [rateAction]
  }
  
}
