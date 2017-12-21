//
//  NetworkingService.swift
//  Prept
//
//  Created by Jeremy Gaston on 10/8/17.
//  Copyright © 2017 Prept Apps, LLC. All rights reserved.
//

import Foundation
import Firebase


struct NetworkingService {
    
    var databaseRef: DatabaseReference! {
        
        return Database.database().reference()
    }
    
    var storageRef: StorageReference! {
        
        return Storage.storage().reference()
    }
    
    func signup(name: String, email: String, password: String){
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                print (error.localizedDescription)
            }
        })
        
    }
    
    private func saveUserInfoToDB(user: User!){
        
        let userRef = databaseRef.child("users").child(user.uid)
        let newUser = User(username: user.username!, email: user.email, uid: user.uid)
        
        userRef.setValue(newUser.toAnyObject()) { (error, ref) in
            if error == nil {
                print("\(user.username!) has been logged in successfully")
            }else {
                print(error!.localizedDescription)
            }
        }
        
    }
    
}
