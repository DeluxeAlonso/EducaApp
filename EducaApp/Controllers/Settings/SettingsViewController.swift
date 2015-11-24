//
//  SettingsViewController.swift
//  EducaApp
//
//  Created by Alonso on 9/14/15.
//  Copyright (c) 2015 Alonso. All rights reserved.
//

import UIKit
import CoreData


class SettingsViewController: StaticDataTableViewController {
  
  @IBOutlet weak var menuIcon: UIBarButtonItem!
  
  @IBOutlet weak var changePasswordCell: UITableViewCell!
  
  @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
  
  @IBOutlet weak var eventCell: UITableViewCell!
  @IBOutlet weak var paymentCell: UITableViewCell!
  @IBOutlet weak var documentsCell: UITableViewCell!
  @IBOutlet weak var reportsCell: UITableViewCell!
  
  @IBOutlet weak var eventSwitch: UISwitch!
  @IBOutlet weak var paymentSwitch: UISwitch!
  @IBOutlet weak var documentsSwitch: UISwitch!
  @IBOutlet weak var reportsSwitch: UISwitch!
  
  let MenuButtonSelector: Selector = "revealToggle:"
  
  let SignOutCellTexts = "Cerrar Sesión"
  let ActionSheetTitle = "¿Está seguro de que desea salir?"
  
  var currentUser: User?
  
  lazy var dataLayer = DataLayer()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupElements()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    dataLayer.managedObjectContext?.rollback()
  }
  
  // MARK: - Private
  
  private func setupElements() {
    saveBarButtonItem.enabled = false
    currentUser = User.getAuthenticatedUser(dataLayer.managedObjectContext!)
    setupBarButtonItem()
    setupNavigationBar()
    setupNotifications()
  }
  
  private func setupBarButtonItem() {
    if self.revealViewController() != nil {
      menuIcon?.target = self.revealViewController()
      menuIcon?.action = MenuButtonSelector
      view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
  }
  
  private func setupNavigationBar() {
    UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
    view.backgroundColor = UIColor.defaultBackgroundColor()
    navigationController?.navigationBar.barTintColor = UIColor.defaultTextColor()
    navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
  }
  
  private func setupNotifications() {
    setupNotificationSwitchs()
    self.cell(eventCell, setHidden: true)
    self.cell(documentsCell, setHidden: true)
    self.cell(paymentCell, setHidden: true)
    self.cell(reportsCell, setHidden: true)
    if currentUser!.hasPermissionWithId(12) == true || currentUser!.hasPermissionWithId(15) == true {
      self.cell(eventCell, setHidden: false)
      self.cell(documentsCell, setHidden: false)
    }
    if currentUser?.hasPermissionWithId(24) == true {
      self.cell(paymentCell, setHidden: false)
    }
    if currentUser?.hasPermissionWithId(21) == true || currentUser?.hasPermissionWithId(39) == true {
      self.cell(reportsCell, setHidden: false)
    }
    self.reloadDataAnimated(false)
  }
  
  private func setupNotificationSwitchs() {
    eventSwitch.on = (currentUser?.pushEvents)!
    paymentSwitch.on = (currentUser?.pushFees)!
    documentsSwitch.on = (currentUser?.pushDocuments)!
    reportsSwitch.on = (currentUser?.pushReports)!
  }
  
  private func showSignOutActionSheet(cell: SettingsTableViewCell) {
    let alertController = UIAlertController(title: ActionSheetTitle, message: nil, preferredStyle: .ActionSheet)
    let ok = UIAlertAction(title: "Cerrar Sesión", style: .Destructive, handler: { (action) -> Void in
      self.signOut()
    })
    let cancel = UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil)

    alertController.addAction(ok)
    alertController.addAction(cancel)
    
    if let popoverController = alertController.popoverPresentationController {
      popoverController.sourceView = cell
      popoverController.sourceRect = cell.bounds
    }
    
    presentViewController(alertController, animated: true, completion: nil)
  }
  
  private func signOut() {
    NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notification.SignOut, object: self, userInfo: nil)
    User.signOut()
    clearInformation()
  }
  
  private func clearInformation(){
    let model = self.dataLayer.managedObjectModel
    for entityName in model.entitiesByName.keys {
      let fr = NSFetchRequest(entityName: entityName )
      let entitiy = try! self.dataLayer.managedObjectContext!.executeFetchRequest(fr) as! [NSManagedObject]
      for object in entitiy {
        self.dataLayer.managedObjectContext!.deleteObject(object)
      }
    }
    try! self.dataLayer.managedObjectContext!.save()
  }
  
  override func tableView(tableView: UITableView,
    didSelectRowAtIndexPath indexPath: NSIndexPath) {
      if indexPath.section == 2 {
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as! SettingsTableViewCell
        showSignOutActionSheet(selectedCell)
      }
      tableView.deselectRowAtIndexPath(indexPath, animated: false)
  }
  
  private func showActivityIndicator() {
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle:UIActivityIndicatorViewStyle.White)
    activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
    let barButton = UIBarButtonItem(customView: activityIndicator)
    self.navigationItem.rightBarButtonItem = barButton
    activityIndicator.startAnimating()
  }
  
  private func hideActivityIndicator() {
    let barButton = UIBarButtonItem(title: "Guardar", style: UIBarButtonItemStyle.Plain, target: self, action: "saveButtonPressed:")
    saveBarButtonItem = barButton
    saveBarButtonItem.enabled = false
    self.navigationItem.rightBarButtonItem = barButton
  }
  
  // MARK: - Actions
  
  @IBAction func saveButtonPressed(sender: AnyObject) {
    showActivityIndicator()
    let dictionary = NSMutableDictionary()
    dictionary["push_events"] = (currentUser?.pushEvents)!
    dictionary["push_fees"] = (currentUser?.pushFees)!
    dictionary["push_documents"] = (currentUser?.pushDocuments)!
    dictionary["push_reports"] = (currentUser?.pushReports)!
    
    UserService.saveSettings(dictionary, completion: {(responseObject: AnyObject?, error: NSError?) in
      self.hideActivityIndicator()
      guard let json = responseObject as? NSDictionary else {
        Util.showAlertWithTitle(self, title: "Error", message: "No se pudo guardar los cambios", buttonTitle: "OK")
        return
      }
      if json[Constants.Api.ErrorKey] == nil {
        Util.showAlertWithTitle(self, title: "Enhorabuena", message: "Los cambios fueron guardados.", buttonTitle: "OK")
        self.dataLayer.saveContext()
      }
    })
  }
  
  @IBAction func eventValueChanged(sender: UISwitch) {
    saveBarButtonItem.enabled = true
    if sender.on {
      currentUser?.pushEvents = true
    } else {
      currentUser?.pushEvents = false
    }
  }
  
  @IBAction func paymentValueChanged(sender: UISwitch) {
    saveBarButtonItem.enabled = true
    if sender.on {
      currentUser?.pushFees = true
    } else {
      currentUser?.pushFees = false
    }
  }
  
  @IBAction func documentsValueChanged(sender: UISwitch) {
    saveBarButtonItem.enabled = true
    if sender.on {
      currentUser?.pushDocuments = true
    } else {
      currentUser?.pushDocuments = false
    }
  }
  
  @IBAction func reportsValueChanged(sender: UISwitch) {
    saveBarButtonItem.enabled = true
    if sender.on {
      currentUser?.pushReports = true
    } else {
      currentUser?.pushReports = false
    }
  }
  
}
