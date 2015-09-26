//
//  DocumentTableViewCell.swift
//  EducaApp
//
//  Created by Alonso on 9/23/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

protocol DocumentTableViewCellDelegate {
  
  func documentTableViewCell(documentTableViewCell: DocumentTableViewCell, menuButtonDidTapped button: UIButton)
  
}

class DocumentTableViewCell: UITableViewCell {
  
  @IBOutlet weak var iconImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var menuButton: UIButton!
  @IBOutlet weak var sizeLabel: UILabel!
  
  var delegate: DocumentTableViewCellDelegate?
  
  // MARK: - Lifecycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupElements()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  // MARK: - Private
  
  private func setupElements() {
    titleLabel.textColor = UIColor.defaultTextColor()
    sizeLabel.textColor = UIColor.defaultSmallTextColor()
  }
  
  // MARK: - Public
  
  func setupDocument(document: Document) {
    iconImageView.image = document.imageIcon
    titleLabel.text = document.title
    sizeLabel.text = "\(document.size!) - \(document.uploadDate!)"
  }
  
  // MARK: - Actions
  
  @IBAction func openMenu(sender: AnyObject) {
    delegate?.documentTableViewCell(self, menuButtonDidTapped: sender as! UIButton)
  }
  
}
