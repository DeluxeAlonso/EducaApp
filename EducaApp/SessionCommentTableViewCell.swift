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
    setupElements()
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  // MARK: - Private
  
  private func setupElements() {
    volunteerNameLabel.textColor = UIColor.defaultTextColor()
  }
  
  // MARK: - Public
  
  func setupSessionComment(comment: SessionComment) {
    setupMoodFace(comment)
    let longString: String = comment.fullComment
    let stringToBold = "\((comment.author)!):"
    let stringToBoldRange = (longString as NSString).rangeOfString(stringToBold)
    let attributedString = NSMutableAttributedString(string: longString, attributes: [NSFontAttributeName : UIFont.lightFontWithFontSize(15.0)])
    attributedString.setAttributes([NSFontAttributeName : UIFont.regularFontWithFontSize(15.0), NSForegroundColorAttributeName : UIColor.defaultTextColor()], range: stringToBoldRange)
    volunteerNameLabel.attributedText = attributedString
  }
  
  func setupMoodFace(comment: SessionComment) {
    switch comment.mood! {
    case 0:
      moodFaceImageView.image = nil
    case 1:
      moodFaceImageView.image = UIImage(named: "HappyFaceIcon")
    case 2:
      moodFaceImageView.image = UIImage(named: "SadFaceIcon")
    default:
      break
    }
  }
}
