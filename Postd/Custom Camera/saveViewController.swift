//
//  saveViewController.swift
//  Postd
//
//  Created by Jeremy Gaston on 10/22/17.
//  Copyright © 2017 KeepUsPostd. All rights reserved.
//

import UIKit
import Firebase

class saveViewController: UIViewController {
    
    // Variables
    
    var databaseRef: DatabaseReference! {
        
        return Database.database().reference()
    }
    
    var storageRef: StorageReference! {
        
        return Storage.storage().reference()
    }
    
    var image: UIImage!
    
    // Outlets
    
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = self.image
        
    }
    
    // Functions
    
    func saveChanges(){
        
        let imageName = NSUUID().uuidString
        
        let storedImage = storageRef.child("storyPhotos").child(imageName)
        
        if let uploadData = UIImagePNGRepresentation(self.imageView.image!){
            storedImage.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil{
                    print(error!)
                    return
                }
                storedImage.downloadURL(completion: { (url, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                })
            })
        }
    }
    
    // Actions
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindSegueToCapture", sender: self)
    }
    
    @IBAction func savePhoto(_ sender: Any) {
        guard let imageToSave = image else {
            return
        }
        saveChanges()
        UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
        let controller = storyboard?.instantiateViewController(withIdentifier: "sendView")
        self.present(controller!, animated: true, completion: nil)
    }
    
}
