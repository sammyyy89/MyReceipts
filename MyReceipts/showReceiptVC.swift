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
    
    @IBOutlet weak var lbTest: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
        self.view.backgroundColor = myBG
        lbTest.text = "test"

    }
    
    private func movePage(where: String) {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: `where`)
        self.navigationController?.pushViewController(pushVC!, animated: true)
    }

}





