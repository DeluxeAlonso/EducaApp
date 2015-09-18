//
//  ArticlesViewController.swift
//  EducaApp
//
//  Created by Alonso on 9/1/15.
//  Copyright (c) 2015 Alonso. All rights reserved.
//

import UIKit

let kBarButtonSelector: Selector = "revealToggle:"
let kArticlesCellIdentifier = "ArticleCell"

class ArticlesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var menuIcon: UIBarButtonItem!
  @IBOutlet weak var customLoader: CustomActivityIndicatorView!
  
  lazy var dataLayer = DataLayer()
  var articles = [Article]()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupElements()
    articles = Article.getAllArticles(self.dataLayer.managedObjectContext!)
    if articles.count == 0 {
      self.tableView.hidden = true
      customLoader.startActivity()
      getArticles()
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.layer.removeAllAnimations()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Private
  
  private func setupElements() {
    self.tableView.estimatedRowHeight = 243;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    setupBarButtonItem()
  }
  
  private func setupBarButtonItem() {
    if self.revealViewController() != nil {
      self.menuIcon.target = self.revealViewController()
      self.menuIcon.action = kBarButtonSelector
      self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
  }
  
  private func getArticles() {
    ArticleService.fetchArticles({(responseObject: AnyObject?, error: NSError?) in
      print(responseObject)
      self.customLoader.stopActivity()
      self.tableView.hidden = false
      let json = responseObject
      if json?["error"] == nil {
        self.articles = Article.syncWithJsonArray(json as! Array<NSDictionary>, ctx: self.dataLayer.managedObjectContext!)
        self.dataLayer.saveContext()
        self.tableView.reloadData()
        print(self.articles.count)
        print(self.articles[0].author.firstName)
      } else {
        //Show Error Message
      }
    })
  }
  
  // MARK: - UITableViewDataSource
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1;
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return articles.count;
  }
  

  
  func tableView(tableView: UITableView,
    cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier(kArticlesCellIdentifier, forIndexPath: indexPath) as! ArticleTableViewCell
      cell.article = articles[indexPath.row]
      print("cellForRowAtIndexPath")
      print(articles[indexPath.row].description)
      cell.setupElements()
      return cell
  }
  
  // MARK: - UITableViewDelegate
  
  func tableView(tableView: UITableView,
    didSelectRowAtIndexPath indexPath: NSIndexPath) {
      tableView.deselectRowAtIndexPath(indexPath, animated: false)
  }
  
}
