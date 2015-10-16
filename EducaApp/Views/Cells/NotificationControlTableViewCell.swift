//
//  NotificationControlTableViewCell.swift
//  EducaApp
//
//  Created by Alonso on 10/13/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class NotificationControlTableViewCell: UITableViewCell {
  
  @IBOutlet weak var notificationNameLabel: UILabel!
  
  // MARK: - Lifecycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  // MARK: - Public
  
  func setupNotificationControl(name: String) {
    notificationNameLabel.text = name
  }
  
}
