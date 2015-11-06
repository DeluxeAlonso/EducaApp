//
//  SendAssistantCommentViewController.swift
//  EducaApp
//
//  Created by Alonso on 9/27/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

enum SelectedMood: Int {
  case None
  case HappyMood
  case SadMood
}

protocol SendAssistantCommentViewControllerDelegate {
  
  func sendAssistantCommentViewController(sendAssistantCommentViewController: SendAssistantCommentViewController, comment: String, face: Int)
  
}

class SendAssistantCommentViewController: UIViewController {
  
  @IBOutlet weak var happyMoodImageView: UIImageView!
  @IBOutlet weak var sadMoodImageView: UIImageView!
  @IBOutlet weak var commentTextView: UITextView!
  
  let SendText = "Enviar"
  let SendMessage: Selector = "sendMessage:"
  
  let ScaleToSize: CGFloat = 1.15
  let ScaleDuration: NSTimeInterval = 0.5
  
  var delegate: SendAssistantCommentViewControllerDelegate?
  var assistant: String?
  
  var currentComment: Comment?
  
  var comment = String()
  var selectedFaceIndex = SelectedMood.None
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    setupElements()
    self.contentSizeInPopup = CGSizeMake(300, 170)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Private
  
  private func setupNavigationBar() {
    self.title = assistant
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: SendText, style: UIBarButtonItemStyle.Plain, target: self, action: SendMessage)
  }
  
  private func setupElements() {
    setupButtons()
    setupTextView()
    if currentComment != nil {
      setupFields()
    }
  }
  
  private func setupButtons() {
    happyMoodImageView.layer.borderColor = UIColor.defaultBorderFieldColor().CGColor
    sadMoodImageView.layer.borderColor = UIColor.defaultBorderFieldColor().CGColor
  }
  
  private func setupTextView() {
    commentTextView.text = ""
    commentTextView.textColor = UIColor.defaultSmallTextColor()
    commentTextView.layer.borderColor = UIColor.defaultSmallTextColor().CGColor
  }
  
  private func setupFields() {
    commentTextView.text = currentComment?.message
    if currentComment?.face == 1 {
      pressHappyButton(NSNull)
    } else if currentComment?.face == -1 {
      pressSadButton(NSNull)
    }
  }
  
  // MARK: - Actions
  
  @IBAction func sendMessage(sender: AnyObject) {
    var face = selectedFaceIndex.hashValue
    comment = commentTextView.text
    if selectedFaceIndex == SelectedMood.SadMood {
      face = -1
    }
    delegate?.sendAssistantCommentViewController(self, comment: comment, face: face)
  }
  
  @IBAction func pressHappyButton(sender: AnyObject) {
    selectedFaceIndex = SelectedMood.HappyMood
    happyMoodImageView.image = UIImage(named: ImageAssets.HappyFaceIcon)
    happyMoodImageView.layer.borderColor = UIColor.defaultHappyFaceBorderColor().CGColor
    sadMoodImageView.layer.borderColor = UIColor.defaultBorderFieldColor().CGColor
    sadMoodImageView.image = UIImage(named: ImageAssets.SadFaceGrayIcon)
    happyMoodImageView.scaleToSize(ScaleToSize, duration: ScaleDuration)
    sadMoodImageView.restoreWithDuration(ScaleDuration)
  }

  @IBAction func pressSadButton(sender: AnyObject) {
    selectedFaceIndex = SelectedMood.SadMood
    sadMoodImageView.image = UIImage(named: ImageAssets.SadFaceIcon)
    sadMoodImageView.layer.borderColor = UIColor.defaultSadFaceBorderColor().CGColor
    happyMoodImageView.image = UIImage(named: ImageAssets.HappyFaceGrayIcon)
    happyMoodImageView.layer.borderColor = UIColor.defaultBorderFieldColor().CGColor
    sadMoodImageView.scaleToSize(ScaleToSize, duration: ScaleDuration)
    happyMoodImageView.restoreWithDuration(ScaleDuration)
  }
  
}
