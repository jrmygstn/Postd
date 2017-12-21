//
//  settingsViewController.swift
//  Postd
//
//  Created by Jeremy Gaston on 10/22/17.
//  Copyright © 2017 KeepUsPostd. All rights reserved.
//

import UIKit

class settingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // Actions
    
    @IBAction func unwindToSettings(segue:UIStoryboardSegue) {
    }
    
    @IBAction func backBtn(_ sender: UIBarButtonItem) {
        dismiss(animated: false, completion: nil)
    }
    
}
