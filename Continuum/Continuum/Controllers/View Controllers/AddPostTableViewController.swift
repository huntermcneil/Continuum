//
//  AddPostTableViewController.swift
//  Continuum
//
//  Created by Hunter McNeil on 6/30/20.
//  Copyright © 2020 Hunter McNeil. All rights reserved.
//

import UIKit

class AddPostTableViewController: UITableViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var captionTextField: UITextField!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        captionTextField.text = ""
    }
    
    @IBAction func publishButtonTapped(_ sender: Any) {
        guard let image = selectedImage,
            let caption = captionTextField.text, !caption.isEmpty else {return}
        PostController.shared.createPostWith(image: image, caption: caption) { (result) in
        }
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotoSelector" {
            let destinationVC = segue.destination as? PhotoSelectorViewController
            destinationVC?.delegate = self
        }
    }
}

extension AddPostTableViewController: PhotoSelectorViewControllerDelegate {
       func photoSelectorViewControllerSelected(image: UIImage) {
           selectedImage = image
       }
   }
