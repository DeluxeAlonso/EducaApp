//
//  PostAuthorDetailViewController.swift
//  EducaApp
//
//  Created by Alonso on 10/8/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class PostAuthorDetailViewController: UIViewController, UIPopoverPresentationControllerDelegate {
  
  let PostAuthorDetailViewNibName = "PostAuthorDetailView"
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Public
  
  func setupView() {
    self.view = NSBundle.mainBundle().loadNibNamed(PostAuthorDetailViewNibName, owner: self, options: nil).first as! UIView
  }
  
}
