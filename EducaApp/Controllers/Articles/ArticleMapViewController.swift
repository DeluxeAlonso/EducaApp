//
//  ArticleMapViewController.swift
//  EducaApp
//
//  Created by Alonso on 10/8/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class ArticleMapViewController: UIViewController {
  
  @IBOutlet weak var mapView: GMSMapView!
  @IBOutlet weak var mapInfoView: UIView!
  @IBOutlet weak var mapInfoLabel: UILabel!
  @IBOutlet weak var mapRouteButton: UIButton!
  
  let EventMarkerTitle = "Lugar del Evento"
  
  let locationManager = CLLocationManager()
  let sessionLocation = CLLocationCoordinate2DMake(
    -12.068016, -77.001027)
  
  var currentLocation: CLLocationCoordinate2D?
  var targetLocation: CLLocationCoordinate2D?
  
  var polyline: GMSPolyline?
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupElements()
  }
  
  // MARK: - Private
  
  private func setupElements() {
    setupLocation()
    setupNavigationBar()
    setupInfoView()
  }
  
  private func setupLocation() {
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    addMarkerWithTitle(EventMarkerTitle, color: UIColor.blueColor(), coordinate: sessionLocation)
    targetLocation = sessionLocation
    reverseGeocodeCoordinate(sessionLocation)
  }
  
  func setupNavigationBar() {
    UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
    view.backgroundColor = UIColor.defaultBackgroundColor()
    navigationController?.navigationBar.barTintColor = UIColor.defaultTextColor()
    navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
  }
  
  private func setupInfoView() {
    mapInfoView.setShadowBorder()
    mapRouteButton.setShadowBorder()
  }
  
  private func addMarkerWithTitle(title: String, color: UIColor, coordinate: CLLocationCoordinate2D) {
    let marker = GMSMarker(position: coordinate)
    marker.title = title
    marker.icon = CustomMapMarker.markerImageWithColor(color)
    marker.appearAnimation = kGMSMarkerAnimationPop
    marker.map = mapView
    mapView.selectedMarker = marker
  }
  
  private func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
    clearMap()
    let geocoder = GMSGeocoder()
    targetLocation = coordinate
    geocoder.reverseGeocodeCoordinate(coordinate, completionHandler: { (response, error) in
      guard let address = response?.firstResult() else {
        return
      }
      let lines: [String] = address.lines as! [String]
      self.mapInfoLabel.text = lines.joinWithSeparator("\n")
    })
    UIView.animateWithDuration(0.25, animations: {
      self.view.layoutIfNeeded()
    })
  }
  
  private func clearMap() {
    polyline?.map = nil
  }
  
  // MARK: - Actions
  
  @IBAction func dismissMap(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func drawRoute(sender: AnyObject) {
    let path = GMSMutablePath()
    path.addCoordinate(currentLocation!)
    path.addCoordinate(targetLocation!)
    polyline = GMSPolyline(path: path)
    polyline!.strokeWidth = 5.0
    polyline!.geodesic = true
    polyline?.map = mapView
  }
  
}

// MARK: - CLLocationManagerDelegate

extension ArticleMapViewController: CLLocationManagerDelegate {
  
  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    guard status == .AuthorizedWhenInUse else {
      return
    }
    locationManager.startUpdatingLocation()
    mapView.myLocationEnabled = true
    mapView.settings.compassButton = true
    mapView.settings.myLocationButton = true
  }
  
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first as CLLocation? else {
      return
    }
    currentLocation = location.coordinate
    mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 11, bearing: 0, viewingAngle: 0)
    locationManager.stopUpdatingLocation()
  }
  
}
