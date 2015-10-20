//
//  RecoverPasswordTableViewController.swift
//  EducaApp
//
//  Created by Gloria Cisneros on 18/10/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class RecoverPasswordTableViewController: UITableViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentSizeInPopup = CGSizeMake(300, 200)
        setupNavigationBar()
        self.title = "Recuperar Contraseña"
      

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavigationBar() {
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
        view.backgroundColor = UIColor.defaultBackgroundColor()
        navigationController?.navigationBar.barTintColor = UIColor.defaultTextColor()
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
}
