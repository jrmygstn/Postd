//
//  inboxTableViewCell.swift
//  Postd
//
//  Created by Jeremy Gaston on 12/12/17.
//  Copyright © 2017 KeepUsPostd. All rights reserved.
//

import UIKit
import Firebase

class inboxTableViewCell: UITableViewCell {
    
    // Outlets
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    
    
    // Variables
    
    var databaseRef: DatabaseReference! {
        
        return Database.database().reference()
    }
    
    var storageRef: StorageReference! {
        
        return Storage.storage().reference()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCellForUser(user: User){
        
        self.titleLabel.text = user.username
        
    }

}
