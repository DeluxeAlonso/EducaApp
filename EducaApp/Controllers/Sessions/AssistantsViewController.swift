//
//  AssistantsViewController.swift
//  EducaApp
//
//  Created by Alonso on 9/22/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

let kAssistantCellIdentifier = "AssistantCell"


class AssistantsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var customView: UIView!
  
  let goToCommentViewSegueIdentifier = "ShowCommentSegue"
  let goToDetailViewSegueIdentifier = "GoToAssistantDetail"
  
  var assistants: NSMutableArray = ["Eduardo Arenas", "Julio Castillo", "Juan Reyes", "Kevin Brown", "Robert Aduviri"]
  var selectedCell: UITableViewCell?
  
  lazy var dataLayer = DataLayer()

  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Private
  
  private func goToCommentSection(tableView:UITableView, indexPath: NSIndexPath) {
    selectedCell = tableView.cellForRowAtIndexPath(indexPath) as! AssistantTableViewCell
    self.performSegueWithIdentifier(goToCommentViewSegueIdentifier, sender: assistants[indexPath.row])
  }
  
  private func goToDetailSection(tableView:UITableView, indexPath: NSIndexPath) {
    self.performSegueWithIdentifier(goToDetailViewSegueIdentifier, sender: assistants[indexPath.row])
  }
  
  // MARK: - Public
  
  func checkCommentedAssistant() {
    guard let cell = selectedCell as? AssistantTableViewCell else {
      return
    }
    cell.setupCommentedImage()
  }
  
  // MARK: - Navigation
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.destinationViewController is AssistantDetailViewController {
      let destinationVC = segue.destinationViewController as! AssistantDetailViewController
      destinationVC.assistant = sender as? String
    }
  }
  
  // MARK: - UITableViewDataSource
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return assistants.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(kAssistantCellIdentifier, forIndexPath: indexPath) as! AssistantTableViewCell
    cell.setupAssistant(assistants[indexPath.row] as! String)
    return cell
  }
  
  //  MARK: - UITableViewDelegate
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    let userType = User.getAuthenticatedUser(self.dataLayer.managedObjectContext!)?.type
    switch Int(userType!) {
    case 0:
      goToDetailSection(tableView, indexPath: indexPath)
      break
    case 1:
      goToCommentSection(tableView, indexPath: indexPath)
      break
    default:
      break
    }
  }
  
}
