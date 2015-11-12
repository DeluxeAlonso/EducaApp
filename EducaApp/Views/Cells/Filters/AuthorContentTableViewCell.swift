//
//  AuthorContentTableViewCell.swift
//  EducaApp
//
//  Created by Alonso on 9/30/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

protocol AuthorContentTableViewCellDelegate {
  
  func authorContentTableViewCell(authorContentTableViewCell: AuthorContentTableViewCell, textFieldDidChange textField: UITextField, text: String, indexPath: NSIndexPath)
  
}

class AuthorContentTableViewCell: UITableViewCell {
  
  @IBOutlet weak var fieldNameLabel: UILabel!
  @IBOutlet weak var filterTextField: UITextField!
  
  let textDidChangeSeletor: Selector = "textDidChange:"
  
  var indexPath: NSIndexPath?
  var delegate: AuthorContentTableViewCellDelegate?
  var searchedName: String?
  
  // MARK - Lifecycle
  
  override func awakeFromNib() {
    super.awakeFromNib()

    setupElements()
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  // MARK: - Private
  
  private func setupElements() {
    filterTextField.addTarget(self, action: textDidChangeSeletor, forControlEvents: UIControlEvents.EditingChanged)
    filterTextField.layer.borderColor = UIColor.defaultFilterBorderField().CGColor
  }
  
  // MARK: - Public
  
  func setupNameFieldLabel(string: String, searchedName: String, indexPath: NSIndexPath) {
    fieldNameLabel.text = string
    self.indexPath = indexPath
    filterTextField.text = searchedName
  }
  
  @IBAction func textDidChange(sender: AnyObject) {
    delegate?.authorContentTableViewCell(self, textFieldDidChange: filterTextField, text: filterTextField.text!, indexPath: indexPath!)
  }
  
}
