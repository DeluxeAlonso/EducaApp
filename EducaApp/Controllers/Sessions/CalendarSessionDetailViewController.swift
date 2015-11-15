//
//  CalendarSessionDetailViewController.swift
//  EducaApp
//
//  Created by Alonso on 11/10/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class CalendarSessionDetailViewController: UIViewController {
  
  @IBOutlet weak var sessionNameLabel: UILabel!
  @IBOutlet weak var sessionDateLabel: UILabel!
  @IBOutlet weak var sessionHourLabel: UILabel!
  @IBOutlet weak var sessionPlaceLabel: UILabel!
  @IBOutlet weak var indexLabel: UILabel!
  
  var sessionName: String?
  var sessionDate: String?
  var sessionHour: String?
  var sessionPlace: String?
  var index: Int?
  var total: Int?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    sessionNameLabel.text = sessionName!
    sessionDateLabel.text = sessionDate!
    sessionHourLabel.text = sessionHour!
    sessionPlaceLabel.text = sessionPlace!
    indexLabel.text = total == 1 ? "" : "\(index!) de \(total!)"
  }
  
  func setupSession(session: Session, index: Int, total: Int) {
    let date = session.date
    let dateFormatter = NSDateFormatter()
    let hourFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "dd/M/Y"
    hourFormatter.dateFormat = "HH:mm a"
    let dateString = dateFormatter.stringFromDate(date)
    let hourString = hourFormatter.stringFromDate(date)
    sessionName = session.name
    sessionPlace = session.address
    sessionDate = dateString
    sessionHour = hourString
    self.index = index + 1
    self.total = total
  }
  
}
