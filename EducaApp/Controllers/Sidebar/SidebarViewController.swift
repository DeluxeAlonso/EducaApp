//
//  SidebarViewController.swift
//  EducaApp
//
//  Created by Alonso on 9/14/15.
//  Copyright (c) 2015 Alonso. All rights reserved.
//

import UIKit

class MenuController: StaticDataTableViewController {
  
  @IBOutlet weak var PostulationCell: UITableViewCell!
  @IBOutlet weak var NewsCell: UITableViewCell!
  @IBOutlet weak var BlogCell: UITableViewCell!
  @IBOutlet weak var PeopleCell: UITableViewCell!
  @IBOutlet weak var SesionsCell: UITableViewCell!
  @IBOutlet weak var DocumentsCell: UITableViewCell!
  @IBOutlet weak var CameraCell: UITableViewCell!
  @IBOutlet weak var PayCell: UITableViewCell!
  @IBOutlet weak var DonationCell: UITableViewCell!
  @IBOutlet weak var ReportsCell: UITableViewCell!
  @IBOutlet weak var SettingsCell: UITableViewCell!
  
  var currentUser: User?
  lazy var dataLayer = DataLayer()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    currentUser = User.getAuthenticatedUser(dataLayer.managedObjectContext!)
    setupPermissions()
    for action in (currentUser?.actions)! {
      print((action as! Action).id)
      
      var idnumber: Int32
      idnumber = (action as! Action).id
      
      switch idnumber{
      case 15:
      self.cell(SesionsCell, setHidden: false)
      self.cell(DocumentsCell, setHidden: false)
      case 14:
        //ptos de reunion
        break;
      case 16:
        //marcar asistencia
        break;
      case 28:
        //listar colegios y voluntarios
        break;
      case 31:
        //listar usuarios
        self.cell(PeopleCell, setHidden: false)
      case 20:
        //listar reporte
        self.cell(ReportsCell, setHidden: false)
      case 21:
        //menu pagos
        self.cell(PayCell, setHidden: false)
      default:
        //fotos y donaciones
        self.cell(DonationCell, setHidden: false)
        self.cell(CameraCell, setHidden: false)
        //blog y noticias
        self.cell(BlogCell, setHidden: false)
        self.cell(NewsCell, setHidden: false)
        self.cell(SettingsCell, setHidden: false)
        
        //-solo miembros de afi pueden listar comentarios (buscar codigo perfil de miembro de afi)
        //-solo voluntarios pueden postular (buscar codigo perfil voluntario)
      }
      
    }
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  private func setupPermissions() {
    self.cell(PostulationCell, setHidden: true)
    self.cell(NewsCell, setHidden: true)
    self.cell(BlogCell, setHidden: true)
    self.cell(PeopleCell, setHidden: true)
    self.cell(SesionsCell, setHidden: true)
    self.cell(DocumentsCell, setHidden: true)
    self.cell(CameraCell, setHidden: true)
    self.cell(PayCell, setHidden: true)
    self.cell(DonationCell, setHidden: true)
    self.cell(ReportsCell, setHidden: true)
    self.cell(SettingsCell, setHidden: true)
    self.reloadDataAnimated(false)
  }
  
  override func tableView(tableView: UITableView,
    didSelectRowAtIndexPath indexPath: NSIndexPath) {
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  @IBAction func selectedNewPostulation(sender: AnyObject) {
    let actionSheetController: UIAlertController = UIAlertController(title: "¿Está seguro de que desea participar en este periodo?", message: nil, preferredStyle: .Alert)
    let payPalAction: UIAlertAction = UIAlertAction(title: "Cancelar", style:UIAlertActionStyle.Cancel, handler: nil)
    actionSheetController.addAction(payPalAction)
    let depositAction: UIAlertAction = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default) { action -> Void in
    }
    actionSheetController.addAction(depositAction)
    self.presentViewController(actionSheetController, animated: true, completion: nil)

  }
  
}

