//
//  CameraViewController.swift
//  EducaApp
//
//  Created by Alonso on 9/28/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

let RotateRightIconName = "RotateRightIcon"
let RotateLeftIconName = "RotateLeftIcon"

class CameraViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  @IBOutlet weak var pictureImageView: UIImageView!
  @IBOutlet weak var rotateLeftButton: UIButton!
  @IBOutlet weak var rotateRightButton: UIButton!
  @IBOutlet weak var sendPhotoButton: UIButton!
  @IBOutlet weak var alertLabel: UILabel!
  @IBOutlet weak var alertSolutionLabel: UILabel!
  
  var imagePicker = UIImagePickerController()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupElements()
  }
  
  // MARK: - Private
  
  private func setupElements() {
    setupImagePicker()
    setupImageView()
  }
  
  private func setupImagePicker() {
    imagePicker.delegate = self
    imagePicker.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
    imagePicker.allowsEditing = true
    imagePicker.edgesForExtendedLayout = UIRectEdge.All
  }
  
  private func setupImageView() {
    pictureImageView.layer.shadowColor = UIColor.blackColor().CGColor
    pictureImageView.layer.shadowOffset = CGSizeMake(1, 1)
    pictureImageView.layer.shadowRadius = 5
    pictureImageView.layer.shadowOpacity = 0.5
  }
  
  private func enableButtons() {
    rotateLeftButton.userInteractionEnabled = true
    rotateRightButton.userInteractionEnabled = true
    sendPhotoButton.userInteractionEnabled = true
    rotateRightButton.setBackgroundImage(UIImage(named: RotateRightIconName), forState: UIControlState.Normal)
    rotateLeftButton.setBackgroundImage(UIImage(named: RotateLeftIconName), forState: UIControlState.Normal)
    sendPhotoButton.layer.backgroundColor = UIColor.defaultTextColor().CGColor
  }
  
  private func hidePlaceholder() {
    alertLabel.hidden = true
    alertSolutionLabel.hidden = true
    pictureImageView.alpha = 1
    pictureImageView.contentMode = UIViewContentMode.ScaleToFill
  }
  
  // MARK: - Actions
  
  @IBAction func openPhotoGallery(sender: AnyObject) {
    guard UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) else {
      return
    }
    imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
    presentViewController(imagePicker, animated: true, completion: nil)
  }
  
  @IBAction func openCamera(sender: AnyObject) {
    guard UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) else {
      return
    }
    imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
    imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.Photo
    imagePicker.showsCameraControls = true
    presentViewController(imagePicker, animated: true, completion: nil)
  }
  
  @IBAction func rotatePhotoRight(sender: AnyObject) {
    UIView.animateWithDuration(0.5, animations: {
      self.pictureImageView.transform = CGAffineTransformRotate(self.pictureImageView.transform, CGFloat(M_PI/2))
    })
  }
  
  @IBAction func rotatePhotoLeft(sender: AnyObject) {
    UIView.animateWithDuration(0.5, animations: {
      self.pictureImageView.transform = CGAffineTransformRotate(self.pictureImageView.transform, CGFloat(-M_PI/2))
    })
  }
  
  // MARK: - UIImagePickerControllerDelegate
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    enableButtons()
    let image = info[UIImagePickerControllerEditedImage]
    imagePicker.dismissViewControllerAnimated(true, completion: nil)
    hidePlaceholder()
    pictureImageView.image = image as? UIImage
  }

}
