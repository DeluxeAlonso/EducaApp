//
//  ArticleTableViewCell.swift
//  EducaApp
//
//  Created by Alonso on 9/17/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
  
  @IBOutlet weak var articleImageView: UIImageView!
  @IBOutlet weak var articleTitle: UILabel!
  @IBOutlet weak var authorImageView: UIImageView!
  @IBOutlet weak var postTimeLabel: UILabel!
  @IBOutlet weak var authorNameLabel: UILabel!
  
  var article: Article?
  
  // MARK: - Lifecycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  // MARK: - Public
  
  func setupElements() {
    setupLabels()
    setupImages()
  }
  
  func setupLabels() {
    print(article?.author.firstName)
    articleTitle.text = article?.title
    postTimeLabel.text = article?.postTime
    authorNameLabel.text = article?.author.firstName
  }

  func setupImages() {
    articleImageView.sd_setImageWithURL(NSURL(string: (article?.imageUrl)!)!, placeholderImage: UIImage(named: "DefaultBackground"))
    authorImageView.sd_setImageWithURL(NSURL(string: (article?.author.imageProfileUrl)!)!, placeholderImage: UIImage(named: "AfiLogo"))
  }
  
}
