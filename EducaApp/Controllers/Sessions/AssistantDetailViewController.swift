//
//  AssistantDetailViewController.swift
//  EducaApp
//
//  Created by Alonso on 9/22/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

let SessionCommentCellIdentifier = "SessionCommentCell"
let CollapseSectionHeaderViewIdentifier = "CollapseHeader"

class AssistantDetailViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate, CollapseSectionHeaderViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var genderLabel: UILabel!
  @IBOutlet weak var ageLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var sessionCountLabel: UILabel!

  let GoToCommentSegueIdentifier = "ShowCommentSegue"
  
  var assistant: String?
  var sections: NSMutableArray = ["16/09/2015", "01/09/2015"]
  var collapseSectionsInfo:[CollapseSectionModel] = Array();
  
  override func awakeFromNib() {
    for section in sections {
        self.collapseSectionsInfo.append(CollapseSectionModel(sectionName: section as! String, section: sections.indexOfObject(section), open: true));
    }

  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupElements()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Private
  
  private func setupElements() {
    title = assistant
    setupLabels()
    setupTableView()
  }
  
  private func setupLabels() {
    genderLabel.textColor = UIColor.defaultSmallTextColor()
    ageLabel.textColor = UIColor.defaultSmallTextColor()
    dateLabel.textColor = UIColor.defaultSmallTextColor()
    sessionCountLabel.textColor = UIColor.defaultSmallTextColor()
  }
  
  private func setupTableView() {
    setupTableViewHeader()
    self.tableView.estimatedRowHeight = 64
    self.tableView.rowHeight = UITableViewAutomaticDimension
  }
  
  private func setupTableViewHeader() {
    let sectionHeader = UINib(nibName: "CollapseSectionHeaderView", bundle: nil)
    self.tableView.registerNib(sectionHeader, forHeaderFooterViewReuseIdentifier: CollapseSectionHeaderViewIdentifier)
  }
  
  private func showPopoverCommentView(indexPath: NSIndexPath, comment: SessionComment) {
    let popoverViewController = ShowAssistantCommentViewController()
    popoverViewController.setupView(comment)
    popoverViewController.modalPresentationStyle = .Popover
    popoverViewController.preferredContentSize = CGSizeMake(view.frame.width - 10, 180)
    let popoverPresentationController = popoverViewController.popoverPresentationController
    setupPopoverPresentation(popoverPresentationController!, indexPath: indexPath)
    presentViewController(popoverViewController,animated: true, completion: nil)
  }
  
  private func setupPopoverPresentation(popoverPresentationController: UIPopoverPresentationController, indexPath: NSIndexPath) {
    let cell = tableView.cellForRowAtIndexPath(indexPath)
    popoverPresentationController.delegate = self
    popoverPresentationController.permittedArrowDirections = .Any
    popoverPresentationController.sourceView = cell
    popoverPresentationController.sourceRect = (cell?.bounds)!
  }
  
  // MARK: - Actions
  
  @IBAction func goToSendCommentSection(sender: AnyObject) {
    self.performSegueWithIdentifier(GoToCommentSegueIdentifier, sender: nil)
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
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 50
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(CollapseSectionHeaderViewIdentifier) as! CollapseSectionHeaderView;
    headerView.model = self.collapseSectionsInfo[section];
    headerView.delegate = self;
    return headerView;
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let collapseSection = self.collapseSectionsInfo[section]
    if !collapseSection.open {
      return 0
    }
    return 4
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(SessionCommentCellIdentifier, forIndexPath: indexPath) as! SessionCommentTableViewCell
    let comment = SessionComment()
    if indexPath.section == 0 {
      comment.author = Constants.MockData.FirstBlockAuthors[indexPath.row] as? String
      comment.comment = Constants.MockData.FirstBlockComments[indexPath.row] as? String
    } else {
      comment.author = Constants.MockData.SecondBlockAuthors[indexPath.row] as? String
      comment.comment = Constants.MockData.SecondBlockComments[indexPath.row] as? String
    }
    cell.setupSessionComment(comment)
    return cell
  }
  
  //  MARK: - UITableViewDelegate
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    let comment = SessionComment()
    if indexPath.section == 0 {
      comment.author = Constants.MockData.FirstBlockAuthors[indexPath.row] as? String
      comment.comment = Constants.MockData.FirstBlockComments[indexPath.row] as? String
    } else {
      comment.author = Constants.MockData.SecondBlockAuthors[indexPath.row] as? String
      comment.comment = Constants.MockData.SecondBlockComments[indexPath.row] as? String
    }
    let cell = tableView.cellForRowAtIndexPath(indexPath) as! SessionCommentTableViewCell
    if Util.needsPopoverPresentation(cell.volunteerNameLabel, string: comment.fullComment) {
      showPopoverCommentView(indexPath, comment: comment)
    }
  }
  
  // MARK: - UIPopoverPresentationControllerDelegate
  
  func adaptivePresentationStyleForPresentationController(
    controller: UIPresentationController) -> UIModalPresentationStyle {
      return .None
  }
  
  // MARK: - CollapseSectionHeaderViewDelegate
  
  func collapseSectionHeaderViewDelegate(sectionHeaderView: CollapseSectionHeaderView, sectionOpened section: Int) {
    let rowsToInsert = Constants.MockData.FirstBlockAuthors.count
    var indexPathsToInsert:[NSIndexPath] = Array()
    for i in 0..<rowsToInsert {
      indexPathsToInsert.append(NSIndexPath(forRow: i, inSection: section))
    }
    self.tableView.beginUpdates()
    self.tableView.insertRowsAtIndexPaths(indexPathsToInsert, withRowAnimation:UITableViewRowAnimation.Top)
    self.tableView.endUpdates()
  }
  
  func collapseSectionHeaderViewDelegate(sectionHeaderView: CollapseSectionHeaderView, sectionClosed section: Int) {
    let rowsToDelete = Constants.MockData.FirstBlockAuthors.count
    var indexPathsToDelete:[NSIndexPath] = Array()
    for i in 0..<rowsToDelete {
      indexPathsToDelete.append(NSIndexPath(forRow: i, inSection: section))
    }
    self.tableView.beginUpdates()
    self.tableView.deleteRowsAtIndexPaths(indexPathsToDelete, withRowAnimation:UITableViewRowAnimation.Top)
    self.tableView.endUpdates()
  }
  
}
