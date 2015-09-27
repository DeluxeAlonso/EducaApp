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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Public
  
  func setupView(comment: SessionComment) {
    self.view = NSBundle.mainBundle().loadNibNamed("ShowAssistantCommentView", owner: self, options: nil).first as! SessionCommentView
    let longString: String = comment.fullComment
    let stringToBold = "\((comment.author)!):"
    let stringToBoldRange = (longString as NSString).rangeOfString(stringToBold)
    let attributedString = NSMutableAttributedString(string: longString, attributes: [NSFontAttributeName : UIFont(name: "HelveticaNeue-Light", size: 17) ?? UIFont.systemFontOfSize(17.0)])
    attributedString.setAttributes([NSFontAttributeName : UIFont(name: "HelveticaNeue", size: 17) ?? UIFont.systemFontOfSize(17.0), NSForegroundColorAttributeName : UIColor.defaultTextColor()], range: stringToBoldRange)
    (self.view as! SessionCommentView).commentLabel.attributedText = attributedString
  }
  
}
