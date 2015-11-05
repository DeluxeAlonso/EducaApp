//
//  DocumentUsersTableViewCell.swift
//  EducaApp
//
//  Created by Alonso on 11/3/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class DocumentUsersTableViewCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var documentLabel: UILabel!
  @IBOutlet weak var seenImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  // MARK: - Public
  
  func setupDocumentUser(documentUser: DocumentUser) {
    nameLabel.text = documentUser.user.fullName
    documentLabel.text = documentUser.user.username
    seenImageView.image = documentUser.seen == true ? UIImage(named: ImageAssets.CheckIcon) : UIImage(named: ImageAssets.UncheckIcon)
  }
  
}
