//
//  UserDetailTableViewCell.swift
//  Contact
//
//  Created by Ahtasham Ansari on 02/05/20.
//  Copyright © 2020 AhtashamAnsari. All rights reserved.
//

import UIKit

class UserDetailTableViewCell: UITableViewCell {

    @IBOutlet private weak var contactNameLabel: UILabel!
    @IBOutlet private weak var contactMobileLabel: UILabel!
    @IBOutlet  private weak var contactEmailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(contact: ContactList) {
        
        contactNameLabel.text = contact.name ?? ""
        contactMobileLabel.text = contact.number ?? ""
        contactEmailLabel.text = contact.email ?? ""
    }
    
}
