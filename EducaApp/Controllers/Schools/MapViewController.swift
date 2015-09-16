//
//  MapViewController.swift
//  EducaApp
//
//  Created by Alonso on 9/1/15.
//  Copyright (c) 2015 Alonso. All rights reserved.
//

import UIKit
import MapKit

let regionRadius: CLLocationDistance = 1000
let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)

class MapViewController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var closeMapButton: UIButton!
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupElements()
    centerMapOnLocation(initialLocation)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Private
  
  private func setupElements() {
    setupButtons()
  }
  
  private func setupButtons() {
    self.closeMapButton.setBorderShadow()
  }
  
  func centerMapOnLocation(location: CLLocation) {
    let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
      regionRadius * 2.0, regionRadius * 2.0)
    mapView.setRegion(coordinateRegion, animated: true)
  }
  
  // MARK: - Actions
  
  @IBAction func dismissMapView(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion:nil)
  }
  
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
}
