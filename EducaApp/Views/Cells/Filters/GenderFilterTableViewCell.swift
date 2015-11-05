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
  @IBOutlet weak var maleGenderImageView: UIImageView!
  @IBOutlet weak var femaleGenderImageView: UIImageView!
  
  var delegate: GenderFilterTableViewCellDelegate?
  
  // MARK: - Lifecycle
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  // MARK: - Actions
  
  @IBAction func pressMaleButton(sender: AnyObject) {/*
    selectedFaceIndex = SelectedMood.HappyMood
    happyMoodImageView.image = UIImage(named: ImageAssets.HappyFaceIcon)
    happyMoodImageView.layer.borderColor = UIColor.defaultHappyFaceBorderColor().CGColor
    sadMoodImageView.layer.borderColor = UIColor.defaultBorderFieldColor().CGColor
    sadMoodImageView.image = UIImage(named: ImageAssets.SadFaceGrayIcon)
    happyMoodImageView.scaleToSize(ScaleToSize, duration: ScaleDuration)
    sadMoodImageView.restoreWithDuration(ScaleDuration)*/
  }
  
  @IBAction func pressFemaleButton(sender: AnyObject) {/*
    selectedFaceIndex = SelectedMood.SadMood
    sadMoodImageView.image = UIImage(named: ImageAssets.SadFaceIcon)
    sadMoodImageView.layer.borderColor = UIColor.defaultSadFaceBorderColor().CGColor
    happyMoodImageView.image = UIImage(named: ImageAssets.HappyFaceGrayIcon)
    happyMoodImageView.layer.borderColor = UIColor.defaultBorderFieldColor().CGColor
    sadMoodImageView.scaleToSize(ScaleToSize, duration: ScaleDuration)
    happyMoodImageView.restoreWithDuration(ScaleDuration) */
  }
  
}
