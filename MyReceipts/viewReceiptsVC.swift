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

var myBG = hexStringToUIColor(hex: "#AFF8DB")

class viewReceiptsVC: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")
        return table
    }()

    //private let data: [Category] = []
    var load: [receiptsData] = []

    let userEmail = FirebaseAuth.Auth.auth().currentUser?.email ?? nil
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.view.backgroundColor = myBG
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func loadData() {
        let realm = try! Realm()
        let allData = realm.objects(receiptsData.self)
        let currentUserData = allData.filter("user == %@", self.userEmail ?? "No matching data")
        
        self.load = Array(currentUserData)
        tableView.reloadData()
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
        
        navigationController?.pushViewController(destVC!, animated: true)
    }
}

extension viewReceiptsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return load.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = load[indexPath.row].dataName
    
        return cell
    }
}



