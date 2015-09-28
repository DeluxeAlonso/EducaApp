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

class SendAssistantCommentViewController: UIViewController {
  
  @IBOutlet weak var happyMoodImageView: UIImageView!
  @IBOutlet weak var sadMoodImageView: UIImageView!
  @IBOutlet weak var commentTextView: UITextView!
  
  let SendText = "Enviar"
  let SendMessage: Selector = "sendMessage:"
  
  var delegate: AssistantDetailViewController?
  var assistant: String?
  
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
  }
  
  private func setupButtons() {
    happyMoodImageView.layer.borderColor = UIColor.defaultBorderFieldColor().CGColor
    sadMoodImageView.layer.borderColor = UIColor.defaultBorderFieldColor().CGColor
  }
  
  private func setupTextView() {
    commentTextView.text = "Ingrese un comentario."
    commentTextView.textColor = UIColor.defaultSmallTextColor()
    commentTextView.layer.borderColor = UIColor.defaultSmallTextColor().CGColor
  }
  
  // MARK: - Actions
  
  @IBAction func sendMessage(sender: AnyObject) {
    delegate?.dismissSendCommentPopup()
  }
  
  @IBAction func pressHappyButton(sender: AnyObject) {
    selectedFaceIndex = SelectedMood.HappyMood
    happyMoodImageView.image = UIImage(named: "HappyFaceIcon")
    happyMoodImageView.layer.borderColor = UIColor.defaultHappyFaceBorderColor().CGColor
    sadMoodImageView.layer.borderColor = UIColor.defaultBorderFieldColor().CGColor
    sadMoodImageView.image = UIImage(named: "SadFaceGrayIcon")
  }
  
  @IBAction func pressSadButton(sender: AnyObject) {
    selectedFaceIndex = SelectedMood.SadMood
    sadMoodImageView.image = UIImage(named: "SadFaceIcon")
    sadMoodImageView.layer.borderColor = UIColor.defaultSadFaceBorderColor().CGColor
    happyMoodImageView.image = UIImage(named: "HappyFaceGrayIcon")
    happyMoodImageView.layer.borderColor = UIColor.defaultBorderFieldColor().CGColor
  }
  
}
