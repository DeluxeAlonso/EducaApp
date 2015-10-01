//
//  AuthorContentTableViewCell.swift
//  EducaApp
//
//  Created by Alonso on 9/30/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class AuthorContentTableViewCell: UITableViewCell {
  
  @IBOutlet weak var filterTextField: UITextField!
  
  // MARK - Lifecycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupElements()
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  // MARK: - Private
  
  private func setupElements() {
    filterTextField.layer.borderColor = UIColor.defaultFilterBorderField().CGColor
  }
  
}
