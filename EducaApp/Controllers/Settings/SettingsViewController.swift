//
//  SettingsViewController.swift
//  EducaApp
//
//  Created by Alonso on 9/14/15.
//  Copyright (c) 2015 Alonso. All rights reserved.
//

import UIKit
import CoreData

let kSettingsCellIdentifier = "SettingsCell"
let kSettingsCellTexts = ["Cerrar Sesión"]
let kActionSheetTitle = "¿Está seguro de que desea salir?"

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var menuIcon: UIBarButtonItem!
  
  lazy var dataLayer = DataLayer()
  
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
  
  private func setupBarButtonItem() {
    if self.revealViewController() != nil {
      self.menuIcon.target = self.revealViewController()
      self.menuIcon.action = kBarButtonSelector
      self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
  }
  
  private func showSignOutActionSheet() {
    let alertController = UIAlertController(title: kActionSheetTitle, message: nil, preferredStyle: .ActionSheet)
    let ok = UIAlertAction(title: "Cerrar Sesión", style: .Destructive, handler: { (action) -> Void in
      self.signOut()
    })
    let cancel = UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil)

    alertController.addAction(ok)
    alertController.addAction(cancel)
    
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
    return 1;
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return kSettingsCellTexts.count;
  }
  
  func tableView(tableView: UITableView,
    cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier(kSettingsCellIdentifier, forIndexPath: indexPath) as! SettingsTableViewCell
      cell.nameLabel.text = kSettingsCellTexts[indexPath.row]
      return cell
  }
  
  // MARK: - UITableViewDelegate
  
  func tableView(tableView: UITableView,
    didSelectRowAtIndexPath indexPath: NSIndexPath) {
      showSignOutActionSheet()
      tableView.deselectRowAtIndexPath(indexPath, animated: false)
  }
  
}
