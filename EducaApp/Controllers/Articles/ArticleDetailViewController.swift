//
//  ArticleDetailViewController.swift
//  EducaApp
//
//  Created by Alonso on 9/24/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class ArticleDetailViewController: BaseViewController {
  
  @IBOutlet weak var articleImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var authorLabel: UILabel!
  @IBOutlet weak var articleTextView: UITextView!
  
  var article: Article?
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupElements()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Private
  
  private func setupElements() {
    setupInfoViews()
    setupArticle()
  }
  
  private func setupInfoViews() {
    titleLabel.textColor = UIColor.defaultTextColor()
    authorLabel.textColor = UIColor.defaultSmallTextColor()
    articleTextView.textColor = UIColor.defaultSmallTextColor()
  }
  
  private func setupArticle() {
    articleImageView.sd_setImageWithURL(NSURL(string: (article?.imageUrl)!)!, placeholderImage: UIImage(named: "DefaultBackground"))
    titleLabel.text = article!.title
    authorLabel.text = "\((article?.author.firstName)!), \((article?.postTime)!)"
  }
  
  // MARK: - Actions
  
  @IBAction func shareButtonClicked(sender: AnyObject) {
    let textToShare = article!.title
    let imageToShare = articleImageView.image as UIImage!
    if let myWebsite = NSURL(string: "https://www.facebook.com/afiperu?fref=ts") {
      let objectsToShare = [textToShare, myWebsite, imageToShare]
      let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
      
      self.presentViewController(activityVC, animated: true, completion: nil)
    }
  }
  
}
