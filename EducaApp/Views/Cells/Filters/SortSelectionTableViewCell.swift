//
//  SortSelectionTableViewCell.swift
//  EducaApp
//
//  Created by Alonso on 9/30/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class SortSelectionTableViewCell: UITableViewCell {
  
  @IBOutlet weak var sortLabel: UILabel!
  
  // MARK: - Lifecycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  // MARK: - Public
  
  func setupSortLabel(name: String) {
    sortLabel.text = name
  }
  
}
