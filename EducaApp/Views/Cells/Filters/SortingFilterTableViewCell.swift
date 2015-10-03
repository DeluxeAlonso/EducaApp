//
//  SortingFilterTableViewCell.swift
//  EducaApp
//
//  Created by Alonso on 9/30/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class SortingFilterTableViewCell: UITableViewCell {
  
  @IBOutlet weak var fieldNameLabel: UILabel!
  @IBOutlet weak var sortingTypeLabel: UILabel!
  
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
    sortingTypeLabel.textColor = UIColor.defaultFilterBorderField()
  }
  
  // MARK: - Public
  
  func setupFieldNameLabel(fieldName: String, fieldType: String) {
    fieldNameLabel.text = fieldName
    sortingTypeLabel.text = fieldType
  }
  
}
