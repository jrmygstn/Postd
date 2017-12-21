//
//  User.swift
//  Prept
//
//  Created by Jeremy Gaston on 10/8/17.
//  Copyright © 2017 Prept Apps, LLC. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    var username: String!
    var email: String
    var uid: String
    var ref: DatabaseReference!
    var key: String = ""
    
    init(snapshot: DataSnapshot) {
        self.username = (snapshot.value as! NSDictionary)["name"] as! String
        self.email = (snapshot.value as! NSDictionary)["email"] as! String
        self.uid = (snapshot.value as! NSDictionary)["uid"] as! String
        self.ref = snapshot.ref
        self.key = snapshot.key
    }
    
    init(username: String, email: String, uid: String) {
        
        self.ref = Database.database().reference()
        self.username = username
        self.email = email
        self.uid = uid
        
    }
    
    func toAnyObject() -> [String: Any]{
        
        return
            ["username":username, "email":email, "uid":uid]
        
    }
}
