//
//  extractTextVC.swift
//  MyReceipts
//
//  Created by Saemi An on 11/13/22.
//

import Vision
import UIKit
import RealmSwift
import FirebaseAuth

class extractTextVC: UIViewController {
    
    var receiptText:String?
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = label.font.withSize(14)
        return label
    }()
    
    var imageView: UIImageView = {
    var imageView = UIImageView()
    imageView.image = imageView.image
    imageView.contentMode = .scaleAspectFit
    return imageView
    }()
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var imageURL: UILabel!
    
    let userEmail = FirebaseAuth.Auth.auth().currentUser?.email ?? nil
    var tmp = ""
    
    let randomInt = Int.random(in: 100000..<999999)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("random Num: \(randomInt)")
        
        view.addSubview(label)
        view.addSubview(imageView)
        
        imageURL.text = tmp
        imageURL.isHidden = true
        recognizeText(image: imageView.image)
    }
    
    private func movePage(where: String) {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: `where`)
        self.navigationController?.pushViewController(pushVC!, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        //imageView.heightAnchor.constraint(equalToConstant: 240).isActive = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0).isActive = true
        
        saveBtn.translatesAutoresizingMaskIntoConstraints = false
        saveBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        saveBtn.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20).isActive = true
        saveBtn.addTarget(self, action: #selector(saveBtnPressed), for: .touchUpInside)
        saveBtn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        saveBtn.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    @objc func saveBtnPressed() {
        let realm = try! Realm()
        
        var saveAs = UITextField()
        
        let alert = UIAlertController(title: "Save as", message: "Enter a name to save this data as", preferredStyle: .alert)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Enter name here"
            saveAs = alertTextField
        }
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        let now = dateFormatter.string(from: date)
        
        let action = UIAlertAction(title: "Save", style: .default) { action in
            print(saveAs.text!)
            // save data to database
            let db = receiptsData()
            db.uniqueKey = "\(now)+\(self.randomInt)"
            db.createdAt = now 
            db.user = self.userEmail ?? "Not found"
            db.dataName = saveAs.text ?? "Not found"
            db.extractedText = self.receiptText ?? "None"
            db.url = self.imageURL.text ?? "Not found"
            
            try!  realm.write {
                realm.add(db)
            }
            
            let data = realm.objects(receiptsData.self)
            let currentUserData = data.filter("user == %@", self.userEmail ?? "No matching data")
            print(currentUserData)
            
            let successAlert = UIAlertController(title: "Success", message: "Saved successfully!", preferredStyle: .alert)
            let okay = UIAlertAction(title: "OK", style:.default){
                UIAlertAction in
                self.movePage(where: "optionsPage")
            }
            successAlert.addAction(okay)
            self.present(successAlert, animated: true, completion: nil)
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func recognizeText(image: UIImage?) {
        guard let cgImage = image?.cgImage else { return }
        
        // Handler
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        // Request
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                return
            }
            let myText = observations.compactMap({
                $0.topCandidates(1).first?.string
            }).joined(separator: "\n")
            self?.receiptText = myText
            
            DispatchQueue.main.async {
                self?.label.text = myText
            }
        }
        
        // Process request
        do {
            try handler.perform([request])
        }
        catch {
            label.text = "\(error)"
        }
    }
    
}

class receiptsData: Object {
    @objc dynamic var uniqueKey: String = ""
    @objc dynamic var createdAt: String = ""
    @objc dynamic var user: String = "" // user’s email address associated with My Receipts
    @objc dynamic var dataName: String = ""
    @objc dynamic var extractedText: String = ""
    @objc dynamic var url: String = ""
}
