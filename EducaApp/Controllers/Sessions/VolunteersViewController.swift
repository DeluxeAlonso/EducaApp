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
  
  @IBOutlet weak var saveButton: UIBarButtonItem!
  @IBOutlet weak var tableView: UITableView!
  
  let UncheckImageName = "UncheckMark"
  let CheckImageName = "CheckAssistanceIcon"
  let RateButtonTitle = "Calificar"

  var session: Session?
  var sessionUsers = [SessionUser]()
  var delegate: SessionsViewController?
  var ratePopupViewController: STPopupController?
  
  var popupWasShowed = false
  
  var isSaved: Bool?
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    if popupWasShowed == false {
      popupWasShowed = true
      dataLayer.managedObjectContext?.rollback()
    }
  }
  
  // MARK: - Private
  
  private func setupPopupNavigationBar() {
    STPopupNavigationBar.appearance().barTintColor = UIColor.defaultTextColor()
    STPopupNavigationBar.appearance().tintColor = UIColor.whiteColor()
    STPopupNavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.lightFontWithFontSize(17)]
  }
  
  private func enableSaveButton() {
    isSaved = false
    saveButton.enabled = true
  }
  
  // MARK: - Actions
  
  @IBAction func saveVolunteersInfo(sender: AnyObject) {
    dataLayer.saveContext()
    if Util.connectedToNetwork() == true {
      showActivityIndicator()
    } else{
      Util.showAlertWithTitle(self, title: "No se encontro una red.", message: "Tus cambios seran enviados cuando la señal sea detectada.", buttonTitle: "OK")
      saveButton.enabled = false
    }
    updateVolunteerAttendance()
  }
  
}

// MARK: - UITableViewDataSource

extension VolunteersViewController: UITableViewDataSource {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sessionUsers.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(VolunteerCellIdentifier, forIndexPath: indexPath) as! VolunteerTableViewCell
    guard let volunteers = self.sessionUsers as Array<SessionUser>? else {
      return cell
    }
    cell.setupVolunteer(sessionUsers[indexPath.row].user)
    volunteers[indexPath.row].user.assistedToSession(session!, ctx: self.dataLayer.managedObjectContext!) ?  cell.setupVolunteerWithImage(CheckImageName, animated: false) : cell.setupVolunteerWithImage(UncheckImageName, animated: false)
    return cell
  }
  
}

// MARK: - UITableViewDelegate

extension VolunteersViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    guard session?.date.compare(NSDate()) == NSComparisonResult.OrderedAscending else {
      Util.showAlertWithTitle(self, title: "Error", message: "No se puede marcar asistencia debido a que la sesión aun no ha empezado.", buttonTitle: "OK")
      return
    }
    guard let volunteers = self.sessionUsers as Array<SessionUser>? else {
      return
    }
    let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as! VolunteerTableViewCell
    volunteers[indexPath.row].user.assistedToSession(session!, ctx: self.dataLayer.managedObjectContext!) ? checkVolunteer(indexPath, cell: selectedCell, attended: false) :
      checkVolunteer(indexPath, cell: selectedCell, attended: true)
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
  }
  
  func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
    let rateAction = UITableViewRowAction(style: .Normal, title: RateButtonTitle, handler: { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
      guard self.session?.date.compare(NSDate()) == NSComparisonResult.OrderedAscending else {
        Util.showAlertWithTitle(self, title: "Error", message: "No se puede calificar al usuario debido a que la sesión aun no ha empezado.", buttonTitle: "OK")
        return
      }
      if self.sessionUsers[indexPath.row].attended == false {
        Util.showAlertWithTitle(self, title: "Error", message: "No se puede calificar al usuario debido a que este no asistió.", buttonTitle: "OK")
        return
      }
      let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(RateVolunteerViewControllerIdentifier) as! RateVolunteerViewController
      self.setupPopupNavigationBar()
      viewController.delegate = self
      viewController.sessionUser = self.sessionUsers[indexPath.row]
      viewController.indexPath = indexPath
      self.ratePopupViewController = STPopupController(rootViewController: viewController)
      self.popupWasShowed = true
      self.ratePopupViewController!.presentInViewController(self)
    })
    rateAction.backgroundColor = UIColor.defaultTextColor()
    return [rateAction]
  }
  
}

// MARK: - RateVolunteerViewControllerDelegate

extension VolunteersViewController: RateVolunteerViewControllerDelegate {
  
  func rateVolunteerViewController(rateVolunteerViewController: RateVolunteerViewController, rating: Int, comment: String, indexPath: NSIndexPath) {
    enableSaveButton()
    sessionUsers[indexPath.row] = sessionUsers[indexPath.row].user.rateVolunteerInSession(session!, rating: rating, comment: comment, ctx: dataLayer.managedObjectContext!)
    requestParameters()
    ratePopupViewController!.dismiss()
  }
  
  private func checkVolunteer(indexPath: NSIndexPath, cell: VolunteerTableViewCell, attended: Bool) {
    enableSaveButton()
    sessionUsers[indexPath.row] = sessionUsers[indexPath.row].user.markAttendanceToSession(session!, attended: attended, ctx: self.dataLayer.managedObjectContext!)
    attended ? cell.setupVolunteerWithImage(CheckImageName, animated: false) : cell.setupVolunteerWithImage(UncheckImageName, animated: false)
    requestParameters()
  }
  
}

// MARK: - Networking

extension VolunteersViewController {
  
  private func requestParameters() -> NSDictionary {
    let dictionary = NSMutableDictionary()
    dictionary["session_id"] = Int(session!.id)
    let arraySessionUserDictionary = NSMutableArray()
    for sessionUser in sessionUsers {
      let volunteerDictionary = NSMutableDictionary()
      volunteerDictionary[UserIdKey] = Int(sessionUser.user.id)
      volunteerDictionary[SessionUserAttendedKey] = sessionUser.attended
      volunteerDictionary[SessionUserRatingKey] = Int(sessionUser.rating)
      volunteerDictionary[SessionUserCommentKey] = sessionUser.comment
      arraySessionUserDictionary.addObject(volunteerDictionary)
    }
    dictionary["volunteers"] = arraySessionUserDictionary
    NSUserDefaults.standardUserDefaults().setObject(dictionary, forKey: "mark_assistance")
    NSUserDefaults.standardUserDefaults().synchronize()
    return dictionary
  }
  
  private func updateVolunteerAttendance() {
    SessionService.editVolunteersAttendance(requestParameters(), completion: {(responseObject: AnyObject?, error: NSError?) in
      self.hideActivityIndicator()
      guard let json = responseObject as? NSDictionary else {
        return
      }
      if (json[Constants.Api.ErrorKey] == nil) {
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "mark_assistance")
        NSUserDefaults.standardUserDefaults().synchronize()
        let session = Session.updateOrCreateVolunteersWithJson(json, ctx: self.dataLayer.managedObjectContext!)
        self.sessionUsers = session!.volunteers.allObjects as! [SessionUser]
        self.dataLayer.saveContext()
        self.tableView.reloadData()
      }
    })
  }
  
  private func showActivityIndicator() {
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle:UIActivityIndicatorViewStyle.White)
    activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
    let barButton = UIBarButtonItem(customView: activityIndicator)
    self.navigationItem.rightBarButtonItem = barButton
    activityIndicator.startAnimating()
  }
  
  private func hideActivityIndicator() {
    let barButton = UIBarButtonItem(title: "Guardar", style: UIBarButtonItemStyle.Plain, target: self, action: "saveVolunteersInfo:")
    saveButton = barButton
    saveButton.enabled = false
    self.navigationItem.rightBarButtonItem = barButton
  }
  
}
