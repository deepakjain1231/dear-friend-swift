//
//  ImagePickerManager.swift
//  Youunite
//
//  Created by Mac on 11/12/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//

import Foundation
import UIKit
import Photos
import CropViewController
import WXImageCompress
import MobileCoreServices

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    enum MediaSourceType {
        case camera
        case gallery
        case both
    }
    
    var picker = UIImagePickerController()
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    var mediaType = [kUTTypeMovie as String, kUTTypeImage as String]
    var isSelectMedia = false
    var viewController: UIViewController?
    var pickImageCallback: ((UIImage) -> ())?
    var pickVideoCallback: ((UIImage, URL) -> ())?
    
    override init() {
        super.init()
        picker.delegate = self
        alert.view.tintColor = UIColor.black
    }
    
    func pickImage(_ viewController: UIViewController, sourceType: MediaSourceType = .both, _ callback: @escaping ((UIImage) -> ())) {
        pickImageCallback = callback
        self.viewController = viewController
        
        setupAlertActions(sourceType: sourceType)
        alert.popoverPresentationController?.sourceView = self.viewController!.view
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func pickMedia(_ viewController: UIViewController, sourceType: MediaSourceType = .both, _ callback: @escaping ((UIImage) -> ()), _ videocallback: @escaping ((UIImage, URL) -> ())) {
        isSelectMedia = true
        pickImageCallback = callback
        pickVideoCallback = videocallback
        self.viewController = viewController
        
        setupAlertActions(sourceType: sourceType)
        alert.popoverPresentationController?.sourceView = self.viewController!.view
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func setupAlertActions(sourceType: MediaSourceType) {
        alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor.black  // Set the same tint color for the alert controller
        
        if sourceType == .camera || sourceType == .both {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
                self.cameraAuthorization()
            }
            cameraAction.setValue(UIColor.black, forKey: "titleTextColor")  // Set text color
            alert.addAction(cameraAction)
        }
        
        if sourceType == .gallery || sourceType == .both {
            let galleryAction = UIAlertAction(title: "Gallery", style: .default) { _ in
                self.openGallery()
            }
            galleryAction.setValue(UIColor.black, forKey: "titleTextColor")  // Set text color
            alert.addAction(galleryAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")  // Set text color for Cancel action
        alert.addAction(cancelAction)
    }
    
    func cameraAuthorization() {
        
        self.alert.dismiss(animated: true, completion: nil)
        
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch authStatus {
        case .restricted, .denied:
            self.showPermisionAlert(type: "Camera")
            
        case .authorized:
            self.cameraOpen()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                if granted {
                    self.cameraOpen()
                } else {
                    self.cameraAuthorization()
                }
            })
        @unknown default:
            print("Unknown camera authorization status")
        }
    }
    
    func cameraOpen() {
        DispatchQueue.main.async {
            self.alert.dismiss(animated: true, completion: nil)
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.picker.sourceType = .camera
                self.picker.allowsEditing = false
                self.viewController?.definesPresentationContext = true
                self.picker.modalPresentationStyle = .overFullScreen
                self.viewController?.present(self.picker, animated: true, completion: nil)
            } else {
                showAlertWithTitleFromVC(vc: self.viewController!, andMessage: "You don't have a camera")
            }
        }
    }
    
    func openGallery() {
        alert.dismiss(animated: true, completion: nil)
        PHPhotoLibrary.requestAuthorization { [weak self] result in
            guard let self = self else { return }
            if result == .authorized {
                DispatchQueue.main.async {
                    self.picker.sourceType = .photoLibrary
                    self.picker.allowsEditing = false
                    if self.isSelectMedia {
                        self.picker.mediaTypes = self.mediaType
                    }
                    self.viewController?.present(self.picker, animated: true, completion: nil)
                }
            } else {
                DispatchQueue.main.async {
                    self.showPermisionAlert(type: "Photo Gallery")
                }
            }
        }
    }
    
    func showPermisionAlert(type: String) {
        alert = UIAlertController(title: "Permission Required", message: "Please allow access to your \(type)", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
        }
        alert.addAction(settingsAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        viewController?.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let chosenImage = info[.originalImage] as? UIImage {
            picker.dismiss(animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                let cropController = CropViewController(croppingStyle: .default, image: chosenImage)
                cropController.delegate = self
                cropController.aspectRatioPreset = .presetSquare
                cropController.modalPresentationStyle = .fullScreen
                self.viewController?.present(cropController, animated: true, completion: nil)
            }
        } else if let videoURL = info[.mediaURL] as? NSURL {
            print(videoURL)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                do {
                    let asset = AVURLAsset(url: videoURL as URL, options: nil)
                    let imgGenerator = AVAssetImageGenerator(asset: asset)
                    imgGenerator.appliesPreferredTrackTransform = true
                    let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
                    let thumbnail = UIImage(cgImage: cgImage)
                    self.pickVideoCallback?(thumbnail, videoURL as URL)
                } catch let error {
                    print("*** Error generating thumbnail: \(error.localizedDescription)")
                }
                picker.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
        
    }
}

extension ImagePickerManager: CropViewControllerDelegate {
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        cropViewController.dismiss(animated: true, completion: {
            self.pickImageCallback?(image)
        })
    }
    
    func makeRoundImg(img: UIImage) -> UIImage {
        let imageV = UIImageView.init(image: img)
        let imgLayer = CALayer()
        imgLayer.frame = imageV.bounds
        imgLayer.contents = imageV.image?.cgImage
        imgLayer.masksToBounds = true

        imgLayer.cornerRadius = imageV.frame.size.width / 2

        UIGraphicsBeginImageContext(imageV.bounds.size)
        imgLayer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return roundedImage!
    }
}
