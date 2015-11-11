//
//  CalendarPageViewController.swift
//  EducaApp
//
//  Created by Alonso on 11/10/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class CalendarPageViewController: UIPageViewController {
  
  let CalendarSessionDetailViewControllerIdentifier = "CalendarSessionDetailViewController"
  
  var pages = NSMutableArray()
  
  var currentPageIndex = 0
  var nextPageIndex: Int?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    delegate = self
    dataSource = self
  }
  
  // MARK: - Private
  
  private func viewControllerAtIndex(index: Int) -> UIViewController? {
    currentPageIndex = index
    return pages[index] as? UIViewController
  }

  // MARK: - Public
  
  func setupPageViewController(sessions: [Session]) {
    pages = NSMutableArray()
    let orderedSessions = sessions.sort({ $0.date.compare($1.date) == NSComparisonResult.OrderedAscending })
    for session in orderedSessions {
      let sessionPage = self.storyboard?.instantiateViewControllerWithIdentifier(CalendarSessionDetailViewControllerIdentifier) as! CalendarSessionDetailViewController
      sessionPage.setupSession(session, index: orderedSessions.indexOf(session)!,total:  orderedSessions.count)
      pages.addObject(sessionPage)
    }
    setViewControllers([pages.firstObject as! UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)

  }
  
}

// MARK: - UIPageViewControllerDataSource

extension CalendarPageViewController: UIPageViewControllerDataSource {
  
  func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
    var currentIndex = pages.indexOfObject(viewController)
    if currentIndex > 0 {
      currentIndex = (currentIndex - 1) % (pages.count)
      return pages.objectAtIndex(currentIndex) as? UIViewController
    } else{
      return nil
    }
  }

  func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    var currentIndex = pages.indexOfObject(viewController)
    if currentIndex < pages.count - 1 {
      currentIndex = (currentIndex + 1) % (pages.count)
      return pages.objectAtIndex(currentIndex) as? UIViewController
    } else{
      return nil
    }
  }
  
}

// MARK: - UIPageViewControllerDelegate

extension CalendarPageViewController: UIPageViewControllerDelegate {
  
  func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
    guard let controller  = pendingViewControllers.first else {
      return
    }
    nextPageIndex = pages.indexOfObject(controller)
  }
  
  func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    completed ? (currentPageIndex = nextPageIndex!) : (nextPageIndex = 0)
  }
  
  func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
    return pages.count
  }
  
  func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
    return currentPageIndex
  }
  
}
