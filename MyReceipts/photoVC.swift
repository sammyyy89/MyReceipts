//
//  photoVC.swift
//  MyReceipts
//
//  Created by Saemi An on 11/13/22.
//

import UIKit

class photoVC: UIViewController {
    
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var selectedImg: UIImageView!
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueButton.isHidden = true
    }
    
    @IBAction func cameraButtonTapped() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func didTapButton() { // photo library button tapped
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    @IBAction func continueBtn() {
        print("Continue with this photo")
    }
    
}

extension photoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            selectedImg.image = image
            continueButton.isHidden = false
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        continueButton.isHidden = true
    }
}
