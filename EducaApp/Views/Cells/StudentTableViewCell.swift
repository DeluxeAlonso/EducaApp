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
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func setupStudent(student: Student) {
    nameLabel.text = student.name
    ageLabel.text = "Edad: \((student.age)!)"
    if student.gender == 0 {
      genderImageView.image = UIImage(named: "MaleGenderIcon")
    } else {
      genderImageView.image = UIImage(named: "FemaleGenderIcon")
    }
  }
  
}
