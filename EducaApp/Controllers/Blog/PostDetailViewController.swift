//
//  PostDetailViewController.swift
//  EducaApp
//
//  Created by Alonso on 10/1/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class PostDetailViewController: BaseViewController {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var seeCommentsButton: UIButton!
  @IBOutlet weak var authorLabel: UILabel!
  @IBOutlet weak var postTextView: UITextView!
  
  let URLToShare = "https://www.facebook.com/afiperu?fref=ts"
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupElements()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Private
  
  private func setupElements() {
    setupInfoViews()
    setupButtons()
  }
  
  private func setupInfoViews() {
    titleLabel.textColor = UIColor.defaultTextColor()
    authorLabel.textColor = UIColor.defaultSmallTextColor()
    postTextView.textColor = UIColor.defaultSmallTextColor()
  }
  
  private func setupButtons() {
    seeCommentsButton.setBorderShadow()
    seeCommentsButton.layer.borderColor = UIColor.defaultSmallTextColor().CGColor
  }
  
  // MARK: - Actions
  
  @IBAction func shareButtonClicked(sender: AnyObject) {
    if let myWebsite = NSURL(string: URLToShare) {
      let objectsToShare = [myWebsite]
      let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
      
      self.presentViewController(activityVC, animated: true, completion: nil)
    }
  }
  
}
