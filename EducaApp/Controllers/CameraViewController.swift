//
//  CameraViewController.swift
//  EducaApp
//
//  Created by Alonso on 9/28/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

class CameraViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  @IBOutlet weak var pictureContainerView: UIView!
  @IBOutlet weak var pictureImageView: UIImageView!
  @IBOutlet weak var rotateLeftButton: UIButton!
  @IBOutlet weak var rotateRightButton: UIButton!
  @IBOutlet weak var sendPhotoButton: UIButton!
  @IBOutlet weak var alertLabel: UILabel!
  @IBOutlet weak var alertSolutionLabel: UILabel!
  @IBOutlet weak var customLoader: CustomActivityIndicatorView!
  
  var imagePicker = UIImagePickerController()
  var selectedImage: UIImage?
  
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
    pictureContainerView.layer.shadowColor = UIColor.blackColor().CGColor
    pictureContainerView.layer.shadowOffset = CGSizeMake(1, 1)
    pictureContainerView.layer.shadowRadius = 5
    pictureContainerView.layer.shadowOpacity = 0.5
  }
  
  private func enableButtons() {
    sendPhotoButton.userInteractionEnabled = true
    sendPhotoButton.layer.backgroundColor = UIColor.defaultTextColor().CGColor
  }
  
  private func hidePlaceholder() {
    alertLabel.hidden = true
    alertSolutionLabel.hidden = true
    pictureImageView.alpha = 1
    pictureImageView.contentMode = UIViewContentMode.ScaleToFill
  }
  
  private func enableSignInButton() {
    customLoader?.stopActivity()
    customLoader?.hidden = true
    sendPhotoButton.userInteractionEnabled = true
    sendPhotoButton.setTitle("Enviar", forState: UIControlState.Normal)
  }
  
  private func disableSignInButton() {
    sendPhotoButton.setTitle("", forState: UIControlState.Normal)
    customLoader?.startActivity()
    customLoader?.hidden = false
    sendPhotoButton.userInteractionEnabled = false
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
  
  @IBAction func sendPhoto(sender: AnyObject) {
    disableSignInButton()
    UserService.sendPhoto(selectedImage!, completion: {(responseObject: AnyObject?, error: NSError?) in
      self.enableSignInButton()
      let json = responseObject
      print(json)
      print(error?.description)
      if (json != nil && json?["error"]! == nil) {
        Util.showAlertWithTitle(self, title: "Enhorabuena", message: "La foto ha sido enviada.", buttonTitle: "OK")
      } else {
        Util.showAlertWithTitle(self, title: "Error", message: "No se pudo enviar la foto. Intente más tarde.", buttonTitle: "OK")
      }
    })
    
  }
  
  // MARK: - UIImagePickerControllerDelegate
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    enableButtons()
    let image = info[UIImagePickerControllerEditedImage]
    imagePicker.dismissViewControllerAnimated(true, completion: nil)
    hidePlaceholder()
    selectedImage = image as? UIImage
    pictureImageView.image = image as? UIImage
  }

}
