//
//  AssistantDetailViewController.swift
//  EducaApp
//
//  Created by Alonso on 9/22/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

let kSessionCommentCellIdentifier = "SessionCommentCell"

class AssistantDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  let goToCommentSegueIdentifier = "ShowCommentSegue"
  
  var assistant: String?
  var firstBlockComments: NSMutableArray = ["Alonso Alvarez", "Fernando Banda", "Luis Barcena", "Daekef Abarca"]
  var secondBlockComments: NSMutableArray = ["Gloria Cisneros", "Diego Malpartida", "Luis Incio", "Gabriel Tovar"]
  var sections: NSMutableArray = ["16/09/2015", "01/09/2015"]
  
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
    title = assistant
  }
  
  // MARK: - Actions
  
  @IBAction func goToSendCommentSection(sender: AnyObject) {
    self.performSegueWithIdentifier(goToCommentSegueIdentifier, sender: nil)
  }
  
  // MARK: - Navigation
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.destinationViewController is UINavigationController {
      let destination = segue.destinationViewController as! UINavigationController
      let destinationVC = destination.viewControllers[0] as! AssistantCommentViewController
      destinationVC.delegate = self
      destinationVC.assistant = assistant
      if sender != nil {
        destinationVC.comment = sender as? SessionComment
      }
    }
  }
  
  // MARK: - UITableViewDataSource
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return sections.count
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sections[section] as? String
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(kSessionCommentCellIdentifier, forIndexPath: indexPath) as! SessionCommentTableViewCell
    if indexPath.section == 0 {
      cell.setupSessionComment(firstBlockComments[indexPath.row] as! String)
    } else {
      cell.setupSessionComment(secondBlockComments[indexPath.row] as! String)
    }
    return cell
  }
  
  //  MARK: - UITableViewDelegate
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    let comment = SessionComment()
    if indexPath.section == 0 {
      comment.author = firstBlockComments[indexPath.row] as? String
    } else {
      comment.author = secondBlockComments[indexPath.row] as? String
    }
    self.performSegueWithIdentifier(goToCommentSegueIdentifier, sender: comment)
  }
  
}
