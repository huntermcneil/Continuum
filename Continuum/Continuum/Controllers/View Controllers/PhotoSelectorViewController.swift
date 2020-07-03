//
//  PhotoSelectorViewController.swift
//  Continuum
//
//  Created by Hunter McNeil on 7/1/20.
//  Copyright © 2020 Hunter McNeil. All rights reserved.
//

import UIKit

class PhotoSelectorViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var postImageView: UIImageView!
    
    weak var delegate: PhotoSelectorViewControllerDelegate?
    
    let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
          super.viewDidDisappear(true)
          postImageView.image = nil
          selectImageButton.setTitle("Select Image", for: .normal)
      }
    
    @IBAction func selectImageButtonTapped(_ sender: Any) {
        presentImagePicker()
        selectImageButton.setTitle("", for: .normal)
    }
    
    func presentImagePicker() {
        
        let alertController = UIAlertController(title: "Select an Image", message: "Show us your art!", preferredStyle: .actionSheet)
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.imagePickerController.sourceType = .photoLibrary
                self.present(self.imagePickerController, animated: true)
            } else {
                print("Photo library not available")
            }
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePickerController.sourceType = .camera
                self.present(self.imagePickerController, animated: true)
            } else {
                print("Camera is not available")
            }
        }
        
        let savedPhotosAlbumAction = UIAlertAction(title: "Saved photos album", style: .default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                self.imagePickerController.sourceType = .savedPhotosAlbum
                self.present(self.imagePickerController, animated: true)
            } else {
                print("Saved photos album is not available")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(savedPhotosAlbumAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        postImageView.image = image
        
        delegate?.photoSelectorViewControllerSelected(image: image)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

protocol PhotoSelectorViewControllerDelegate: AnyObject {
    func photoSelectorViewControllerSelected(image: UIImage)
}
