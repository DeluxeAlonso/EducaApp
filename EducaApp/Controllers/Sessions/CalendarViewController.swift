//
//  CalendarViewController.swift
//  EducaApp
//
//  Created by Alonso on 10/14/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {
  
  @IBOutlet weak var monthLabel: UILabel!
  @IBOutlet weak var calendarView: CVCalendarView!
  @IBOutlet weak var calendarMenuView: CVCalendarMenuView!
  @IBOutlet weak var dateLabel: UILabel!
  
  @IBOutlet weak var sessionNameLabel: UILabel!
  
  @IBOutlet weak var sessionHourLabel: UILabel!
  @IBOutlet weak var sessionDetailView: UIView!
  @IBOutlet weak var noSessionsView: UIView!
  
  var sessions = [Session]()
  var sessionDates = [NSDate]()
  
  
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupElements()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    calendarView.commitCalendarViewUpdate()
    calendarMenuView.commitMenuViewUpdate()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Private
  
  private func setupElements() {
    calendarMenuView.setShadowBorder()
    setupNavigationBar()
    setupLabels()
    setupCalendar()
  }

  private func setupNavigationBar() {
    UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
    view.backgroundColor = UIColor.defaultBackgroundColor()
    navigationController?.navigationBar.barTintColor = UIColor.defaultTextColor()
    navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
  }
  
  private func setupLabels() {
    dateLabel?.text = calendarView.presentedDate.commonDescription
    monthLabel.text = CVDate(date: NSDate()).globalDescription
  }
  
  private func setupCalendar() {
    sessionDates = sessions.map { (session) in return session.date }
  }
  
  private func fillSessionInfo(session: Session) {
    sessionNameLabel.text = session.name
  }
  
  // MARK: - Actions
  
  @IBAction func loadPrevious(sender: AnyObject) {
    calendarView?.loadPreviousView()
  }
  
  @IBAction func loadNext(sender: AnyObject) {
    calendarView?.loadNextView()
  }
  
  @IBAction func dismissCalendarView(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
 
}

// MARK: - CVCalendarViewDelegate

extension CalendarViewController: CVCalendarViewDelegate {

  func presentationMode() -> CalendarMode {
    return .MonthView
  }
  
  func firstWeekday() -> Weekday {
    return .Sunday
  }
  
  func didSelectDayView(dayView: DayView, animationDidFinish: Bool) {
    if sessionDates.contains(dayView.date.convertedDate()!) {
      let selectedSessions = sessions.filter { (session) in return session.date == dayView.date.convertedDate()! }
      fillSessionInfo(selectedSessions.first!)
      dateLabel?.text = calendarView.presentedDate.commonDescription
      sessionNameLabel.hidden = false
      sessionDetailView.hidden = false
      noSessionsView.hidden = true
    } else {
      sessionNameLabel.hidden = true
      sessionDetailView.hidden = true
      noSessionsView.hidden = false
    }
  }
  
  func presentedDateUpdated(date: Date) {
    monthLabel?.text = date.globalDescription
  }

  func shouldAutoSelectDayOnMonthChange() -> Bool {
    return false
  }
  
  func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool {
    guard let currentDate = dayView.date else {
      return false
    }
    if sessionDates.contains(currentDate.convertedDate()!) {
      return true
    }
    return false
  }
  
  func dotMarker(colorOnDayView dayView: DayView) -> [UIColor] {
    let selectedSessions = sessions.filter { (session) in return session.date == dayView.date.convertedDate()! }
    var colors = [UIColor]()
    for _ in selectedSessions {
      colors.insert(UIColor.redColor(), atIndex: 0)
    }
    return colors
  }
  
  func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
    return 5.0
  }
  
}

// MARK: - CVCalendarViewAppearanceDelegate

extension CalendarViewController: CVCalendarViewAppearanceDelegate {
  
  func dayLabelWeekdayInTextColor() -> UIColor {
    return UIColor.defaultTextColor()
  }
  
  func dotMarker(moveOffsetOnDayView dayView: DayView) -> CGFloat {
    return 16.0
  }
  
}
