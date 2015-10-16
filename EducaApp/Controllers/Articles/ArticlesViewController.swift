//
//  ArticlesViewController.swift
//  EducaApp
//
//  Created by Alonso on 9/1/15.
//  Copyright (c) 2015 Alonso. All rights reserved.
//

import UIKit

let kArticlesCellIdentifier = "ArticleCell"
let kGoToArticleDetailSegueIdentifier = "GoToArticleDetailSegue"

class ArticlesViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, ArticleTableViewCellDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var customLoader: CustomActivityIndicatorView!
  @IBOutlet weak var favoritesSegmentedControl: UISegmentedControl!
  
  var articles = [Article]()
  var allArticles = [Article]()

  var customView: UIView!
  var labelsArray: Array<UILabel> = []
  
  var isRefreshing = false
  let refreshControl = CustomRefreshControlView()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupElements()
    setupArticles()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.layer.removeAllAnimations()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Private
  
  private func setupElements() {
    setupTableView()
  }
  
  private func setupTableView() {
    self.tableView.estimatedRowHeight = 243
    self.tableView.rowHeight = UITableViewAutomaticDimension
    tableView.addSubview(refreshControl)
    refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
  }
  
  private func setupArticles() {
    articles = Article.getAllArticles(self.dataLayer.managedObjectContext!)
    if articles.count == 0 {
      self.tableView.hidden = true
      customLoader.startActivity()
      getArticles()
    }
  }
  
  private func getArticles() {
    ArticleService.fetchArticles({(responseObject: AnyObject?, error: NSError?) in
      self.refreshControl.endRefreshing()
      self.isRefreshing = false
      let json = responseObject
      if (json != nil && json?["error"] == nil) {
        let syncedArticles = Article.syncWithJsonArray(json as! Array<NSDictionary>, ctx: self.dataLayer.managedObjectContext!)
        self.articles = syncedArticles
        self.dataLayer.saveContext()
        self.reloadData()
      } else {
        //Show Error Message
      }
    })
  }
  
  private func showAllArticles() {
    tableView.addSubview(refreshControl)
    articles = Article.getAllArticles(self.dataLayer.managedObjectContext!)
    tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
  }
  
  private func showAllFavoriteArticles() {
    refreshControl.endRefreshing()
    refreshControl.removeFromSuperview()
    let favorites = articles.filter { (article) in article.favoritedByCurrentUser == true }
    self.articles = favorites
    //tableView.reloadData()
    tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
  }
  
  // MARK: - Public
  
  func refreshData() {
    isRefreshing = true
    Util.delay(2.0) {
      self.getArticles()
    }
  }
  
  func reloadData() {
    Util.delay(0.5) {
      if !self.isRefreshing {
        self.customLoader.stopActivity()
        self.tableView.hidden = false
        self.tableView.reloadData()
      }
    }
  }
  
  // MARK: - Actions
  
  @IBAction func segmentedControlIndexChanged(sender: AnyObject) {
    switch favoritesSegmentedControl.selectedSegmentIndex {
    case 0:
      showAllArticles()
      break
    default:
      showAllFavoriteArticles()
      break
    }
  }
  
  // MARK: - Navigation
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.destinationViewController is ArticleDetailViewController {
      let destinationVC = segue.destinationViewController as! ArticleDetailViewController
      destinationVC.article = sender as? Article
    }
  }
  
  // MARK: - UITableViewDataSource
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return articles.count
  }
  
  func tableView(tableView: UITableView,
    cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier(kArticlesCellIdentifier, forIndexPath: indexPath) as! ArticleTableViewCell
      cell.delegate = self
      cell.setupArticle(articles[indexPath.row], indexPath: indexPath)
      return cell
  }
  
  // MARK: - UITableViewDelegate
  
  func tableView(tableView: UITableView,
    didSelectRowAtIndexPath indexPath: NSIndexPath) {
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
      self.performSegueWithIdentifier(kGoToArticleDetailSegueIdentifier, sender: articles[indexPath.row])
  }
  
  // MARK: - UIScrollViewDelegate
  
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    if refreshControl.refreshing {
      if !refreshControl.isAnimating {
        refreshControl.animateRefreshFirstStep()
      }
    }
  }
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    let offset = scrollView.contentOffset.y * -1
    var alpha = CGFloat(0.0)
    if offset > 30 {
      alpha = ((offset) / 100)
      if alpha > 100 {
        alpha = 1.0
      }
    }
    refreshControl.customView.alpha = alpha
  }
  
  // MARK: - ArticleTableViewCellDelegate
  
  func articleTableViewCell(sessionTableViewCell: ArticleTableViewCell, starButtonDidTapped button: UIButton, favorited: Bool, indexPath: NSIndexPath) {
    print(favorited)
    currentUser!.updateFavoriteArticle(articles[indexPath.row], favorited: favorited, ctx: dataLayer.managedObjectContext!)
    self.dataLayer.saveContext()
  }
  
}
