//
//  signupViewController.swift
//  Postd
//
//  Created by Jeremy Gaston on 10/17/17.
//  Copyright © 2017 KeepUsPostd. All rights reserved.
//

import UIKit
import Firebase

class signupViewController: UIViewController, UIPickerViewDelegate {
    
    // Outlets
    
    @IBOutlet var nameField: CustomizableTextfield!
    @IBOutlet var emailField: CustomizableTextfield!
    @IBOutlet var organizationField: CustomizableTextfield!
    @IBOutlet var compArray: UIPickerView!
    
    // Variables
    
    var databaseRef: DatabaseReference! {
        
        return Database.database().reference()
    }
    
    var refOrgs = DatabaseReference()
    var uuid = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let refOrgs = Database.database().reference().child("orgs")
        
        organizationField.inputView = compArray
        
        refOrgs.observe(.childAdded, with: { snapshot in
            
            if let dic = snapshot.value as? [String:Any], let name = dic["orgs"] as? String {
                print("\(name)")
                
                //Reload the pickerView components
                self.compArray.reloadAllComponents()
                
                //Or you can reload the pickerView's specific component
                self.compArray.reloadComponent(0)
            }
        })
        
    }
    
    // Actions
    
    @IBAction func requestAccess(_ sender: Any) {
        self.performSegue(withIdentifier: "success", sender: nil)
    }
    
    // Functions
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true;
    }
    
//    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if (compArray.tag == 1) {
//            let titleRow = compArray[row]
//            return titleRow
//        }
//    }
    
}
