//
//  RateVolunteerViewController.swift
//  EducaApp
//
//  Created by Alonso on 10/8/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class RateVolunteerViewController: UIViewController {
  
  @IBOutlet weak var commentTextView: UITextView!
  @IBOutlet weak var rateStarsView: CosmosView!
  
  let RateButtonText = "Enviar"
  
  var volunteer: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupElements()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  private func setupElements() {
    self.contentSizeInPopup = CGSizeMake(300, 170)
    setupNavigationBar()
    setupTextView()
  }
  
  private func setupNavigationBar() {
    self.title = volunteer
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: RateButtonText, style: UIBarButtonItemStyle.Plain, target: self, action: nil)
  }
  
  private func setupTextView() {
    commentTextView.text = "Ingrese un comentario."
    commentTextView.textColor = UIColor.defaultSmallTextColor()
    commentTextView.layer.borderColor = UIColor.defaultSmallTextColor().CGColor
  }
  
}
