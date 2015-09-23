//
//  SessionCommentTableViewCell.swift
//  EducaApp
//
//  Created by Alonso on 9/23/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class SessionCommentTableViewCell: UITableViewCell {
  
  @IBOutlet weak var lastDateLabel: UILabel!
  @IBOutlet weak var volunteerNameLabel: UILabel!
  @IBOutlet weak var moodFaceImageView: UIImageView!
  
  // MARK: - Lifecycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  // MARK: - Public
  
  func setupSessionComment(comment: String) {
    volunteerNameLabel.text = comment
  }
  
}
