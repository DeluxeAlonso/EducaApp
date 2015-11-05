//
//  AssistantDetailViewController.swift
//  EducaApp
//
//  Created by Alonso on 9/22/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

let SearchSelector: Selector = "showSearchBar:"
let AdvancedSearchSelector: Selector = "showAdvancedSearchPopup:"
let SessionCommentCellIdentifier = "SessionCommentCell"
let CollapseSectionHeaderViewIdentifier = "CollapseHeader"
let CollectionHeaderViewNibName = "CollapseSectionHeaderView"
let SendAssistantCommentViewIdentifier = "SendAssistantCommentViewController"
let AssistantCommentsFilterViewIdentifier = "AssistantCommentsFilterViewController"

class AssistantDetailViewController: BaseFilterViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var genderLabel: UILabel!
  @IBOutlet weak var ageLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var sessionCountLabel: UILabel!
  @IBOutlet weak var commentViewLabel: UILabel!
  
  @IBOutlet weak var heightConstraint: NSLayoutConstraint!
  
  let commentViewText = "Comentarios"
  
  var sections: NSMutableArray = ["16/09/2015", "01/09/2015"]
  var collapseSectionsInfo:[CollapseSectionModel] = Array()
  
  var popupViewController: STPopupController?
  var sendCommentPopupViewController: STPopupController?
  
  var isSearchBarOpen = false
  var isKeyboardVisible = false
  var initialHeightConstant: CGFloat!
  
  var student: Student?
  var studentComments = [Comment]()
  
  // MARK: - Lifecycle
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
  }
  
  override func awakeFromNib() {
    for section in sections {
        self.collapseSectionsInfo.append(CollapseSectionModel(sectionName: section as! String, section: sections.indexOfObject(section), open: true))
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupElements()
    setupComments()
  }
  
  // MARK: - Private
  
  private func setupElements() {
    title = student?.fullName
    setupObservers()
    setupLabels()
    setupSearchBar()
    setupTableView()
  }
  
  private func setupObservers() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Constants.KeyboardSelector.WillShow, name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Constants.KeyboardSelector.WillHide, name: UIKeyboardWillHideNotification, object: nil)
  }
  
  private func setupLabels() {
    genderLabel.textColor = UIColor.defaultSmallTextColor()
    ageLabel.textColor = UIColor.defaultSmallTextColor()
    dateLabel.textColor = UIColor.defaultSmallTextColor()
    sessionCountLabel.textColor = UIColor.defaultSmallTextColor()
  }
  
  override internal func setupSearchBar() {
    super.setupSearchBar()
    initialHeightConstant = heightConstraint.constant
  }
  
  private func setupTableView() {
    setupTableViewHeader()
    self.tableView.estimatedRowHeight = 64
    self.tableView.rowHeight = UITableViewAutomaticDimension
  }
  
  private func setupTableViewHeader() {
    let sectionHeader = UINib(nibName: CollectionHeaderViewNibName, bundle: nil)
    self.tableView.registerNib(sectionHeader, forHeaderFooterViewReuseIdentifier: CollapseSectionHeaderViewIdentifier)
  }
  
  private func setupComments() {
    getComments()
  }
  
  private func getComments() {
    StudentService.fetchStudentComments(1, completion: {(responseObject: AnyObject?, error: NSError?) in
      print(responseObject)
      guard let json = responseObject as? NSDictionary where json.count > 0 else {
        return
      }
      if (json[Constants.Api.ErrorKey] == nil) {
        self.student = Student.updateOrCreateWithJson(json, ctx: self.dataLayer.managedObjectContext!)
        Comment.syncWithJsonArray(self.student!, arr: (json["comments"] as? Array<NSDictionary>)!, ctx: self.dataLayer.managedObjectContext!)
        self.setupInfoLabels()
        self.dataLayer.saveContext()
        let comments = Comment.getAllComments(self.dataLayer.managedObjectContext!)
        print(comments.count)
        for comment in comments {
          print(comment.id)
          print(comment.message)
          print(comment.face)
          print(comment.author.fullName)
        }
        self.tableView.reloadData()
      }
    })
  }
  
  private func setupInfoLabels() {
    ageLabel.text = "Edad:\n\((student?.age)!) años"
    let gender = student?.gender == 0 ? "Masculino" : "Femenino"
    genderLabel.text = "Género:\n\(gender)"
    sessionCountLabel.text = "Sesiones:\n\((student?.sessionsQty)!)"
    let date = student?.joiningDate
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "dd/M/Y"
    let dateString = dateFormatter.stringFromDate(date!)
    dateLabel.text = "Fecha de inscripción: \(dateString)"
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
  
  private func setupPopupNavigationBar() {
    STPopupNavigationBar.appearance().barTintColor = UIColor.defaultTextColor()
    STPopupNavigationBar.appearance().tintColor = UIColor.whiteColor()
    STPopupNavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.lightFontWithFontSize(17)]
  }
  
  private func hideSearchBar() {
    isSearchBarOpen = false
    let duration = 0.3
    searchBar.resignFirstResponder()
    setupSearchButton()
    UIView.animateWithDuration(duration, animations: {
      self.navigationItem.titleView?.alpha = 0
      }, completion: { finished in
        self.navigationItem.title = self.student?.fullName
        self.navigationItem.titleView = nil
    })
  }
  
  // MARK: - UISearchBarDelegate
  
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    hideSearchBar()
  }

  // MARK: - Public
  
  func dismissPopup() {
    popupViewController!.dismiss()
  }
  
  func dismissSendCommentPopup() {
    sendCommentPopupViewController!.dismiss()
  }
  
  // MARK: - Actions
  
  @IBAction func goToSendCommentSection(sender: AnyObject) {
    hideSearchBar()
    let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(SendAssistantCommentViewIdentifier) as! SendAssistantCommentViewController
    viewController.assistant = student?.fullName
    viewController.delegate = self
    setupPopupNavigationBar()
    sendCommentPopupViewController = STPopupController(rootViewController: viewController)
    sendCommentPopupViewController!.presentInViewController(self)
  }
  
  @IBAction func showSearchBar(sender: AnyObject) {
    isSearchBarOpen = true
    navigationItem.titleView = searchBar
    searchBar.alpha = 0
    setupAdvancedSearchButton()
    UIView.animateWithDuration(0.5, animations: {
      self.searchBar.alpha = 1
      self.searchBar.becomeFirstResponder()
      }, completion: { finished in
        
    })
  }
  
  @IBAction func showAdvancedSearchPopup(sender: AnyObject) {
    hideSearchBar()
    let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(AssistantCommentsFilterViewIdentifier) as! AssistantCommentsFilterViewController
    viewController.delegate = self
    setupPopupNavigationBar()
    popupViewController = STPopupController(rootViewController: viewController)
    popupViewController!.presentInViewController(self)
  }
  
  // MARK: - Notifications
  
  func keyboardWillShow(notification: NSNotification) {
    guard !isKeyboardVisible && isSearchBarOpen else {
      return
    }
    isKeyboardVisible = true
    view.layoutIfNeeded()
    if let keyboardFrame: CGRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
      heightConstraint.constant = 0
      view.layoutIfNeeded()
      var contentInset = tableView.contentInset
      var scrollIndicatorInset = tableView.scrollIndicatorInsets
      let bottomInset = keyboardFrame.size.height
      contentInset.bottom = bottomInset
      scrollIndicatorInset.bottom = bottomInset
      tableView.contentInset = contentInset
      tableView.scrollIndicatorInsets = scrollIndicatorInset
    }
  }
  
  func keyboardWillHide(notification: NSNotification) {
    guard isKeyboardVisible else {
      return
    }
    isKeyboardVisible = false
    view.layoutIfNeeded()
    heightConstraint.constant = initialHeightConstant
    view.layoutIfNeeded()
    var inset = tableView.contentInset
    inset.top = topLayoutGuide.length - (initialHeightConstant / 2)
    inset.bottom = bottomLayoutGuide.length
    tableView.contentInset = inset
    tableView.scrollIndicatorInsets = inset
    view.endEditing(true)
  }
  
}

// MARK: - UITableViewDataSource

extension AssistantDetailViewController: UITableViewDataSource {
  
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
      comment.mood = Constants.MockData.FirstBlockMoods[indexPath.row] as? Int
    } else {
      comment.author = Constants.MockData.SecondBlockAuthors[indexPath.row] as? String
      comment.comment = Constants.MockData.SecondBlockComments[indexPath.row] as? String
      comment.mood = Constants.MockData.SecondBlockMoods[indexPath.row] as? Int
    }
    cell.setupSessionComment(comment)
    return cell
  }
  
}

//  MARK: - UITableViewDelegate

extension AssistantDetailViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    let comment = SessionComment()
    if indexPath.section == 0 {
      comment.author = Constants.MockData.FirstBlockAuthors[indexPath.row] as? String
      comment.comment = Constants.MockData.FirstBlockComments[indexPath.row] as? String
      comment.mood = Constants.MockData.FirstBlockMoods[indexPath.row] as? Int
    } else {
      comment.author = Constants.MockData.SecondBlockAuthors[indexPath.row] as? String
      comment.comment = Constants.MockData.SecondBlockComments[indexPath.row] as? String
      comment.mood = Constants.MockData.SecondBlockMoods[indexPath.row] as? Int
    }
    let cell = tableView.cellForRowAtIndexPath(indexPath) as! SessionCommentTableViewCell
    if Util.needsPopoverPresentation(cell.volunteerNameLabel, string: comment.fullComment) {
      showPopoverCommentView(indexPath, comment: comment)
    }
  }
  
}

// MARK: - UIPopoverPresentationControllerDelegate

extension AssistantDetailViewController: UIPopoverPresentationControllerDelegate {
  
  func adaptivePresentationStyleForPresentationController(
    controller: UIPresentationController) -> UIModalPresentationStyle {
      return .None
  }
  
}

// MARK: - CollapseSectionHeaderViewDelegate

extension AssistantDetailViewController: CollapseSectionHeaderViewDelegate {
  
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
