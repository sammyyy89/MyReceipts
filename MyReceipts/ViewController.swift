//
//  ViewController.swift
//  MyReceipts
//
//  Created by Saemi An on 11/7/22.
//

import UIKit
import MessageUI
import SafariServices
import FirebaseAuth


class ViewController: UIViewController, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate, UITabBarControllerDelegate {
    
    @IBOutlet weak var lbUsername: UILabel!
    
    @IBOutlet weak var firstBtn: UIButton!
    @IBOutlet weak var secondBtn: UIButton!
    @IBOutlet weak var thirdBtn: UIButton!
    
    @IBAction func contactBtn(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let vc = MFMailComposeViewController()
            vc.delegate = self
            vc.setSubject("Contact Us / Feedback")
            vc.setToRecipients(["san1@mercy.edu"])
            vc.setMessageBody("<h1>Thank you for using My Receipts</h1>", isHTML: true)
            //vc.addAttachmentData(<#T##attachment: Data##Data#>, mimeType: "plain/txt", fileName: <#T##String#>)
            present(UINavigationController(rootViewController:vc), animated: true)
        }
        else {
            guard let url = URL(string: "https://www.gmail.com") else {
                return
            }
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        currentUserName()
        //self.tabBarController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currentUserName()
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func currentUserName() {
        if FirebaseAuth.Auth.auth().currentUser != nil {
            if let currentUser = Auth.auth().currentUser {
                let userName = currentUser.displayName ?? "Name not found"
                
                self.lbUsername.text = "Welcome, \(userName)"
                self.firstBtn.isHidden = false
                self.secondBtn.isHidden = false
                self.thirdBtn.isHidden = false
            }
        } else {
            self.lbUsername.text = "Please login to use My Receipts."
            self.firstBtn.isHidden = true
            self.secondBtn.isHidden = true
            self.thirdBtn.isHidden = true
        }
    }
}



