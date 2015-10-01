//
//  DateFilterTableViewCell.swift
//  EducaApp
//
//  Created by Alonso on 9/30/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

enum DateFilterType: String {
  case From = "Desde:"
  case To = "Hasta:"
}

class DateFilterTableViewCell: UITableViewCell {
  
  @IBOutlet weak var filterLabel: UILabel!
  @IBOutlet weak var filterTextField: UITextField!
  
  // MARK: - Lifecycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  // MARK: - Public
  
  func setupLabels(filterType: String) {
    filterTextField.layer.borderColor = UIColor.defaultFilterBorderField().CGColor
    filterLabel.text = filterType
  }
  
}
