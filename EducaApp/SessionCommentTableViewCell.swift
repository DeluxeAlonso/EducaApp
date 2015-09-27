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
    let longString: String = comment.fullComment
    let stringToBold = "\((comment.author)!):"
    let stringToBoldRange = (longString as NSString).rangeOfString(stringToBold)
    let attributedString = NSMutableAttributedString(string: longString, attributes: [NSFontAttributeName : UIFont(name: "HelveticaNeue-Light", size: 15) ?? UIFont.systemFontOfSize(15.0)])
    attributedString.setAttributes([NSFontAttributeName : UIFont(name: "HelveticaNeue-Regular", size: 15) ?? UIFont.systemFontOfSize(15.0), NSForegroundColorAttributeName : UIColor.defaultTextColor()], range: stringToBoldRange)
    volunteerNameLabel.attributedText = attributedString
  }
}
