//
//  loginViewController.swift
//  Postd
//
//  Created by Jeremy Gaston on 10/17/17.
//  Copyright © 2017 KeepUsPostd. All rights reserved.
//

import UIKit
import Firebase

class loginViewController: UIViewController {
    
    // Outlets
    
    @IBOutlet var emailField: CustomizableTextfield!
    @IBOutlet var passwordField: CustomizableTextfield!
    @IBOutlet var showTapped: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // Actions
    
    @IBAction func revealPassword(_ sender: Any) {
        if passwordField.isSecureTextEntry {
            passwordField.isSecureTextEntry = false
            showTapped.isSelected = true
        } else {
            passwordField.isSecureTextEntry = true
            showTapped.isSelected = false
        }
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        guard let email = emailField.text,
            email != "",
            let password = passwordField.text,
            password != ""
            else {
                AlertController.showAlert(self, title: "Forget Something?", message: "Your email or password is missing")
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            guard error == nil else {
                AlertController.showAlert(self, title: "Error", message: error!.localizedDescription)
                //UserDefaults.standard.set(FIRAuth.auth()!.currentUser!.uid, forKey: "uid")
                UserDefaults.standard.synchronize()
                return
            }
            guard let user = user else { return }
            print(user.email ?? "MISSING EMAIL")
            print(user.uid)
            
            self.performSegue(withIdentifier: "home", sender: nil)
        })
    }
    
    @IBAction func resetBtn(_ sender: Any) {
        
    }
    
    @IBAction func unwindToLogin(segue:UIStoryboardSegue) {
    }
    
    // Functions
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true;
    }
    

}
