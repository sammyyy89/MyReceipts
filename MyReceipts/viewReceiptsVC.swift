//
//  viewReceiptsVC.swift
//  MyReceipts
//
//  Created by Saemi An on 11/7/22.
//

import UIKit
import RealmSwift
import FirebaseAuth

func hexStringToUIColor(hex: String) -> UIColor {
    var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue: UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xff0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

var myBG = hexStringToUIColor(hex: "#FFE3E8")
var mySeparatorColor = hexStringToUIColor(hex: "#00A876")

class viewReceiptsVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var field: UITextField!

//    private let tableView: UITableView = {
//        let table = UITableView()
//        table.register(UITableViewCell.self,
//                       forCellReuseIdentifier: "cell")
//        return table
//    }()

    var load: [receiptsData] = []
    var filtered = [String]()
    var isFiltered = false

    let userEmail = FirebaseAuth.Auth.auth().currentUser?.email ?? nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.view.backgroundColor = myBG
        
        tableView.backgroundColor = myBG
        tableView.separatorColor = mySeparatorColor

        checkLogin()
        
        tableView.delegate = self
        tableView.dataSource = self
        field.delegate = self
        
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        tableView.frame = view.bounds
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkLogin()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            if string.count == 0 {
                filterText(String(text.dropLast()))
            } else {
                filterText(text+string)
            }
        }
        
        return true
    }
    
    func filterText(_ query: String) {
        filtered.removeAll()
        
        let realm = try! Realm()
        let allData = realm.objects(receiptsData.self)
        let currentUserData = allData.filter("user == %@", self.userEmail ?? "No matching data")
        
        self.load = Array(currentUserData).sorted() {$0.createdAt > $1.createdAt}
        
        for dt in load {
            if dt.dataName.lowercased().starts(with: query.lowercased()) {
                filtered.append(dt.dataName)
            }
        }
        tableView.reloadData()
        isFiltered = true
    }
    
    func loadData() {
        let realm = try! Realm()
        let allData = realm.objects(receiptsData.self)
        let currentUserData = allData.filter("user == %@", self.userEmail ?? "No matching data")
        
        if currentUserData.isEmpty {
                        let alert = UIAlertController(title: "No Data", message: "There is no data to display. Please add one.", preferredStyle: .alert)
                        let okay = UIAlertAction(title: "OK", style:.default){
                            UIAlertAction in
                            self.movePage(where: "optionsPage")
                        }
                        alert.addAction(okay)
                        self.present(alert, animated: true, completion: nil)
        } else {
            self.load = Array(currentUserData).sorted() {$0.createdAt > $1.createdAt} // from newest
            tableView.reloadData()
        }
    }
    
    func checkLogin(){
        if FirebaseAuth.Auth.auth().currentUser != nil {
            //view.addSubview(tableView)
            field.isHidden = false
            label.isHidden = true
            self.tableView.isHidden = false
            loadData()
        } else {
            label.text = "Please login to use My Receipts"
            label.isHidden = false
            field.isHidden = true
            self.tableView.isHidden = true
        }
    }
    
    private func movePage(where: String) {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: `where`)
        self.navigationController?.pushViewController(pushVC!, animated: true)
    }
    
}

extension viewReceiptsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let from = load[indexPath.row]
        
        let destVC = storyboard?.instantiateViewController(withIdentifier: "dataDetailVC") as? dataDetailVC
        destVC?.createdAt = from.createdAt
        destVC?.savedName = from.dataName 
        destVC?.data = from.extractedText
        destVC?.imgUrl = from.url
        destVC?.uniqueKey = from.uniqueKey
        
        navigationController?.pushViewController(destVC!, animated: true)
    }
}

extension viewReceiptsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !filtered.isEmpty {
            return filtered.count
        }
        return isFiltered ? 0 : load.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if !filtered.isEmpty {
            cell.textLabel?.text = filtered[indexPath.row]//.dataName
        } else {
            cell.textLabel?.text = load[indexPath.row].dataName
        }
        cell.backgroundColor = myBG
    
        return cell
    }
}



