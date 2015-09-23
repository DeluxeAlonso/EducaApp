//
//  AssistantCommentViewController.swift
//  EducaApp
//
//  Created by Alonso on 9/22/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

enum SelectedMood: Int {
  case None
  case HappyMood
  case SadMood
}

class AssistantCommentViewController: UIViewController {

  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var happyFaceButton: UIButton!
  @IBOutlet weak var sadFaceButton: UIButton!
  @IBOutlet weak var commentTextView: UITextView!
  @IBOutlet weak var submitButton: UIButton!
  
  var assistant: String?
  var comment: SessionComment?
  var isKeyboardVisible = false
  var delegate: UIViewController?
  var selectedFaceIndex = SelectedMood.None
  
  // MARK: - Lifecycle
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil);
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil);
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupElements()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Private
  
  private func setupElements() {
    title = assistant
    setupObservers()
    setupButtons()
    setupTextView()
  }
  
  private func setupObservers() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
  }
  
  private func setupButtons() {
    happyFaceButton.layer.borderColor = UIColor.defaultBorderFieldColor().CGColor
    sadFaceButton.layer.borderColor = UIColor.defaultBorderFieldColor().CGColor
    if comment != nil {
      pressHappyButton(NSNull)
      happyFaceButton.userInteractionEnabled = false
      sadFaceButton.userInteractionEnabled = false
      submitButton.userInteractionEnabled = false
      submitButton.setTitle("Escrito por \((comment!.author)!).", forState: UIControlState.Normal)
    }
  }
  
  private func setupTextView() {
    if comment != nil {
      commentTextView.userInteractionEnabled = false
    }
    commentTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
  }
  
  // MARK: - Actions
  
  @IBAction func closeModal(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func pressHappyButton(sender: AnyObject) {
    selectedFaceIndex = SelectedMood.HappyMood
    happyFaceButton.setImage(UIImage(named: "HappyFaceIcon"), forState: UIControlState.Normal)
    happyFaceButton.layer.borderColor = UIColor.defaultHappyFaceBorderColor().CGColor
    sadFaceButton.layer.borderColor = UIColor.defaultBorderFieldColor().CGColor
    sadFaceButton.setImage(UIImage(named: "SadFaceGrayIcon"), forState: UIControlState.Normal)
  }

  @IBAction func pressSadButton(sender: AnyObject) {
    selectedFaceIndex = SelectedMood.SadMood
    sadFaceButton.setImage(UIImage(named: "SadFaceIcon"), forState: UIControlState.Normal)
    sadFaceButton.layer.borderColor = UIColor.defaultSadFaceBorderColor().CGColor
    happyFaceButton.setImage(UIImage(named: "HappyFaceGrayIcon"), forState: UIControlState.Normal)
    happyFaceButton.layer.borderColor = UIColor.defaultBorderFieldColor().CGColor
  }
  
  @IBAction func sendComment(sender: AnyObject) {
    guard let viewController = delegate as? AssistantsViewController else {
      self.dismissViewControllerAnimated(true, completion: nil)
      return
    }
    viewController.checkCommentedAssistant()
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  // MARK: - Notifications
  
  func keyboardWillShow(notification: NSNotification) {
    guard !isKeyboardVisible else {
      return
    }
    isKeyboardVisible = true
    var contentInset = scrollView.contentInset 
    var scrollIndicatorInset = scrollView.scrollIndicatorInsets
    if let keyboardFrame: CGRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
      let bottomInset = keyboardFrame.size.height
      contentInset.bottom = bottomInset
      scrollIndicatorInset.bottom = bottomInset
      scrollView.contentInset = contentInset
      scrollView.scrollIndicatorInsets = scrollIndicatorInset
    }
  }
  
  func keyboardWillHide(notification: NSNotification) {
    guard isKeyboardVisible else {
      return
    }
    isKeyboardVisible = false
    var inset = scrollView.contentInset
    inset.top = topLayoutGuide.length
    inset.bottom = bottomLayoutGuide.length
    scrollView.contentInset = inset
    scrollView.scrollIndicatorInsets = inset
  }

}
