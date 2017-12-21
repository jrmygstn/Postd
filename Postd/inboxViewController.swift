//
//  inboxViewController.swift
//  Postd
//
//  Created by Jeremy Gaston on 10/22/17.
//  Copyright © 2017 KeepUsPostd. All rights reserved.
//

import UIKit

class inboxViewController: UIViewController {
    
    // Outlets
    
    // Variables
    
    var usersArray = [User]()
    var netService = NetworkingService()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // Actions
    
    @IBAction func backBtn(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // Functions
    

}

extension inboxViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessagesSystem.system.requestList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messages", for: indexPath) as? inboxTableViewCell
        
        cell?.titleLabel.text = MessagesSystem.system.requestList[indexPath.row].username
        //cell.configureCellForUser(user: usersArray[indexPath.row])
        
        // Return cell
        return cell!
    }
    
}
