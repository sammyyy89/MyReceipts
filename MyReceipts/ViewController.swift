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
import FirebaseCore
import GoogleSignIn

class ViewController: UIViewController, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {
    
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
    
    @IBAction func GoogleSignInBtn(_ sender: GIDSignInButton) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [self] user, error in
            guard error == nil else { return }
            
            guard let authentication = user?.authentication,
                  let idToken = authentication.idToken
            else {
                return
            }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { (result, error) in
                if let error = error {
                    print("Firebase auth fails with error: \(error.localizedDescription)")
                } else if let result = result {
                    print("Login success: \(result)")
                    // move page
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}



