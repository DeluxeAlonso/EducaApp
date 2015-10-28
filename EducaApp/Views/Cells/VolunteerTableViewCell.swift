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
    setupElements()
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  // MARK: - Private
  
  private func setupElements() {
    volunteerNameLabel.textColor = UIColor.defaultTextColor()
  }
  
  // MARK: - Public
  
  func setupVolunteer(volunteer: User) {
    volunteerNameLabel.text = volunteer.firstName
  }
  
  func setupVolunteerWithImage(imageName: String, animated: Bool) {
    volunteerMarkImageView.image = UIImage(named: imageName)
    guard animated else {
      return
    }
    let transition: CATransition = CATransition()
    transition.duration = 0.25
    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    transition.type = kCATransitionFade
    volunteerMarkImageView.layer.addAnimation(transition, forKey: nil)
  }
  
}
