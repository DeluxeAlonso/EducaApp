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
  @IBOutlet weak var studentInfoView: UIView!
  @IBOutlet weak var commentView: UIView!
  @IBOutlet weak var genderLabel: UILabel!
  @IBOutlet weak var ageLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var sessionCountLabel: UILabel!
  @IBOutlet weak var commentViewLabel: UILabel!
  @IBOutlet weak var customLoader: CustomActivityIndicatorView!
  @IBOutlet weak var heightConstraint: NSLayoutConstraint!
  
  let commentViewText = "Comentarios"
  
  let refreshDataSelector: Selector = "refreshData"
  let refreshControl = CustomRefreshControlView()
  
  var collapseSectionsInfo:[CollapseSectionModel] = Array()
  
  var popupViewController: STPopupController?
  var sendCommentPopupViewController: STPopupController?
  
  var isSearchBarOpen = false
  var isRefreshing = false
  var isKeyboardVisible = false
  var initialHeightConstant: CGFloat!
  
  var session: Session?
  
  var sessions = [Session]()
  var sessionStudent: SessionStudent?
  var student: Student?
  var studentComments = [Comment]()
  var sessionComments = [Int: [Comment]]()
  
  // MARK: - Lifecycle
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
  }
  
  override func awakeFromNib() {
    sessions = Session.getAllSessions(dataLayer.managedObjectContext!)
    for session in sessions {
        self.collapseSectionsInfo.append(CollapseSectionModel(sectionName: session.name , section: sessions.indexOf(session)!, open: true))
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
    setupTableView()
    setupLabels()
    setupSearchBar()
  }
  
  private func setupObservers() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Constants.KeyboardSelector.WillShow, name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Constants.KeyboardSelector.WillHide, name: UIKeyboardWillHideNotification, object: nil)
  }
  
  private func setupTableView() {
    tableView.addSubview(refreshControl)
    refreshControl.addTarget(self, action: refreshDataSelector, forControlEvents: UIControlEvents.ValueChanged)
    setupTableViewHeader()
    self.tableView.estimatedRowHeight = 64
    self.tableView.rowHeight = UITableViewAutomaticDimension
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
  
  private func setupTableViewHeader() {
    let sectionHeader = UINib(nibName: CollectionHeaderViewNibName, bundle: nil)
    self.tableView.registerNib(sectionHeader, forHeaderFooterViewReuseIdentifier: CollapseSectionHeaderViewIdentifier)
  }
  
  private func setupComments() {
    fillDataSource()
    guard Int((student?.sessionsQty)!) == 0  else {
      setupInfoLabels()
      self.reloadData()
      getComments()
      return
    }
    hideViews()
    customLoader.startActivity()
    getComments()
  }
  
  private func getComments() {
    StudentService.fetchStudentComments((student?.id)!, completion: {(responseObject: AnyObject?, error: NSError?) in
      self.refreshControl.endRefreshing()
      self.isRefreshing = false
      guard let json = responseObject as? NSDictionary where json.count > 0 else {
        self.customLoader.stopActivity()
        return
      }
      if (json[Constants.Api.ErrorKey] == nil) {
        self.student = Student.updateOrCreateWithJson(json, ctx: self.dataLayer.managedObjectContext!)
        Comment.syncWithJsonArray(self.student!, arr: (json["comments"] as? Array<NSDictionary>)!, ctx: self.dataLayer.managedObjectContext!)
        self.dataLayer.saveContext()
        self.setupInfoLabels()
        self.reloadData()
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
  
  private func fillDataSource() {
    sessionComments = [Int: [Comment]]()
    for session in sessions {
      let comments = Comment.getCommentsBySessionAndStudent(session, student: student!, ctx: dataLayer.managedObjectContext!)
      sessionComments[Int(session.id)] = comments
    }
  }
  
  private func showPopoverCommentView(indexPath: NSIndexPath, comment: Comment) {
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
  
  private func showViews() {
    tableView.hidden = false
    studentInfoView.hidden = false
    commentView.hidden = false
  }
  
  private func hideViews() {
    tableView.hidden = true
    studentInfoView.hidden = true
    commentView.hidden = true
  }
  
  private func updateSectionHeaders() {
    collapseSectionsInfo = Array()
    for session in sessions {
      self.collapseSectionsInfo.append(CollapseSectionModel(sectionName: session.name , section: sessions.indexOf(session)!, open: true))
    }
  }
  
  private func quickSearchComments(searchText: String) {
    searchText == "" ? fillDataSource() : fillDataSourceWithSearchText(searchText)
    tableView.reloadData()
  }
  
  private func resetSearchFields() {
    searchBar.text = ""
    quickSearchComments("")
  }
  
  // MARK: - UISearchBarDelegate
  
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    resetSearchFields()
    hideSearchBar()
  }
  
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    guard let searchText = searchBar.text else {
      return
    }
    quickSearchComments(searchText)
  }

  // MARK: - Public
  
  func dismissPopup() {
    popupViewController!.dismiss()
  }
  
  func dismissSendCommentPopup() {
    sendCommentPopupViewController!.dismiss()
  }
  
  func refreshData() {
    isRefreshing = true
    Util.delay(2.0) {
      self.getComments()
    }
  }
  
  func reloadData() {
    isRefreshing = true
    self.sessions = Session.getAllSessions(self.dataLayer.managedObjectContext!)
    self.updateSectionHeaders()
    fillDataSource()
    guard !self.isRefreshing else {
      self.tableView.reloadData()
      return
    }
    Util.delay(0.5) {
      self.customLoader.stopActivity()
      self.showViews()
      self.tableView.reloadData()
    }
  }
  
  // MARK: - Actions
  
  @IBAction func goToSendCommentSection(sender: AnyObject) {
    guard session!.date.compare(NSDate()) == NSComparisonResult.OrderedAscending else {
      Util.showAlertWithTitle(self, title: "Error", message: "No se puede dejar un comentario debido a que la sesión aun no ha empezado.", buttonTitle: "OK")
      return
    }
    hideSearchBar()
    let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(SendAssistantCommentViewIdentifier) as! SendAssistantCommentViewController
    viewController.assistant = student?.fullName
    viewController.delegate = self
    if let comment = Comment.getCommentBySessionAndStudentAndAuthor(session!, student: student!, author: currentUser!, ctx: dataLayer.managedObjectContext!) {
      viewController.currentComment = comment
    }
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
    viewController.nameSearchString = searchBar.text
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
    return sessions.count
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    let sessionId = sessions[section].id
    let comments = sessionComments[Int(sessionId)]
    if comments?.count == 0 {
      return 0
    }
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
    let sessionId = sessions[section].id
    let comments = sessionComments[Int(sessionId)]
    return (comments?.count)!
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(SessionCommentCellIdentifier, forIndexPath: indexPath) as! SessionCommentTableViewCell
    let sessionId = sessions[indexPath.section].id
    let comments = sessionComments[Int(sessionId)]
    cell.setupSessionComment(comments![indexPath.row])
    return cell
  }
  
}

//  MARK: - UITableViewDelegate

extension AssistantDetailViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    let cell = tableView.cellForRowAtIndexPath(indexPath) as! SessionCommentTableViewCell
    let sessionId = sessions[indexPath.section].id
    let comments = sessionComments[Int(sessionId)]
    let comment = comments![indexPath.row]
    if Util.needsPopoverPresentation(cell.volunteerNameLabel, string: comment.message) {
      showPopoverCommentView(indexPath, comment: comment)
    }
  }
  
}

// MARK: - UIScrollViewDelegate

extension AssistantDetailViewController: UIScrollViewDelegate {
  
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    guard refreshControl.refreshing && !refreshControl.isAnimating else {
      return
    }
    refreshControl.animateRefreshFirstStep()
  }
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    var offset = scrollView.contentOffset.y * -1
    var alpha = CGFloat(0.0)
    offset = offset - 5
    if offset > 30 {
      alpha = ((offset) / 100)
      if alpha > 100 {
        alpha = 1.0
      }
    }
    refreshControl.customView.alpha = alpha
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
    let sessionId = sessions[section].id
    let comments = sessionComments[Int(sessionId)]
    let rowsToInsert = comments!.count
    var indexPathsToInsert:[NSIndexPath] = Array()
    for i in 0..<rowsToInsert {
      indexPathsToInsert.append(NSIndexPath(forRow: i, inSection: section))
    }
    self.tableView.beginUpdates()
    self.tableView.insertRowsAtIndexPaths(indexPathsToInsert, withRowAnimation:UITableViewRowAnimation.Top)
    self.tableView.endUpdates()
  }
  
  func collapseSectionHeaderViewDelegate(sectionHeaderView: CollapseSectionHeaderView, sectionClosed section: Int) {
    let sessionId = sessions[section].id
    let comments = sessionComments[Int(sessionId)]
    let rowsToDelete = comments!.count
    var indexPathsToDelete:[NSIndexPath] = Array()
    for i in 0..<rowsToDelete {
      indexPathsToDelete.append(NSIndexPath(forRow: i, inSection: section))
    }
    self.tableView.beginUpdates()
    self.tableView.deleteRowsAtIndexPaths(indexPathsToDelete, withRowAnimation:UITableViewRowAnimation.Top)
    self.tableView.endUpdates()
  }
  
}

// MARK: - AssistantCommentsFilterViewControllerDelegate

extension AssistantDetailViewController: AssistantCommentsFilterViewControllerDelegate {
  
  func assistantCommentsFilterViewController(assistantCommentsFilterViewController: AssistantCommentsFilterViewController, searchedAuthor: String, minDate: NSDate?, maxDate: NSDate?, sortType: String) {
    var searchedSessions = sortType == "Más Actual" ? Session.getAllSessions(dataLayer.managedObjectContext!) : Session.getAllOldSessions(dataLayer.managedObjectContext!)
    if minDate != nil {
      searchedSessions = searchedSessions.filter({ (session) in
        return session.date.getNumberOfDays() >= minDate?.getNumberOfDays()
      })
    }
    if maxDate != nil {
      searchedSessions = searchedSessions.filter({ (session) in
        return session.date.getNumberOfDays() <= maxDate?.getNumberOfDays()
      })
    }
    sessions = searchedSessions
    updateSectionHeaders()
    searchedAuthor == "" ? fillDataSource() : fillDataSourceWithSearchText(searchedAuthor)
    tableView.reloadData()
    popupViewController?.dismiss()
  }
  
  private func fillDataSourceWithSearchText(searchText: String) {
    sessionComments = [Int: [Comment]]()
    for session in sessions {
      let comments = Comment.getCommentsBySessionAndStudentWithSearch(searchText,session: session, student: student!, ctx: dataLayer.managedObjectContext!)
      sessionComments[Int(session.id)] = comments
    }
  }
  
}

  // MARK: - SendAssistantCommentViewControllerDelegate

extension AssistantDetailViewController: SendAssistantCommentViewControllerDelegate {
  
  func sendAssistantCommentViewController(sendAssistantCommentViewController: SendAssistantCommentViewController, comment: String, face: Int) {
    let parameters = [CommentMessageKey: comment, CommentFaceKey: face]
    sendCommentPopupViewController?.dismiss()
    StudentService.commentStudent((sessionStudent?.sessionStudentId)!, parameters: parameters, completion: {(responseObject: AnyObject?, error: NSError?) in
      guard let json = responseObject as? NSDictionary where json.count > 0 else {
        return
      }
      if (json[Constants.Api.ErrorKey] == nil && json[CommentMessageKey] == nil) {
        self.student = Student.updateOrCreateWithJson(json, ctx: self.dataLayer.managedObjectContext!)
        Comment.syncWithJsonArray(self.student!, arr: (json["comments"] as? Array<NSDictionary>)!, ctx: self.dataLayer.managedObjectContext!)
        self.dataLayer.saveContext()
        self.setupInfoLabels()
        self.fillDataSource()
        self.reloadData()
      }
    })
  }
  
}

