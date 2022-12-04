//
//  showReceiptVC.swift
//  
//
//  Created by Saemi An on 11/22/22.
//

import UIKit
import RealmSwift
import FirebaseAuth

class showReceiptVC: UIViewController {
    
    @IBOutlet weak var updateBtn: UIButton!
    @IBAction func updateClicked(_ sender: Any) {
        if self.tfNewName.text == "" {
            let errorAlert = UIAlertController(title: "Empty Field", message: "Please enter a name to save as", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style:.default){
                UIAlertAction in
                print("This text field should not be empty.")
            }
            errorAlert.addAction(ok)
            self.present(errorAlert, animated: true, completion: nil)
        } else {
            let realm = try! Realm()
            let allData = realm.objects(receiptsData.self)
            if let currentData = allData.filter("user == %@", self.currUser!, "createdAt == %@", createdDate).first {
                try! realm.write {
                    currentData.dataName = self.tfNewName.text!
                    currentData.extractedText = self.tfTexts.text!
                }
                let successAlert = UIAlertController(title: "Success", message: "Successfully updated!", preferredStyle: .alert)
                let okay = UIAlertAction(title: "OK", style:.default){
                    UIAlertAction in
                    self.movePage(where: "viewReceiptsVC")
                }
                successAlert.addAction(okay)
                self.present(successAlert, animated: true, completion: nil)
            }
        }
    }
    
    var imgPath = ""
    var createdDate = ""
    var texts = ""
    
    var currUser = FirebaseAuth.Auth.auth().currentUser?.email

//    var documentsUrl: URL {
//        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//    }
    
    @IBOutlet weak var tfNewName: UITextField!
    @IBOutlet weak var tfTexts: UITextView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
        self.view.backgroundColor = myBG
        tfTexts.text = texts
        

    }
        
    private func movePage(where: String) {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: `where`)
        self.navigationController?.pushViewController(pushVC!, animated: true)
    }
}


