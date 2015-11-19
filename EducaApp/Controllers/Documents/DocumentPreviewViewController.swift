//
//  DocumentPreviewViewController.swift
//  EducaApp
//
//  Created by Alonso on 11/6/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class DocumentPreviewViewController: UIViewController {
  
  @IBOutlet weak var documentWebView: UIWebView!
  @IBOutlet weak var customLoader: CustomActivityIndicatorView!

  @IBOutlet weak var noDocumentLabel: UILabel!
  
  var document: Document?
  var navigationIsShowed = true
  var isReport = false
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupElements()
  }

  // MARK: - Private
  
  private func setupElements() {
    self.title = document?.name
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    navigationController?.navigationBar.barTintColor = UIColor.defaultDocumentPreviewNavColor()
   loadDocument()
  }
  
  private func loadDocument() {
    customLoader.startActivity()
    guard let documentUrl = document?.url as String! else {
      return
    }
    guard let url = NSURL(string: "\(Constants.Path.BaseUrl)\(documentUrl)" ) else {
      showPlaceHolderView()
      return
    }
    let requestObject = document?.isSaved == true ? NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 100.0) : NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 10.0)
    documentWebView.loadRequest(requestObject)
  }
  
  private func setupNavigationBar() {
    if navigationIsShowed {
      navigationIsShowed = false
      UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Slide)
       self.navigationController?.setNavigationBarHidden(true, animated: true)
    } else {
      navigationIsShowed = true
      self.navigationController?.setNavigationBarHidden(false, animated: true)
      UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Slide)
    }
  }
  
  private func sendDocumentVisualization() {
    DocumentService.visualizateDocument(Int((document?.id)!), completion: {(responseObject: AnyObject?, error: NSError?) in
      guard let json = responseObject as? NSDictionary else {
        return
      }
      print(json)
    })
  }
  
  private func showPlaceHolderView() {
    noDocumentLabel.hidden = false
    customLoader.stopActivity()
  }
  
  // MARK: - Actions
  
  @IBAction func dismissView(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func hideNavigation(sender: AnyObject) {
    setupNavigationBar()
  }
  
}

// MARK: - UIWebViewDelegate

extension DocumentPreviewViewController: UIWebViewDelegate {
  
  func webViewDidFinishLoad(webView: UIWebView) {
    documentWebView.hidden = false
    customLoader.stopActivity()
    if !isReport {
      sendDocumentVisualization()
    }
  }
  
}
