//
//  SessionTableViewCell.swift
//  EducaApp
//
//  Created by Alonso on 9/20/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

protocol SessionTableViewCellDelegate {
  
  func sessionTableViewCell(sessionTableViewCell: SessionTableViewCell, menuButtonDidTapped button: UIButton, indexPath: NSIndexPath)
  
}

class SessionTableViewCell: UITableViewCell {
    
  @IBOutlet weak var menuButton: UIButton!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var placeLabel: UILabel!
  
  var delegate: SessionTableViewCellDelegate?
  
  var indexPath: NSIndexPath?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupElements()
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  // MARK: - Private
  
  private func setupElements() {
    placeLabel.textColor = UIColor.defaultTextColor()
    dateLabel.textColor = UIColor.defaultSmallTextColor()
  }
  
  // MARK: - Public
  
  func setupSession(session: Session) {
    placeLabel.text = session.name
    let date = session.date
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "dd/M/Y, HH:mm a"
    let dateString = dateFormatter.stringFromDate(date)
    dateLabel.text = dateString
  }
  
  // MARK: - Actions
  
  @IBAction func openMenu(sender: AnyObject) {
    delegate?.sessionTableViewCell(self, menuButtonDidTapped: sender as! UIButton, indexPath: indexPath!)
  }
  
}
