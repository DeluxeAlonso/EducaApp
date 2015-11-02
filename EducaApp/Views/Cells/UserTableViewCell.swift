//
//  UserTableViewCell.swift
//  EducaApp
//
//  Created by Alonso on 10/1/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var documentLabel: UILabel!
  @IBOutlet weak var ratingLabel: UIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func setupUser(user: User) {
    nameLabel.text = user.fullName
    var profiles = ""
    for profile in user.profiles {
      profiles += "\((profile as! Profile).name!) - "
    }
    documentLabel.text = "\(profiles)\(user.username)"
  }
  
}
