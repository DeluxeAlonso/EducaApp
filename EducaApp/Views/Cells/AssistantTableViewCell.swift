//
//  AssistantTableViewCell.swift
//  EducaApp
//
//  Created by Alonso on 9/22/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class AssistantTableViewCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var ageLabel: UILabel!
  @IBOutlet weak var commentedImageView: UIImageView!

  // MARK: - Lifecycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupElements()
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  // MARK: - Private
  
  private func setupElements() {
    nameLabel.textColor = UIColor.defaultTextColor()
    ageLabel.textColor = UIColor.defaultSmallTextColor()
  }
  
  // MARK: - Public
  
  func setupAssistant(name: String) {
    nameLabel.text = name
  }
  
  func setupCommentedImage() {
    commentedImageView.image = UIImage(named: "SentCommentIcon")
  }
  
}
