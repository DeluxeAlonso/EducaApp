//
//  AgeFilterTableViewCell.swift
//  EducaApp
//
//  Created by Alonso on 10/1/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

protocol AgeFilterTableViewCellDelegate {
  
  func ageFilterTableViewCell(ageFilterTableViewCell: AgeFilterTableViewCell, sliderValueChanged minValue: Int, maxValue: Int)
  
}

class AgeFilterTableViewCell: UITableViewCell {
  
  @IBOutlet weak var customSlider: NMRangeSlider!
  @IBOutlet weak var valueLabel: UILabel!
  
  var delegate: AgeFilterTableViewCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupElements()
    updateLabelSlider()
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
    delegate?.ageFilterTableViewCell(self, sliderValueChanged: lowerVal, maxValue: upperVal)
  }
  
  // MARK: - Actions
  
  @IBAction func labelSliderChanged(sender: AnyObject) {
    updateLabelSlider()
  }
  
}
