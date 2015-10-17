//
//  CalendarViewController.swift
//  EducaApp
//
//  Created by Alonso on 10/14/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
  
  @IBOutlet weak var monthLabel: UILabel!
  @IBOutlet weak var calendarView: CVCalendarView!
  @IBOutlet weak var calendarMenuView: CVCalendarMenuView!
  @IBOutlet weak var dateLabel: UILabel!
  
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
  
  // MARK: - CVCalendarViewDelegate
  
  func presentationMode() -> CalendarMode {
    return .MonthView
  }
  
  func firstWeekday() -> Weekday {
    return .Sunday
  }
  
  func didSelectDayView(dayView: CVCalendarDayView) {
    dateLabel?.text = calendarView.presentedDate.commonDescription
  }
  
  func presentedDateUpdated(date: Date) {
    monthLabel?.text = date.globalDescription
  }
  
}
