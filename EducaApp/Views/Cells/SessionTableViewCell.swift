//
//  SessionTableViewCell.swift
//  EducaApp
//
//  Created by Alonso on 9/20/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

protocol SessionTableViewCellDelegate {
  
  func sessionTableViewCell(sessionTableViewCell: SessionTableViewCell, menuButtonDidTapped button: UIButton)
  
}

class SessionTableViewCell: UITableViewCell {
    
  @IBOutlet weak var menuButton: UIButton!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var plaseLabel: UILabel!
  
  var delegate: SessionTableViewCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupElements()
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  // MARK: - Private
  
  private func setupElements() {
    plaseLabel.textColor = UIColor.defaultTextColor()
    dateLabel.textColor = UIColor.defaultSmallTextColor()
  }
  
  // MARK: - Actions
  
  @IBAction func openMenu(sender: AnyObject) {
    delegate?.sessionTableViewCell(self, menuButtonDidTapped: sender as! UIButton)
  }
  
}
