//
//  mainVC.swift
//  MyReceipts
//
//  Created by Saemi An on 11/12/22.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn


class mainVC: UIViewController, UITabBarControllerDelegate { // UIViewController {
    
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var lbSub: UILabel!
    
    @IBOutlet weak var signOutBtn: UIButton!
    @IBAction func signOutBtnClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Confirm Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Yes", style: .default) { action in
            do {
                try FirebaseAuth.Auth.auth().signOut()
                self.GoogleBtn.isHidden = false
                self.signOutBtn.isHidden = true
                self.moveBtn.isHidden = true 
            } catch let error {
                print("Error occurred: \(error.localizedDescription)")
            }
        }
        let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(confirm)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var moveBtn: UIButton!
    
    @IBOutlet weak var GoogleBtn: UIButton!
    @IBAction func GoogleBtnClicked(_ sender: GIDSignInButton) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) {[self] user, error in
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
                    self.movePage(where: "optionsPage")
                }
            }
            
//            UserDefaults.standard.set(true, forKey: "isLoggedIn")
//            UserDefaults.standard.synchronize()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = myBG
        
        signOutBtn.translatesAutoresizingMaskIntoConstraints = false
        signOutBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        signOutBtn.topAnchor.constraint(equalTo: lbSub.bottomAnchor, constant: 50).isActive = true
        signOutBtn.widthAnchor.constraint(equalToConstant: 120).isActive = true 
        signOutBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        moveBtn.translatesAutoresizingMaskIntoConstraints = false
        moveBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        moveBtn.topAnchor.constraint(equalTo: signOutBtn.bottomAnchor, constant: 30).isActive = true
        moveBtn.widthAnchor.constraint(equalToConstant: 150).isActive = true
        moveBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        showOrHide()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showOrHide()
    }
    
//    fileprivate func isLoggedIn() -> Bool {
//        return UserDefaults.standard.bool(forKey: "isLoggedIn")
//    }
    
    private func showOrHide() {
        if FirebaseAuth.Auth.auth().currentUser != nil {
            // user is signed in
            self.signOutBtn.isHidden = false
            self.moveBtn.isHidden = false
            self.GoogleBtn.isHidden = true
        } else {
            self.signOutBtn.isHidden = true
            self.moveBtn.isHidden = true 
            self.GoogleBtn.isHidden = false
        }
    }
    
    private func movePage(where: String) {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: `where`)
        self.navigationController?.pushViewController(pushVC!, animated: true)
    }
}
