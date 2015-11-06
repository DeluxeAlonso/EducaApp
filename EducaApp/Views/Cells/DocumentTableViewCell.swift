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
  
  @IBOutlet weak var progressView: UIProgressView!
  var delegate: DocumentTableViewCellDelegate?
  
  // MARK: - Lifecycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupElements()
  }
  
  // MARK: - Private
  
  private func setupElements() {
    titleLabel.textColor = UIColor.defaultTextColor()
    sizeLabel.textColor = UIColor.defaultSmallTextColor()
  }
  
  private func getDocumentImage(document: Document) -> UIImage {
    if document.url.lowercaseString.rangeOfString(".pdf") != nil {
      return UIImage(named: "PDFIcon")!
    } else if document.url.lowercaseString.rangeOfString(".xls") != nil {
      return UIImage(named: "ExcelIcon")!
    } else if document.url.lowercaseString.rangeOfString(".doc") != nil {
      return UIImage(named: "WordIcon")!
    }
    return UIImage(named: "GenericDocIcon")!
  }
  
  // MARK: - Public
  
  func setupDocument(document: Document) {
    if document.isSaved == true {
      progressView.progress = 1.0
      progressView.hidden = false
    }
    iconImageView.image = getDocumentImage(document)
    titleLabel.text = document.name
    sizeLabel.text = "\(document.size) - \(document.uploadDate)"
  }
  
  func setupProgressView(progress: Float) {
    print(progress)
    progressView.hidden = false
    progressView.progress = progress
  }
  
  // MARK: - Actions
  
  @IBAction func openMenu(sender: AnyObject) {
    delegate?.documentTableViewCell(self, menuButtonDidTapped: sender as! UIButton)
  }
  
}
