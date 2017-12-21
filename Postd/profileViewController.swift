//
//  profileViewController.swift
//  Postd
//
//  Created by Jeremy Gaston on 10/22/17.
//  Copyright © 2017 KeepUsPostd. All rights reserved.
//

import UIKit
import Firebase

class profileViewController: UIViewController {
    
    // Outlets
    
    @IBOutlet var fullNameText: UILabel!
    
    // Variables
    
    var databaseRef: DatabaseReference! {
        
        return Database.database().reference()
    }
    
    var storageRef: StorageReference! {
        
        return Storage.storage().reference()
    }
    
    var refUser = DatabaseReference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupProfile()
    }
    
    // Actions
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func logOut(_ sender: Any) {
        logout()
    }
    
    @IBAction func unwindToProfile(segue:UIStoryboardSegue) {
    }
    
    // Functions
    
    func setupProfile(){
        
        let uid = Auth.auth().currentUser?.uid
        databaseRef.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject] {
                self.fullNameText.text = dict["name"] as? String
            }
        })
    }
    
    func logout(){
        do {
            try Auth.auth().signOut()
            
            if Auth.auth().currentUser == nil {
                UserDefaults.standard.removeObject(forKey: "uid")
                UserDefaults.standard.synchronize()
            }
            let controller = storyboard?.instantiateViewController(withIdentifier: "loginView")
            self.present(controller!, animated: false, completion: nil)
        } catch {
            print(error)
        }
    }

}
