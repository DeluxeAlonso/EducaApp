//
//  VolunteerTableViewCell.swift
//  EducaApp
//
//  Created by Alonso on 9/22/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class VolunteerTableViewCell: UITableViewCell {
  
  @IBOutlet weak var volunteerImageView: UIImageView!
  @IBOutlet weak var volunteerNameLabel: UILabel!
  
  @IBOutlet weak var volunteerMarkImageView: UIImageView!
  
  // MARK: - Lifecycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  // MARK: - Public
  
  func setupVolunteer(name: String) {
    volunteerNameLabel.text = name
  }
  
  func setupVolunteerWithImage(imageName: String, animated: Bool) {
    volunteerMarkImageView.image = UIImage(named: imageName)
    if animated {
      let transition: CATransition = CATransition()
      transition.duration = 0.25
      transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
      transition.type = kCATransitionFade
      volunteerMarkImageView.layer.addAnimation(transition, forKey: nil)
    }
  }
  
}
