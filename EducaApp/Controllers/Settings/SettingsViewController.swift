//
//  SettingsViewController.swift
//  EducaApp
//
//  Created by Alonso on 9/14/15.
//  Copyright (c) 2015 Alonso. All rights reserved.
//

import UIKit
import CoreData

let PhoneCellIdentifier = "PhoneCell"
let AddressCellIdentifier = "AddressCell"
let ChangePasswordCellIdentifier = "ChangePasswordCell"
let NotificationControlCellIdentifier = "NotificationControlCell"
let SettingsCellIdentifier = "SettingsCell"

class SettingsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
  
  let SignOutCellTexts = "Cerrar Sesión"
  let ActionSheetTitle = "¿Está seguro de que desea salir?"
  let CalendarCellText = "Sincronizar Eventos"
  let SectionHeadersTitle = ["Datos Personales", "", "Calendario","Notificaciones", ""]
  let NotificarionControlNames = ["Eventos Próximos", "Pagos Pendientes"]
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupElements()
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Private
  
  private func setupElements() {
    setupBarButtonItem()
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
  
  // MARK: - UITableViewDataSource
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return SectionHeadersTitle.count
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return SectionHeadersTitle[section]
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 1 {
      return 2
    } else if section == 3 {
      return NotificarionControlNames.count
    }
    return 1
  }
  
  func tableView(tableView: UITableView,
    cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      var cell: UITableViewCell?
      switch indexPath.section {
      case 0:
        cell = tableView.dequeueReusableCellWithIdentifier(PhoneCellIdentifier, forIndexPath: indexPath)
      case 1:
        cell = indexPath.row == 0 ? tableView.dequeueReusableCellWithIdentifier(AddressCellIdentifier, forIndexPath: indexPath) :tableView.dequeueReusableCellWithIdentifier(ChangePasswordCellIdentifier, forIndexPath: indexPath)
      case 2:
        cell = tableView.dequeueReusableCellWithIdentifier(NotificationControlCellIdentifier, forIndexPath: indexPath)
        (cell as! NotificationControlTableViewCell).setupNotificationControl(CalendarCellText)
      case 3:
        cell = tableView.dequeueReusableCellWithIdentifier(NotificationControlCellIdentifier, forIndexPath: indexPath)
        (cell as! NotificationControlTableViewCell).setupNotificationControl(NotificarionControlNames[indexPath.row])
      default:
        cell = tableView.dequeueReusableCellWithIdentifier(SettingsCellIdentifier, forIndexPath: indexPath)
        (cell as! SettingsTableViewCell).nameLabel.text = SignOutCellTexts
      }
      return cell!
  }
  
  // MARK: - UITableViewDelegate
  
  func tableView(tableView: UITableView,
    didSelectRowAtIndexPath indexPath: NSIndexPath) {
      if indexPath.section == 4 {
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as! SettingsTableViewCell
        showSignOutActionSheet(selectedCell)
      }
      tableView.deselectRowAtIndexPath(indexPath, animated: false)
  }
  
}
