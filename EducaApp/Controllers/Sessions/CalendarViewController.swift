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
  
  @IBOutlet weak var noSessionsView: UIView!
  @IBOutlet weak var noSessionsLabel: UILabel!
  
  var sessions = [Session]()
  var sessionDates = [Int]()
  var sessionInfoPageViewController: CalendarPageViewController?
  
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
    noSessionsView.setShadowBorder()
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
    monthLabel.text = Util.getDateString(NSDate(), format: "MMMM, Y")
  }
  
  private func setupCalendar() {
    sessionDates = sessions.map { (session) in return session.date.getNumberOfDays() }
    let currentDate = NSDate()
    if sessionDates.contains((NSDate().getNumberOfDays())) {
      let selectedSessions = sessions.filter { (session) in return session.date.getNumberOfDays() == currentDate.getNumberOfDays() }
      fillSessionInfo(selectedSessions)
      calendarMenuView.hidden = false
      noSessionsView.hidden = true
    } else {
      calendarMenuView.hidden = true
      noSessionsView.hidden = false
      noSessionsLabel.text = "No tienes sesiones el día de hoy."
    }
  }
  
  private func fillSessionInfo(sessions: [Session]) {
    sessionInfoPageViewController?.setupPageViewController(sessions)
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
  
  // MARK: - Navigation
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.destinationViewController is CalendarPageViewController {
      sessionInfoPageViewController = segue.destinationViewController as? CalendarPageViewController
    }
  }
 
}

// MARK: - CVCalendarViewDelegate

extension CalendarViewController: CVCalendarViewDelegate {

  func presentationMode() -> CalendarMode {
    return .MonthView
  }
  
  func firstWeekday() -> Weekday {
    return .Monday
  }
  
  func didSelectDayView(dayView: DayView, animationDidFinish: Bool) {
    if sessionDates.contains((dayView.date.convertedDate()?.getNumberOfDays())!) {
      let selectedSessions = sessions.filter { (session) in return session.date.getNumberOfDays() == dayView.date.convertedDate()?.getNumberOfDays() }
      fillSessionInfo(selectedSessions)
      calendarMenuView.hidden = false
      noSessionsView.hidden = true
    } else {
      calendarMenuView.hidden = true
      noSessionsView.hidden = false
      noSessionsLabel.text = "No tienes sesiones para el día \(Util.getDateString(dayView.date.convertedDate()!, format: "dd' de 'MMMM"))."
    }
  }
  
  func presentedDateUpdated(date: Date) {
    monthLabel.text = Util.getDateString(date.convertedDate()!, format: "MMMM, Y")
  }

  func shouldAutoSelectDayOnMonthChange() -> Bool {
    return false
  }
  
  func shouldShowWeekdaysOut() -> Bool {
    return false
  }
  
  func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool {
    guard let currentDate = dayView.date else {
      return false
    }
    if sessionDates.contains((currentDate.convertedDate()?.getNumberOfDays())!) {
      return true
    }
    return false
  }
  
  func dotMarker(colorOnDayView dayView: DayView) -> [UIColor] {
    let selectedSessions = sessions.filter { (session) in return session.date.getNumberOfDays() == dayView.date.convertedDate()?.getNumberOfDays() }
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
