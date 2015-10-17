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
  
  let FavoriteButtonTransitionDuration = 0.25
  
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
  
  private func setupLabels(article: Article) {
    articleTitle.textColor = UIColor.defaultTextColor()
    articleTitle.text = article.title
    postTimeLabel.textColor = UIColor.defaultSmallTextColor()
    postTimeLabel.text = article.postTime
    authorNameLabel.textColor = UIColor.defaultSmallTextColor()
    authorNameLabel.text = article.author.firstName
  }
  
  private func setupButtons(article: Article) {
    article.favoritedByCurrentUser ? setupStarImage(ImageAssets.StarFilled, favorited: true) : setupStarImage(ImageAssets.StarGray, favorited: false)
  }
  
  private func setupImageViews(article: Article) {
    articleImageView.sd_setImageWithURL(NSURL(string: (article.imageUrl))!, placeholderImage: UIImage(named: ImageAssets.DefaultBackground))
    authorImageView.sd_setImageWithURL(NSURL(string: (article.author.imageProfileUrl))!, placeholderImage: UIImage(named: ImageAssets.AfiLogo))
  }
  
  private func setupStarImage(imageName: String, favorited: Bool) {
    isFavorite = favorited
    favoriteButton.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
  }
  
  private func animateFavoriteSelection(favorited favorited: Bool) {
    favorited ? setupStarImage(ImageAssets.StarFilled, favorited: favorited) : setupStarImage(ImageAssets.StarGray, favorited: selected)
    favoriteButton.layer.addAnimation(Util.fadeTransitionWithDuration(FavoriteButtonTransitionDuration), forKey: nil)
    delegate?.articleTableViewCell(self, starButtonDidTapped: favoriteButton, favorited: favorited, indexPath: indexPath!)
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
    isFavorite ? animateFavoriteSelection(favorited: false) : animateFavoriteSelection(favorited: true)
  }
  
}
