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
    
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var dataName: UILabel!
    @IBOutlet weak var detail: UILabel!
    
    @IBOutlet weak var imgReceipt: UIImageView!
    
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
        lbDate.text = createdAt
        dataName.text = savedName
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





