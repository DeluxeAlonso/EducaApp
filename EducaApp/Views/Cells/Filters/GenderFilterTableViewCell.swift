//
//  GenderFilterTableViewCell.swift
//  EducaApp
//
//  Created by Alonso on 11/2/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

protocol GenderFilterTableViewCellDelegate {
  
  func genderFilterTableViewCell(ageFilterTableViewCell: GenderFilterTableViewCell, selectedIndex: Int)
  
}

class GenderFilterTableViewCell: UITableViewCell {
  
  @IBOutlet weak var maleGenderButton: UIButton!
  
  @IBOutlet weak var femaleGenderButton: UIButton!
  
  
  var delegate: GenderFilterTableViewCellDelegate?
  
  // MARK: - Lifecycle
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  // MARK: - Actions
  
  @IBAction func pressMaleButton(sender: AnyObject) {
    maleGenderButton.setImage(UIImage(named: ImageAssets.MaleGenderIcon), forState: UIControlState.Normal)
    femaleGenderButton.setImage(UIImage(named: "FemaleGrayIcon"), forState: UIControlState.Normal)
    delegate?.genderFilterTableViewCell(self, selectedIndex: 0)
  }
  
  @IBAction func pressFemaleButton(sender: AnyObject) {
    maleGenderButton.setImage(UIImage(named: "GrayMaleIcon"), forState: UIControlState.Normal)
    femaleGenderButton.setImage(UIImage(named: ImageAssets.FemaleGenderIcon), forState: UIControlState.Normal)
    delegate?.genderFilterTableViewCell(self, selectedIndex: 1)
  }
  
}
