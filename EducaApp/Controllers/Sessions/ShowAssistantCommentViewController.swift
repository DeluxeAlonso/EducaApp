//
//  ShowAssistantCommentViewController.swift
//  EducaApp
//
//  Created by Alonso on 9/26/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class ShowAssistantCommentViewController: UIViewController {
  
  @IBOutlet weak var commentLabel: UILabel!
  
  let ShowAssistantCommentViewIdentifier = "ShowAssistantCommentView"
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Public
  
  func setupView(comment: SessionComment) {
    self.view = NSBundle.mainBundle().loadNibNamed(ShowAssistantCommentViewIdentifier, owner: self, options: nil).first as! SessionCommentView
    let longString: String = comment.fullComment
    let stringToBold = "\((comment.author)!):"
    let stringToBoldRange = (longString as NSString).rangeOfString(stringToBold)
    let attributedString = NSMutableAttributedString(string: longString, attributes: [NSFontAttributeName : UIFont.lightFontWithFontSize(17)])
    attributedString.setAttributes([NSFontAttributeName : UIFont.regularFontWithFontSize(17), NSForegroundColorAttributeName : UIColor.defaultTextColor()], range: stringToBoldRange)
    (self.view as! SessionCommentView).commentLabel.attributedText = attributedString
  }
  
}
