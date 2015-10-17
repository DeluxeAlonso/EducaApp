//
//  CollapseSectionHeaderView.swift
//  EducaApp
//
//  Created by Alonso on 9/26/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

protocol CollapseSectionHeaderViewDelegate {
  
  func collapseSectionHeaderViewDelegate(sectionHeaderView:CollapseSectionHeaderView, sectionOpened section:Int)
  func collapseSectionHeaderViewDelegate(sectionHeaderView:CollapseSectionHeaderView, sectionClosed section:Int)
  
}

class CollapseSectionModel {
  
  var open:Bool = true
  var section:Int = 0
  var sectionName:String = ""
  
  init() {
  }
  
  init(sectionName:String, section:Int, open:Bool) {
    self.sectionName = sectionName
    self.section = section
    self.open = open
  }
  
}

class CollapseSectionHeaderView: UITableViewHeaderFooterView {


  @IBOutlet weak var dateLabel: UILabel!
  
  @IBOutlet weak var arrowImageView: UIImageView!
  var delegate:CollapseSectionHeaderViewDelegate?
  
  var model:CollapseSectionModel = CollapseSectionModel() {
    didSet {
      self.dateLabel.text = self.model.sectionName
      self.arrowImageView.image = self.getArrowImageUpOrDown(self.model.open)
    }
  }
  
  // MARK: - Lifecycle
  
  override func awakeFromNib() {
    self.arrowImageView.image = self.getArrowImageUpOrDown(self.model.open)
    let tapGesture = UITapGestureRecognizer(target: self, action: Selector("tapGestureHandler:"))
    self.addGestureRecognizer(tapGesture)
  }
  
  // MARK: - Public
  
  func getArrowImageUpOrDown(arrowUp:Bool) -> UIImage? {
    let arrowName = arrowUp ? "CollapseArrow" : "ExpandArrow"
    return UIImage(named: arrowName)
  }
  
  func updateArrow() {
    self.arrowImageView.image = self.getArrowImageUpOrDown(self.model.open)
  }
  
  // MARK: - Actions
  
  @IBAction func tapGestureHandler(recognizer:UITapGestureRecognizer) {
    self.model.open = !self.model.open;
    self.arrowImageView.image = self.getArrowImageUpOrDown(self.model.open)
    
    if (self.model.open) {
      self.delegate?.collapseSectionHeaderViewDelegate(self, sectionOpened: self.model.section)
    } else {
      self.delegate?.collapseSectionHeaderViewDelegate(self, sectionClosed: self.model.section)
    }
  }
  
}
