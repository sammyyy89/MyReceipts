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
    @IBOutlet weak var photoUrl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueButton.isHidden = true
        photoUrl.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "passImage" {
            let dvc = segue.destination as! extractTextVC
            dvc.imageView.image = selectedImg.image
            dvc.tmp = photoUrl.text ?? "Not found"
        }
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
        
        if let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL{
                let imgName = imgUrl.lastPathComponent
                let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
                let localPath = documentDirectory?.appending(imgName)

                let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
                let data = image.pngData()! as NSData
                data.write(toFile: localPath!, atomically: true)
                //let imageData = NSData(contentsOfFile: localPath!)!
                let photoURL = URL.init(fileURLWithPath: localPath!)//NSURL(fileURLWithPath: localPath!)
                print("Photo URL: \(photoURL)")
                
                photoUrl.text = photoURL.absoluteString
            }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        continueButton.isHidden = true
    }
}
