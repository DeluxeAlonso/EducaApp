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
  
  var refreshControl = UIRefreshControl()
  var customView: UIView!
  var labelsArray: Array<UILabel> = []
  
  var isRefreshing = false
  var isAnimating = false
  var currentColorIndex = 0
  var currentLabelIndex = 0
  
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
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Private
  
  private func setupElements() {
    setupTableView()
    setupBarButtonItem()
  }
  
  private func setupTableView() {
    self.tableView.estimatedRowHeight = 243;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    loadCustomRefreshContents()
    refreshControl.backgroundColor = UIColor.clearColor()
    refreshControl.tintColor = UIColor.whiteColor()
    tableView.addSubview(refreshControl)
    refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
  }
  
  private func loadCustomRefreshContents() {
    let refreshContents = NSBundle.mainBundle().loadNibNamed("RefreshContents", owner: self, options: nil)
    customView = refreshContents[0] as! UIView
    customView.clipsToBounds = true;
    customView.frame = refreshControl.bounds
    for var i=0; i<customView.subviews.count; ++i {
      labelsArray.append(customView.viewWithTag(i + 1) as! UILabel)
    }
    refreshControl.addSubview(customView)
  }
  
  func animateRefreshFirstStep() {
    isAnimating = true
    
    UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
      self.labelsArray[self.currentLabelIndex].transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
      self.labelsArray[self.currentLabelIndex].textColor = self.getNextColor()
      
      }, completion: { (finished) -> Void in
        
        UIView.animateWithDuration(0.05, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
          self.labelsArray[self.currentLabelIndex].transform = CGAffineTransformIdentity
          self.labelsArray[self.currentLabelIndex].textColor = UIColor.blackColor()
          
          }, completion: { (finished) -> Void in
            ++self.currentLabelIndex
            
            if self.currentLabelIndex < self.labelsArray.count {
              self.animateRefreshFirstStep()
            }
            else {
              self.animateRefreshSecondStep()
            }
        })
    })
  }
  
  func animateRefreshSecondStep() {
    UIView.animateWithDuration(0.35, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
      self.labelsArray[0].transform = CGAffineTransformMakeScale(1.5, 1.5)
      self.labelsArray[1].transform = CGAffineTransformMakeScale(1.5, 1.5)
      self.labelsArray[2].transform = CGAffineTransformMakeScale(1.5, 1.5)
      self.labelsArray[3].transform = CGAffineTransformMakeScale(1.5, 1.5)
      self.labelsArray[4].transform = CGAffineTransformMakeScale(1.5, 1.5)
      self.labelsArray[5].transform = CGAffineTransformMakeScale(1.5, 1.5)
      self.labelsArray[6].transform = CGAffineTransformMakeScale(1.5, 1.5)
      self.labelsArray[7].transform = CGAffineTransformMakeScale(1.5, 1.5)
      
      }, completion: { (finished) -> Void in
        UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
          self.labelsArray[0].transform = CGAffineTransformIdentity
          self.labelsArray[1].transform = CGAffineTransformIdentity
          self.labelsArray[2].transform = CGAffineTransformIdentity
          self.labelsArray[3].transform = CGAffineTransformIdentity
          self.labelsArray[4].transform = CGAffineTransformIdentity
          self.labelsArray[5].transform = CGAffineTransformIdentity
          self.labelsArray[6].transform = CGAffineTransformIdentity
          self.labelsArray[7].transform = CGAffineTransformIdentity
          }, completion: { (finished) -> Void in
            if self.refreshControl.refreshing {
              self.currentLabelIndex = 0
              self.animateRefreshFirstStep()
            }
            else {
              self.isAnimating = false
              self.currentLabelIndex = 0
              for var i=0; i<self.labelsArray.count; ++i {
                self.labelsArray[i].textColor = UIColor.blackColor()
                self.labelsArray[i].transform = CGAffineTransformIdentity
              }
            }
        })
    })
  }
  
  func getNextColor() -> UIColor {
    var colorsArray: Array<UIColor> = [UIColor.magentaColor(), UIColor.brownColor(), UIColor.yellowColor(), UIColor.redColor(), UIColor.greenColor(), UIColor.blueColor(), UIColor.orangeColor()]
    if currentColorIndex == colorsArray.count {
      currentColorIndex = 0
    }
    let returnColor = colorsArray[currentColorIndex]
    ++currentColorIndex
    
    return returnColor
  }
  
  private func setupBarButtonItem() {
    if self.revealViewController() != nil {
      self.menuIcon.target = self.revealViewController()
      self.menuIcon.action = kBarButtonSelector
      self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
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
  
  func refreshData() {
    isRefreshing = true
    let delay = 2.0 * Double(NSEC_PER_SEC)
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
    dispatch_after(time, dispatch_get_main_queue()) {
        self.getArticles()
    }
  }
  
  func reloadData() {
    let delay = 0.5 * Double(NSEC_PER_SEC)
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
    dispatch_after(time, dispatch_get_main_queue()) {
      if !self.isRefreshing {
        self.customLoader.stopActivity()
        self.tableView.hidden = false
        self.tableView.reloadData()
      }
    }
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
      cell.setupElements()
      return cell
  }
  
  // MARK: - UITableViewDelegate
  
  func tableView(tableView: UITableView,
    didSelectRowAtIndexPath indexPath: NSIndexPath) {
      tableView.deselectRowAtIndexPath(indexPath, animated: false)
  }
  
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    if refreshControl.refreshing {
      if !isAnimating {
        animateRefreshFirstStep()
      }
    }
  }
  
}
