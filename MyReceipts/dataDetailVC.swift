//
//  dataDetailVC.swift
//  
//
//  Created by Saemi An on 11/20/22.

import UIKit
import RealmSwift
import FirebaseAuth

class dataDetailVC: UIViewController {
    
    var createdAt = ""
    var savedName = ""
    var data = ""
    var imgUrl = "" 
    
    @IBOutlet weak var SV: UIScrollView!
    
    @IBOutlet weak var savedOn: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    
//    @IBOutlet weak var savedAs: UILabel!
//    @IBOutlet weak var dataName: UILabel!
    
    @IBOutlet weak var extractedTexts: UILabel!
    @IBOutlet weak var detail: UILabel!
    
    @IBOutlet weak var delBtn: UIButton!
    @IBAction func delBtnClicked(_ sender: Any) {
        let realm = try! Realm()
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this data?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Delete", style: .destructive) { _ in
            if let delete = realm.objects(receiptsData.self).filter(NSPredicate(format: "createdAt = %@", self.lbDate.text ?? "")).first {
                try! realm.write{
                    realm.delete(delete)
                }
                self.movePage(where: "viewReceiptsVC")
            }
            else {
                print("Nothing to delete")
            }
        }

        let no = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancelled")
        }
        alert.addAction(no)
        alert.addAction(yes)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
        self.view.backgroundColor = myBG
    
//        savedAs.translatesAutoresizingMaskIntoConstraints = false
//        savedAs.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        savedAs.topAnchor.constraint(equalTo: lbDate.bottomAnchor, constant: 3).isActive = true
//        savedAs.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        savedAs.heightAnchor.constraint(equalToConstant: 30).isActive = true
//
//        dataName.translatesAutoresizingMaskIntoConstraints = false
//        dataName.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        dataName.topAnchor.constraint(equalTo: savedAs.bottomAnchor, constant: 3).isActive = true
//        dataName.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        dataName.heightAnchor.constraint(equalToConstant: 30).isActive = true
//
        extractedTexts.translatesAutoresizingMaskIntoConstraints = false
        extractedTexts.centerXAnchor.constraint(equalTo: SV.centerXAnchor).isActive = true
        extractedTexts.topAnchor.constraint(equalTo: SV.topAnchor, constant: 70).isActive = true
        extractedTexts.widthAnchor.constraint(equalToConstant: 150).isActive = true
        extractedTexts.heightAnchor.constraint(equalToConstant: 30).isActive = true

        detail.translatesAutoresizingMaskIntoConstraints = false
        detail.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        detail.topAnchor.constraint(equalTo: extractedTexts.bottomAnchor, constant: 3).isActive = true
        detail.widthAnchor.constraint(equalToConstant: 270).isActive = true
       // detail.heightAnchor.constraint(equalToConstant: 1000).isActive = true
        
        savedOn.translatesAutoresizingMaskIntoConstraints = false
        savedOn.centerXAnchor.constraint(equalTo: SV.centerXAnchor).isActive = true
        savedOn.topAnchor.constraint(equalTo: detail.bottomAnchor, constant: 15).isActive = true
        savedOn.widthAnchor.constraint(equalToConstant: 150).isActive = true
        savedOn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        lbDate.translatesAutoresizingMaskIntoConstraints = false
        lbDate.centerXAnchor.constraint(equalTo: SV.centerXAnchor).isActive = true
        lbDate.topAnchor.constraint(equalTo: savedOn.bottomAnchor, constant: 10).isActive = true
        lbDate.widthAnchor.constraint(equalToConstant: 150).isActive = true
        lbDate.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
//        imgReceipt.translatesAutoresizingMaskIntoConstraints = false
//        imgReceipt.centerXAnchor.constraint(equalTo: SV.centerXAnchor).isActive = true
//        imgReceipt.topAnchor.constraint(equalTo: lbDate.bottomAnchor, constant: 10).isActive = true
//        imgReceipt.widthAnchor.constraint(equalToConstant: 270).isActive = true
//        imgReceipt.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        delBtn.translatesAutoresizingMaskIntoConstraints = false
        delBtn.centerXAnchor.constraint(equalTo: SV.centerXAnchor).isActive = true
        delBtn.topAnchor.constraint(equalTo: lbDate.bottomAnchor, constant: 10).isActive = true
        delBtn.widthAnchor.constraint(equalToConstant: 270).isActive = true
        delBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        lbDate.text = createdAt
       // dataName.text = savedName
        detail.text = data
       // imgReceipt.image = UIImage(named: "receipt1")
        
//        let url = URL(string: imgUrl)
//        if let imgData = try? Data(contentsOf: url!)
//        {
//            let imageToShow = UIImage(data: imgData)
//            imgReceipt.image = imageToShow
//        }
        
    }
    
    private func movePage(where: String) {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: `where`)
        self.navigationController?.pushViewController(pushVC!, animated: true)
    }

}





