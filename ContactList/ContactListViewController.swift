//
//  ContactListViewController.swift
//  ContactList
//
//  Created by Ahtasham Ansari on 02/05/20.
//  Copyright © 2020 AhtashamAnsari. All rights reserved.
//

struct IKCOCellIdentifiers {
    static let UserDetailTableViewCell = "UserDetailTableViewCell"
}

import UIKit

class ContactListViewController: UIViewController {

    /**UITableView: For showing user detal table view**/
    @IBOutlet weak var tableView: UITableView!
    
    var contactList = [ContactList]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contactList = DatabaseHelper.sharedInstance.fetchContactList()
        NotificationCenter.default.addObserver(self, selector: #selector(contactUpdate), name: NSNotification.Name(rawValue: "ContactSync"), object: nil)
        self.initialSetup()
        // Do any additional setup after loading the view.
    }
        private func initialSetup() {
            self.title = "Contact List"
            
            let tabelViewCellNib = UINib(nibName: String (describing: UserDetailTableViewCell.self), bundle: Bundle.main)
            self.tableView.register(tabelViewCellNib, forCellReuseIdentifier: IKCOCellIdentifiers.UserDetailTableViewCell)
        }
        
        @objc func contactUpdate() -> Void {
            self.contactList = DatabaseHelper.sharedInstance.fetchContactList()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }

    //MARK :- UITableView UITableViewDataSource, UITableViewDelegate mathod

    extension ContactListViewController: UITableViewDataSource, UITableViewDelegate {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            self.contactList.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                    guard let cell = (tableView.dequeueReusableCell(withIdentifier: IKCOCellIdentifiers.UserDetailTableViewCell, for: indexPath) as? UserDetailTableViewCell) else {
                return UserDetailTableViewCell()
            }
            cell.configureCell(contact: contactList[indexPath.row])
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
             UITableView.automaticDimension
        }
        
        func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            UITableView.automaticDimension
        }
    }

