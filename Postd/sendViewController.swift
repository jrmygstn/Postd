//
//  sendViewController.swift
//  Postd
//
//  Created by Jeremy Gaston on 10/22/17.
//  Copyright © 2017 KeepUsPostd. All rights reserved.
//

import UIKit

class sendViewController: UIViewController, UITextViewDelegate {
    
    // Outlets
    
    @IBOutlet var profileImage: CustomizableImageView!
    @IBOutlet var textField: UITextView!
    @IBOutlet var imageView: CustomizableImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    
    // Actions
    
    @IBAction func backBtn(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectButtonTapped(_ sender: Any) {
    }
    
    @IBAction func submitStory(_ sender: Any) {
    }
    
    // Functions
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n")
        {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(textField.text == "Write a caption")
        {
            textField.text = ""
        }
        textField.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textField.text == "")
        {
            textField.text = "Write a caption"
        }
        textField.resignFirstResponder()
    }

}
