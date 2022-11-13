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


class ViewController: UIViewController, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var lbUsername: UILabel!
    
    @IBAction func contactBtn(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let vc = MFMailComposeViewController()
            vc.delegate = self
            vc.setSubject("Contact Us / Feedback")
            vc.setToRecipients(["san1@mercy.edu"])
            vc.setMessageBody("<h1>Hello world</h1>", isHTML: true)
            //vc.addAttachmentData(<#T##attachment: Data##Data#>, mimeType: "plain/txt", fileName: <#T##String#>)
            present(UINavigationController(rootViewController:vc), animated: true)
        }
        else {
//            let alert = UIAlertController(title: "Email Not Available", message: "This device is unable to send an email. We will redirect you to gmail.com", preferredStyle: .alert)
//            let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
//            alert.addAction(OK)
//            present(alert, animated: true, completion: nil)
            
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

    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func currentUserName() {
        if let currentUser = Auth.auth().currentUser {
            let userName = currentUser.displayName ?? "Name not found"
            
            self.lbUsername.text = "Welcome, \(userName)"
        }
    }
    
}



