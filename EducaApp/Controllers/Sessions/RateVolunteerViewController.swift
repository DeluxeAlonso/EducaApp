//
//  RateVolunteerViewController.swift
//  EducaApp
//
//  Created by Alonso on 10/8/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

protocol RateVolunteerViewControllerDelegate {
  
  func rateVolunteerViewController(rateVolunteerViewController: RateVolunteerViewController, rating: Int, comment: String, indexPath: NSIndexPath)
  
}

class RateVolunteerViewController: UIViewController {
  
  @IBOutlet weak var commentTextView: UITextView!
  @IBOutlet weak var rateStarsView: CustomRatingView!
  
  let sendRatingSelector: Selector = "sendRating:"
  
  let RateButtonText = "Enviar"
  
  var indexPath: NSIndexPath?
  var sessionUser: SessionUser?
  var delegate: RateVolunteerViewControllerDelegate?
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupElements()
  }
  
  // MARK: - Private
  
  private func setupElements() {
    self.contentSizeInPopup = CGSizeMake(300, 170)
    setupNavigationBar()
    setupTextView()
    setupInputFields()
  }
  
  private func setupNavigationBar() {
    self.title = sessionUser?.user.firstName
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: RateButtonText, style: UIBarButtonItemStyle.Plain, target: self, action: sendRatingSelector)
  }
  
  private func setupTextView() {
    commentTextView.text = "Ingrese un comentario."
    commentTextView.textColor = UIColor.defaultSmallTextColor()
    commentTextView.layer.borderColor = UIColor.defaultSmallTextColor().CGColor
  }
  
  private func setupInputFields() {
    guard let session = sessionUser else {
      return
    }
    rateStarsView.rating = Double(session.rating)
    commentTextView.text = session.comment
  }
  
  // MARK: - Actions
  
  @IBAction func sendRating(sender: AnyObject) {
    delegate?.rateVolunteerViewController(self, rating: Int(rateStarsView.rating), comment: commentTextView.text, indexPath: indexPath!)
  }
  
}
