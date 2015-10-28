//
//  StudentTableViewCell.swift
//  EducaApp
//
//  Created by Alonso on 10/1/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class StudentTableViewCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var ageLabel: UILabel!
  @IBOutlet weak var genderImageView: UIImageView!
  
  let AgeLabelText = "Edad:"
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func setupStudent(student: Student) {
    nameLabel.text = student.fullName
    ageLabel.text = "\(AgeLabelText) \((student.age))"
    genderImageView.image = student.gender == 0 ? UIImage(named: ImageAssets.MaleGenderIcon) : UIImage(named: ImageAssets.FemaleGenderIcon)
  }
  
}
