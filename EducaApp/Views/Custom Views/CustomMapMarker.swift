//
//  CustomMapMarker.swift
//  EducaApp
//
//  Created by Alonso on 10/8/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class CustomMapMarker: GMSMarker {
  
  var type: Int?
  var assignedReunionPoint: SessionReunionPoint?
  var addedReunionPoint: NewReunionPoint?
  var selected: Bool?
  var wasAdded: Bool?
  var canBeDeleted: Bool?
  
  func setupMarker(title: String, color: UIColor, animation: GMSMarkerAnimation, wasAdded: Bool, canBeDeleted: Bool) {
    self.title = title
    self.icon = CustomMapMarker.markerImageWithColor(color)
    self.appearAnimation = animation
    self.wasAdded = wasAdded
    self.canBeDeleted = canBeDeleted
  }

}

class NewReunionPoint {
  
  var address: String?
  var latitude: Float?
  var longitude: Float?
  
}
