//
//  ArticleTableViewCell.swift
//  EducaApp
//
//  Created by Alonso on 9/17/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

protocol ArticleTableViewCellDelegate {
  
  func articleTableViewCell(sessionTableViewCell: ArticleTableViewCell, starButtonDidTapped button: UIButton, favorited: Bool, indexPath: NSIndexPath)
  
}

class ArticleTableViewCell: UITableViewCell {
  
  @IBOutlet weak var articleImageView: UIImageView!
  @IBOutlet weak var articleTitle: UILabel!
  @IBOutlet weak var authorImageView: UIImageView!
  @IBOutlet weak var postTimeLabel: UILabel!
  @IBOutlet weak var authorNameLabel: UILabel!
  @IBOutlet weak var favoriteButton: UIButton!
  
  var article: Article?
  var isFavorite = false
  var indexPath: NSIndexPath?
  var delegate: ArticleTableViewCellDelegate?
  
  // MARK: - Lifecycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  // MARK: - Private
  
  func setupLabels(article: Article) {
    articleTitle.textColor = UIColor.defaultTextColor()
    articleTitle.text = article.title
    postTimeLabel.textColor = UIColor.defaultSmallTextColor()
    postTimeLabel.text = article.postTime
    authorNameLabel.textColor = UIColor.defaultSmallTextColor()
    authorNameLabel.text = article.author.firstName
  }
  
  func setupButtons(article: Article) {
    if article.favoritedByCurrentUser == true {
      isFavorite = true
      favoriteButton.setImage(UIImage(named: "StarFilled"), forState: UIControlState.Normal)
    } else {
      isFavorite = false
      favoriteButton.setImage(UIImage(named: "StarGray"), forState: UIControlState.Normal)
    }
  }
  
  func setupImageViews(article: Article) {
    articleImageView.sd_setImageWithURL(NSURL(string: (article.imageUrl))!, placeholderImage: UIImage(named: "DefaultBackground"))
    authorImageView.sd_setImageWithURL(NSURL(string: (article.author.imageProfileUrl))!, placeholderImage: UIImage(named: "AfiLogo"))
  }
  
  // MARK: - Public
  
  func setupArticle(article: Article, indexPath: NSIndexPath) {
    self.indexPath = indexPath
    setupLabels(article)
    setupButtons(article)
    setupImageViews(article)
  }
  
  // MARK: - Actions
  
  @IBAction func setFavorite(sender: AnyObject) {
    let transition: CATransition = CATransition()
    transition.duration = 0.25
    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    transition.type = kCATransitionFade
    if !isFavorite {
      isFavorite = true
      favoriteButton.setImage(UIImage(named: "StarFilled"), forState: UIControlState.Normal)
      favoriteButton.layer.addAnimation(transition, forKey: nil)
      delegate?.articleTableViewCell(self, starButtonDidTapped: favoriteButton, favorited: true, indexPath: indexPath!)
    } else {
      isFavorite = false
      favoriteButton.setImage(UIImage(named: "StarGray"), forState: UIControlState.Normal)
      favoriteButton.layer.addAnimation(transition, forKey: nil)
      delegate?.articleTableViewCell(self, starButtonDidTapped: favoriteButton, favorited: false, indexPath: indexPath!)
    }
  }
  
  
}
