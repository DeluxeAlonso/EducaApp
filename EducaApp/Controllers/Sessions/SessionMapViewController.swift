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

class SessionMapViewController: UIViewController {
  
  @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
  @IBOutlet weak var mapView: GMSMapView!
  @IBOutlet weak var searchContainerView: UIView!
  @IBOutlet weak var mapInfoView: UIView!
  @IBOutlet weak var mapInfoLabel: UILabel!
  @IBOutlet weak var mapInfoViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var deleteMarkerButton: UIButton!
  @IBOutlet weak var mapRouteButton: UIButton!
  @IBOutlet weak var undoDeleteButton: UIButton!
  
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
  
  var newReunionPoints = NSMutableArray()
  var markers = NSMutableArray()
  
  var session: Session?
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupElements()
    getReunionPoints()
  }
  
  // MARK: - Private
  
  private func setupElements() {
    setupLocation()
    setupNavigationBar()
    setupAdditionalConstraints()
  }
  
  private func setupLocation() {
    mapView.delegate = self
    mapInfoView.setShadowBorder()
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
  
  private func setupAdditionalConstraints() {
    initialHeightConstant = mapInfoViewHeightConstraint.constant
    mapInfoViewHeightConstraint.constant = 0
  }
  
  private func getReunionPoints() {
    for sessionReunionPoint in (session?.reunionPoints)! {
      let reunionPoint = sessionReunionPoint as! SessionReunionPoint
      addMarkerWithTitleAndReunionPoint(SessionMarkerType.ReunionPoint.markerTitle(), color: reunionPoint.selected ?  SessionMarkerType.ReunionPoint.markerColor() : SessionMarkerType.DeletedPoint.markerColor(), type: reunionPoint.selected ? SessionMarkerType.ReunionPoint.hashValue : SessionMarkerType.DeletedPoint.hashValue, coordinate: reunionPoint.reunionPoint.coordinate, reunionPoint: reunionPoint)
    }
    setupSessionPoint()
  }
  
  private func setupSessionPoint() {
    addMarkerWithTitle(SessionMarkerType.SessionPoint.markerTitle(), color: SessionMarkerType.SessionPoint.markerColor(), type: SessionMarkerType.SessionPoint.hashValue, coordinate: (session?.coordinate)!)
    reverseGeocodeCoordinate((session?.coordinate)!)
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
      print("MAPINFOLABEL")
      print(lines.joinWithSeparator("\n"))
    })
    UIView.animateWithDuration(0.25, animations: {
      self.view.layoutIfNeeded()
    })
  }
  
  private func reverseGeocodeCoordinateWithNewPoint(coordinate: CLLocationCoordinate2D) {
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
      let newReunionPoint = NewReunionPoint()
      newReunionPoint.latitude = Float(coordinate.latitude)
      newReunionPoint.longitude = Float(coordinate.longitude)
      newReunionPoint.address = self.mapInfoLabel.text! as String?
      self.currentMarker?.addedReunionPoint = newReunionPoint
      self.newReunionPoints.addObject(newReunionPoint)
    })
    UIView.animateWithDuration(0.25, animations: {
      self.view.layoutIfNeeded()
    })
  }
  
  private func addMarkerWithTitle(title: String, color: UIColor, type: Int, coordinate: CLLocationCoordinate2D) {
    let marker = CustomMapMarker(position: coordinate)
    marker.title = title
    marker.icon = CustomMapMarker.markerImageWithColor(color)
    marker.appearAnimation = kGMSMarkerAnimationPop
    marker.map = mapView
    
    marker.wasAdded = false
    marker.canBeDeleted = false
    
    currentMarker = marker
    mapView.selectedMarker = marker
  }
  
  private func addNewMarkerWithTitle(title: String, color: UIColor, type: Int, coordinate: CLLocationCoordinate2D) {
    let marker = CustomMapMarker(position: coordinate)
    marker.title = title
    marker.icon = CustomMapMarker.markerImageWithColor(color)
    marker.appearAnimation = kGMSMarkerAnimationPop
    marker.map = mapView
    
    marker.wasAdded = true
    marker.canBeDeleted = true
    
    currentMarker = marker
    mapView.selectedMarker = marker
  }
  
  private func addMarkerWithTitleAndReunionPoint(title: String, color: UIColor, type: Int, coordinate: CLLocationCoordinate2D, reunionPoint: SessionReunionPoint) {
    let marker = CustomMapMarker(position: coordinate)
    marker.title = title
    marker.icon = CustomMapMarker.markerImageWithColor(color)
    marker.appearAnimation = kGMSMarkerAnimationPop
    marker.map = mapView
    
    marker.assignedReunionPoint = reunionPoint
    marker.selected = reunionPoint.selected
    marker.wasAdded = false
    marker.canBeDeleted = true
    
    currentMarker = marker
    mapView.selectedMarker = marker
  }
  
  private func showMapInfoView() {
    if !canDeleteCurrentMarker() {
      deleteMarkerButton.hidden = true
      undoDeleteButton.hidden = true
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
  
  private func canDeleteCurrentMarker() -> Bool {
    if currentMarker?.canBeDeleted == false {
      return false
    } else if currentMarker?.selected == false {
      enableUndoButton()
      return true
    } else if currentMarker?.selected == true {
      enableDeleteButton()
      return true
    } else if currentMarker?.wasAdded == true {
      enableDeleteButton()
      return true
    }
    return true
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
  
  private func drawRoute() {
    let route = mapTasks.overviewPolyline["points"] as! String
    let path: GMSPath = GMSPath(fromEncodedPath: route)
    polyline = GMSPolyline(path: path)
    polyline!.strokeWidth = 5.0
    polyline?.strokeColor = UIColor.defaultTextColor()
    polyline?.map = mapView
  }
  
  private func clearMap() {
    polyline?.map = nil
  }
  
  private func enableSaveButton() {
    isSaved = false
    saveBarButtonItem.enabled = true
  }
  
  private func enableUndoButton() {
    undoDeleteButton.hidden = false
    deleteMarkerButton.hidden = true
  }
  
  private func enableDeleteButton() {
    undoDeleteButton.hidden = true
    deleteMarkerButton.hidden = false
  }
  
}

// MARK: - Actions

extension SessionMapViewController {

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
    if currentMarker?.wasAdded == true {
      currentMarker!.map = nil
      newReunionPoints.removeObject((currentMarker?.addedReunionPoint)!)
      hideMapInfoView()
    } else {
      currentMarker?.assignedReunionPoint?.selected = false
      dataLayer.saveContext()
      currentMarker!.icon = CustomMapMarker.markerImageWithColor(SessionMarkerType.DeletedPoint.markerColor())
      currentMarker?.selected = false
      enableUndoButton()
      enableSaveButton()
    }
  }
  
  @IBAction func undoDeleteAction(sender: AnyObject) {
    currentMarker?.assignedReunionPoint?.selected = true
    dataLayer.saveContext()
    currentMarker!.icon = CustomMapMarker.markerImageWithColor(SessionMarkerType.ReunionPoint.markerColor())
    currentMarker?.type = SessionMarkerType.ReunionPoint.hashValue
    currentMarker?.selected = true
    enableDeleteButton()
    enableSaveButton()
  }
  
  @IBAction func drawRoute(sender: AnyObject) {
    print(Util.connectedToNetwork())
    guard Util.connectedToNetwork() == true else {
      return
    }
    self.mapTasks.getDirections(currentLocation, destination: targetLocation, waypoints: nil, travelMode: TravelModes.driving, completionHandler: { (status, success) -> Void in
      if success {
        self.drawRoute()
      }
      else {
        print(status)
      }
    })
  }
 
  @IBAction func saveReunionPoints(sender: AnyObject) {
    isSaved = true
    updateReunionPoints()
  }
  
}



// MARK: - CLLocationManagerDelegate

extension SessionMapViewController: CLLocationManagerDelegate {

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

  // MARK: - GMSMapViewDelegate

extension SessionMapViewController: GMSMapViewDelegate {

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
    addNewMarkerWithTitle(SessionMarkerType.ReunionPoint.markerTitle(), color: SessionMarkerType.AddedPoint.markerColor(), type: SessionMarkerType.AddedPoint.hashValue, coordinate: coordinate)
    clearMap()
    enableSaveButton()
    showMapInfoView()
    reverseGeocodeCoordinateWithNewPoint(coordinate)
  }
  
}

// MARK: - Networking

extension SessionMapViewController {
  
  func requestParameters() -> NSDictionary {
    let dictionary = NSMutableDictionary()
    dictionary["session_id"] = Int(session!.id)
    let arrayReunionDictionary = NSMutableArray()
    for reunionPoint in (session?.reunionPoints)! {
      let reunionDictionary = NSMutableDictionary()
      reunionDictionary["id"] = Int((reunionPoint as! SessionReunionPoint).reunionPoint.id)
      reunionDictionary["latitude"] = reunionPoint.reunionPoint.latitude
      reunionDictionary["longitude"] = reunionPoint.reunionPoint.longitude
      reunionDictionary["selected"] = reunionPoint.selected
      arrayReunionDictionary.addObject(reunionDictionary)
    }
    dictionary["meeting_points"] = arrayReunionDictionary
    let arrayNeWReunionDictionary = NSMutableArray()
    for newReunionPoint in newReunionPoints {
      let newReunionDictionary = NSMutableDictionary()
      newReunionDictionary["address"] = (newReunionPoint as! NewReunionPoint).address
      newReunionDictionary["latitude"] = (newReunionPoint as! NewReunionPoint).latitude
      newReunionDictionary["longitude"] = (newReunionPoint as! NewReunionPoint).longitude
      arrayNeWReunionDictionary.addObject(newReunionDictionary)
    }
    dictionary["new_meeting_points"] = arrayNeWReunionDictionary
    
    return dictionary
  }
  
  func updateReunionPoints() {
    SessionService.editReunionPoints(requestParameters(), completion: {(responseObject: AnyObject?, error: NSError?) in
      guard let json = responseObject as? NSDictionary else {
        return
      }
      if (json[Constants.Api.ErrorKey] == nil) {
        Session.updateOrCreateReunionPointsWithJson(json, ctx: self.dataLayer.managedObjectContext!)
        self.dataLayer.saveContext()
        self.getReunionPoints()
      }
    })
  }

}
