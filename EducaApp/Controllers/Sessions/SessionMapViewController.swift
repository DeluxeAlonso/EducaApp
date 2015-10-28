//
//  SessionMapViewController.swift
//  EducaApp
//
//  Created by Alonso on 10/4/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

enum SessionMarkerType {
  
  case ReunionPoint
  case SessionPoint
  case AddedPoint
  case DeletedPoint
  
  func markerTitle() -> String {
    switch self {
    case .SessionPoint:
      return "Lugar de la Sesión"
    default:
      return "Punto de Reunión"
    }
  }
  
  func markerColor() -> UIColor {
    switch self {
    case .SessionPoint:
      return UIColor.blueColor()
    case .ReunionPoint:
      return UIColor.redColor()
    case .AddedPoint:
      return UIColor.yellowColor()
    default:
      return UIColor.lightGrayColor()
    }
  }
  
}

class SessionMapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
  
  @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
  @IBOutlet weak var mapView: GMSMapView!
  @IBOutlet weak var searchContainerView: UIView!
  @IBOutlet weak var mapInfoView: UIView!
  @IBOutlet weak var mapInfoLabel: UILabel!
  @IBOutlet weak var mapInfoViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var deleteMarkerButton: UIButton!
  @IBOutlet weak var mapRouteButton: UIButton!
  
  let CancelAlertTitle = "¿Está seguro de que desea salir?"
  let CancelAlertMessage = "Sus cambios no han sido guardados."
  
  let deleteMarkerSelector: Selector = "deleteMarker:"
  let undoDeleteActionSelector: Selector = "undoDeleteAction:"
  let locationManager = CLLocationManager()
  let sessionLocation = CLLocationCoordinate2DMake(
    -12.068016, -77.001027)
  
  var initialHeightConstant: CGFloat?
  var currentLocation: CLLocationCoordinate2D?
  var targetLocation: CLLocationCoordinate2D?
  var mapTasks = MapTasks()
  var polyline: GMSPolyline?
  var currentMarker: CustomMapMarker?
  var isSaved = true
  lazy var dataLayer = DataLayer()
  
  var session: Session?
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupElements()
    getReunionPoints()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Private
  
  private func setupElements() {
    print(session?.reunionPoints.count)
    setupLocation()
    setupNavigationBar()
    setupInfoView()
    setupAdditionalConstraints()
  }
  
  private func setupLocation() {
    mapView.delegate = self
    searchContainerView.layer.borderColor = UIColor.defaultSmallTextColor().CGColor
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
  }
  
  private func setupNavigationBar() {
    UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
    view.backgroundColor = UIColor.defaultBackgroundColor()
    navigationController?.navigationBar.barTintColor = UIColor.defaultTextColor()
    navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
  }
  
  private func setupInfoView() {
    mapInfoView.setShadowBorder()
  }
  
  private func setupAdditionalConstraints() {
    initialHeightConstant = mapInfoViewHeightConstraint.constant
    mapInfoViewHeightConstraint.constant = 0
  }
  
  private func getReunionPoints() {
    for i in 0..<Int((Constants.MockData.ReunionPoints.count)) {
      addMarkerWithTitle(SessionMarkerType.ReunionPoint.markerTitle(), color: SessionMarkerType.ReunionPoint.markerColor(), type: SessionMarkerType.ReunionPoint.hashValue, coordinate: Constants.MockData.ReunionPoints[i])
    }
    setupSessionPoint()
  }
  
  private func setupSessionPoint() {
    addMarkerWithTitle(SessionMarkerType.SessionPoint.markerTitle(), color: SessionMarkerType.SessionPoint.markerColor(), type: SessionMarkerType.SessionPoint.hashValue, coordinate: sessionLocation)
    reverseGeocodeCoordinate(sessionLocation)
    showMapInfoView()
  }
  
  private func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
    clearMap()
    let geocoder = GMSGeocoder()
    targetLocation = coordinate
    geocoder.reverseGeocodeCoordinate(coordinate, completionHandler: { (response, error) in
      guard let address = response?.firstResult() else {
        return
      }
      var lines: [String] = address.lines as! [String]
      lines = lines.filter { (line) in line.characters.count != 0 }
      self.mapInfoLabel.text = lines.joinWithSeparator("\n")
    })
    UIView.animateWithDuration(0.25, animations: {
      self.view.layoutIfNeeded()
    })
  }
  
  private func addMarkerWithTitle(title: String, color: UIColor, type: Int, coordinate: CLLocationCoordinate2D) {
    let marker = CustomMapMarker(position: coordinate)
    currentMarker = marker
    marker.title = title
    marker.type = type
    marker.icon = CustomMapMarker.markerImageWithColor(color)
    marker.appearAnimation = kGMSMarkerAnimationPop
    marker.map = mapView
    mapView.selectedMarker = marker
  }
  
  private func showMapInfoView() {
    if !canDeleteCurrentMarker() {
      deleteMarkerButton.hidden = true
    } else {
      deleteMarkerButton.hidden = false
    }
    let viewHeight = initialHeightConstant
    view.layoutIfNeeded()
    mapInfoViewHeightConstraint.constant = initialHeightConstant!
    UIView.animateWithDuration(0.25, animations: {
      self.view.layoutIfNeeded()
      self.mapView.padding = UIEdgeInsets(top: self.topLayoutGuide.length, left: 0,
        bottom: viewHeight!, right: 0)
    })
  }
  
  private func hideMapInfoView() {
    view.layoutIfNeeded()
    mapInfoViewHeightConstraint.constant = 0
    UIView.animateWithDuration(0.25, animations: {
      self.view.layoutIfNeeded()
      self.mapView.padding = UIEdgeInsets(top: self.topLayoutGuide.length, left: 0,
        bottom: self.bottomLayoutGuide.length, right: 0)
    })
  }
  
  private func clearMap() {
    polyline?.map = nil
  }
  
  private func enableSaveButton() {
    isSaved = false
    saveBarButtonItem.enabled = true
  }
  
  private func enableUndoButton() {
    deleteMarkerButton.setBackgroundImage(UIImage(named: ImageAssets.UndoIcon), forState: UIControlState.Normal)
    deleteMarkerButton.addTarget(self, action: undoDeleteActionSelector, forControlEvents: UIControlEvents.TouchUpInside)
  }
  
  private func enableDeleteButton() {
    deleteMarkerButton.setBackgroundImage(UIImage(named: ImageAssets.DeleteMarkerIcon), forState: UIControlState.Normal)
    deleteMarkerButton.addTarget(self, action: deleteMarkerSelector, forControlEvents: UIControlEvents.TouchUpInside)
  }
  
  private func canDeleteCurrentMarker() -> Bool {
    switch currentMarker?.type! {
    case SessionMarkerType.SessionPoint.hashValue?:
      return false
    case SessionMarkerType.DeletedPoint.hashValue?:
      enableUndoButton()
      return true
    default:
      enableDeleteButton()
      return true
    }
  }
  
  private func drawRoute() {
    let route = mapTasks.overviewPolyline["points"] as! String
    
    let path: GMSPath = GMSPath(fromEncodedPath: route)
    polyline = GMSPolyline(path: path)
    polyline!.strokeWidth = 5.0
    polyline?.strokeColor = UIColor.defaultTextColor()
    polyline?.map = mapView
  }
  
  // MARK: - Actions
  
  @IBAction func dismissMap(sender: AnyObject) {
    guard isSaved == false else {
      self.dismissViewControllerAnimated(true, completion: nil)
      return
    }
    let actionSheetController: UIAlertController = UIAlertController(title: CancelAlertTitle, message: CancelAlertMessage, preferredStyle: .Alert)
    let cancelAction: UIAlertAction = UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil)
    actionSheetController.addAction(cancelAction)
    let nextAction: UIAlertAction = UIAlertAction(title: "Salir", style: .Default) { action -> Void in
      self.dismissViewControllerAnimated(true, completion: nil)
    }
    actionSheetController.addAction(nextAction)
    self.presentViewController(actionSheetController, animated: true, completion: nil)
  }
  
  @IBAction func deleteMarker(sender: AnyObject) {
    currentMarker!.icon = CustomMapMarker.markerImageWithColor(SessionMarkerType.DeletedPoint.markerColor())
    currentMarker?.type = SessionMarkerType.DeletedPoint.hashValue
    enableUndoButton()
    enableSaveButton()
  }
  
  @IBAction func undoDeleteAction(sender: AnyObject) {
    currentMarker!.icon = CustomMapMarker.markerImageWithColor(SessionMarkerType.AddedPoint.markerColor())
    currentMarker?.type = SessionMarkerType.AddedPoint.hashValue
    enableDeleteButton()
  }
  
  @IBAction func drawRoute(sender: AnyObject) {
    self.mapTasks.getDirections(currentLocation, destination: targetLocation, waypoints: nil, travelMode: TravelModes.driving, completionHandler: { (status, success) -> Void in
      if success {
        self.drawRoute()
      }
      else {
        print(status)
      }
    })
  }
  
  // MARK: - CLLocationManagerDelegate
  
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

  // MARK: - GMSMapViewDelegate
  
  func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
    currentMarker = marker as? CustomMapMarker
    mapView.selectedMarker = marker
    let coordinate = marker.position
    showMapInfoView()
    reverseGeocodeCoordinate(coordinate)
    return true
  }
  
  func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
    clearMap()
    hideMapInfoView()
  }
  
  func mapView(mapView: GMSMapView!, didLongPressAtCoordinate coordinate: CLLocationCoordinate2D) {
    addMarkerWithTitle(SessionMarkerType.ReunionPoint.markerTitle(), color: SessionMarkerType.AddedPoint.markerColor(), type: SessionMarkerType.AddedPoint.hashValue, coordinate: coordinate)
    clearMap()
    showMapInfoView()
    reverseGeocodeCoordinate(coordinate)
  }
  
}
