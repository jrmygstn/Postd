//
//  videoViewController.swift
//  Postd
//
//  Created by Jeremy Gaston on 12/7/17.
//  Copyright © 2017 KeepUsPostd. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Firebase

class videoViewController: AVPlayerViewController {
    
    // Variables
    
    var databaseRef: DatabaseReference! {
        
        return Database.database().reference()
    }
    
    var storageRef: StorageReference! {
        
        return Storage.storage().reference()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    // Functions
    
//    func saveChanges(){
//        
//        let videoName = NSUUID().uuidString
//        
//        let storedVideo = storageRef.child("storyVideos").child(videoName)
//        
//        if let uploadData = UIImagePNGRepresentation(self.imageView.image!){
//            storedVideo.putData(uploadData, metadata: nil, completion: { (metadata, error) in
//                if error != nil{
//                    print(error!)
//                    return
//                }
//                storedVideo.downloadURL(completion: { (url, error) in
//                    if error != nil{
//                        print(error!)
//                        return
//                    }
//                })
//            })
//        }
//    }
    
    // Action
    
    @IBAction func closeButton(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToRecord", sender: self)
    }
    
    @IBAction func saveButton(_ sender: Any) {
    }
    
}
