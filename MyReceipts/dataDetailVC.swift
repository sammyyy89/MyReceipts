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
    
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var dataName: UILabel!
    @IBOutlet weak var detail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.view.backgroundColor = myBG
        lbDate.text = createdAt
        dataName.text = savedName
        detail.text = data 
    }

}





