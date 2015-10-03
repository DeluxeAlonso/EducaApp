//
//  AgeFilterTableViewCell.swift
//  EducaApp
//
//  Created by Alonso on 10/1/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class AgeFilterTableViewCell: UITableViewCell {
  
  @IBOutlet weak var customSlider: NMRangeSlider!
  @IBOutlet weak var valueLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupElements()
    updateLabelSlider()
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  // MARK: - Private
  
  private func setupElements() {
    customSlider.minimumRange = 0
    customSlider.minimumValue = 1
    customSlider.maximumValue = 10
    customSlider.lowerValue = 1
    customSlider.upperValue = 10
  }
  
  private func updateLabelSlider() {
    let lowerVal = Int(customSlider.lowerValue) + 4
    let upperVal = Int(customSlider.upperValue) + 4
    valueLabel.text = "\(lowerVal) - \(upperVal)"
  }
  
  // MARK: - Actions
  
  @IBAction func labelSliderChanged(sender: AnyObject) {
    updateLabelSlider()
  }
  
}
