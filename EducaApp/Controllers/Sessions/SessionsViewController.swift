//
//  SessionsViewController.swift
//  EducaApp
//
//  Created by Alonso on 9/20/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

let SessionsCellIdentifier =  "SessionCell"
let SessionDocumentsSegueIdentifier = "GoToDocumentsSegue"
let SessionVolunteersSegueIdentifier = "GoToVolunteersList"
let SessionAssistantsSegueIdentifier = "GoToAssistants"
let SessionMapSegueIdentifier = "GoToSessionMapSegue"

class SessionsViewController: BaseViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var menuContentView: UIView!
  @IBOutlet weak var menuHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var shadowView: UIView!
  
  @IBOutlet weak var customLoader: CustomActivityIndicatorView!
  @IBOutlet weak var assistanceView: UIView!
  @IBOutlet weak var documentsView: UIView!
  @IBOutlet weak var mapView: UIView!
  @IBOutlet weak var registerView: UIView!
  
  @IBOutlet weak var noSessionsLabel: UILabel!
  @IBOutlet weak var assistanceViewWidthContraint: NSLayoutConstraint!
  
  @IBOutlet weak var heightConstraintsConstant: NSLayoutConstraint!
  
  let refreshDataSelector: Selector = "refreshData"
  let refreshControl = CustomRefreshControlView()
  
  var initialHeightConstraintConstant: CGFloat?
  var sessions = [Session]()
  var selectedSession: Session?
  var isRefreshing = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupElements()
    setupSessions()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    sessions = Session.getAllSessions(dataLayer.managedObjectContext!)
  }
  
  // MARK: - Private
  
  private func setupElements() {
    setupTableView()
    setupMenuView()
    if currentUser?.canCheckAttendance() == false {
      heightConstraintsConstant.constant = self.view.frame.width / 3
      assistanceView.hidden = true
      self.view.layoutIfNeeded()
    } else {
      heightConstraintsConstant.constant = self.view.frame.width / 4
      self.view.layoutIfNeeded()
    }
  }
  
  private func setupTableView() {
    tableView.tableFooterView = UIView()
    tableView.addSubview(refreshControl)
    refreshControl.addTarget(self, action: refreshDataSelector, forControlEvents: UIControlEvents.ValueChanged)
  }
  
  private func setupMenuView() {
    initialHeightConstraintConstant = menuHeightConstraint.constant
    menuContentView.clipsToBounds = true
    menuHeightConstraint.constant = 0
  }
  
  func setupSessions() {
    sessions = Session.getAllSessions(self.dataLayer.managedObjectContext!)
    guard sessions.count == 0 else {
      getSessions()
      return
    }
    self.tableView.hidden = true
    customLoader.startActivity()
    getSessions()
  }
  
  private func getSessions() {
    SessionService.fetchSessions({(responseObject: AnyObject?, error: NSError?) in
      self.refreshControl.endRefreshing()
      self.isRefreshing = false
      guard let json = responseObject as? Array<NSDictionary> where json.count > 0 else {
        if Util.connectedToNetwork() {
          self.noSessionsLabel.hidden = false
          self.tableView.hidden = true
        }
        self.customLoader.stopActivity()
        return
      }
      if (json[0][Constants.Api.ErrorKey] == nil) {
        let syncedSessions = Session.syncWithJsonArray(json , ctx: self.dataLayer.managedObjectContext!)
        self.sessions = syncedSessions
        self.dataLayer.saveContext()
        self.reloadData()
      }
    })
  }
  
  private func showMenuView() {
    self.shadowView.translatesAutoresizingMaskIntoConstraints = true
    self.menuContentView.translatesAutoresizingMaskIntoConstraints = true
    self.navigationController?.view.addSubview(self.shadowView)
    self.navigationController?.view.addSubview(self.menuContentView)
    UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
      self.shadowView.alpha = 0.35
      self.menuContentView.frame = CGRect(x: self.menuContentView.frame.origin.x, y: self.menuContentView.frame.origin.y - self.initialHeightConstraintConstant!, width: self.menuContentView.frame.width, height: self.initialHeightConstraintConstant!)
      }, completion: nil)
    shadowView.userInteractionEnabled = true
  }
  
  private func hideMenuViewWithoutAnimation () {
    self.shadowView.alpha = 0.0
    self.menuContentView.frame = CGRect(x: self.menuContentView.frame.origin.x, y: self.menuContentView.frame.origin.y + self.initialHeightConstraintConstant!, width: self.menuContentView.frame.width, height: self.initialHeightConstraintConstant!)
  }
  
  // MARK: - Public
  
  func refreshData() {
    isRefreshing = true
    Util.delay(2.0) {
      self.getSessions()
    }
  }
  
  func reloadData() {
    guard !self.isRefreshing else {
      self.tableView.reloadData()
      return
    }
    Util.delay(0.5) {
      self.customLoader.stopActivity()
      self.tableView.hidden = false
      self.tableView.reloadData()
    }
  }
  
  // MARK: - Actions
  
  @IBAction func hideMenuView(sender: AnyObject) {
    UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
      self.hideMenuViewWithoutAnimation()
      }, completion: nil)
  }
  
  @IBAction func goToSessionDocuments(sender: AnyObject) {
    performSegueWithIdentifier(SessionDocumentsSegueIdentifier, sender: nil)
    hideMenuViewWithoutAnimation()
  }
  
  @IBAction func goToSessionMap(sender: AnyObject) {
    hideMenuView(NSNull)
    performSegueWithIdentifier(SessionMapSegueIdentifier, sender: nil)
  }
  
  @IBAction func goToAssistantsList(sender: AnyObject) {
    hideMenuViewWithoutAnimation()
    performSegueWithIdentifier(SessionAssistantsSegueIdentifier, sender: nil)
  }
  
  @IBAction func goToVolunteersList(sender: AnyObject) {
    hideMenuViewWithoutAnimation()
    performSegueWithIdentifier(SessionVolunteersSegueIdentifier, sender: nil)
  }
  
  // MARK: - Navigation
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    switch segue.destinationViewController {
    case is DocumentsViewController:
      let destinationVC = segue.destinationViewController as! DocumentsViewController
      destinationVC.session = selectedSession
      destinationVC.documents = (selectedSession?.documents.allObjects as! [DocumentSession]).map { (documentSession) in return documentSession.document }
    case is VolunteersViewController:
      let destinationVC = segue.destinationViewController as! VolunteersViewController
      destinationVC.session = selectedSession
      destinationVC.delegate = self
      destinationVC.sessionUsers = selectedSession!.volunteers.allObjects as! [SessionUser]
    case is AssistantsViewController:
      let destinationVC = segue.destinationViewController as! AssistantsViewController
      destinationVC.sessionStudents = selectedSession!.students.allObjects as! [SessionStudent]
    case is UINavigationController :
      let navigationController = segue.destinationViewController as! UINavigationController
      if navigationController.viewControllers.first is SessionMapViewController {
        let destinationVC = navigationController.viewControllers.first as! SessionMapViewController
        destinationVC.delegate = self
        destinationVC.session = selectedSession
      } else if navigationController.viewControllers.first is CalendarViewController {
        let destinationVC = navigationController.viewControllers.first as! CalendarViewController
        destinationVC.sessions = sessions
      }
    default:
      break
    }
  }
  
}

// MARK: - UITableViewDataSource

extension SessionsViewController: UITableViewDataSource {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sessions.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(SessionsCellIdentifier, forIndexPath: indexPath) as! SessionTableViewCell
    cell.delegate = self
    cell.indexPath = indexPath
    cell.setupSession(sessions[indexPath.row])
    return cell
  }
  
}

// MARK: - UITableViewDelegate

extension SessionsViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    selectedSession = sessions[indexPath.row]
    showMenuView()
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
}

// MARK: - UIScrollViewDelegate

extension SessionsViewController: UIScrollViewDelegate {
  
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    guard refreshControl.refreshing && !refreshControl.isAnimating else {
      return
    }
    refreshControl.animateRefreshFirstStep()
  }
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    var offset = scrollView.contentOffset.y * -1
    var alpha = CGFloat(0.0)
    offset = offset - 64
    if offset > 30 {
      alpha = ((offset) / 100)
      if alpha > 100 {
        alpha = 1.0
      }
    }
    refreshControl.customView.alpha = alpha
  }
  
}

// MARK: - SessionTableViewCellDelegate

extension SessionsViewController: SessionTableViewCellDelegate {

  func sessionTableViewCell(sessionTableViewCell: SessionTableViewCell, menuButtonDidTapped button: UIButton, indexPath: NSIndexPath) {
    selectedSession = sessions[indexPath.row]
    showMenuView()
  }
  
}
