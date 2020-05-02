//
//  UserDetalManager.swift
//  Contact
//
//  Created by Ahtasham Ansari on 02/05/20.
//  Copyright © 2020 AhtashamAnsari. All rights reserved.
//


import Foundation
import ContactsUI
import CoreData



class DatabaseHelper: NSObject {
    

    @objc static let sharedInstance = DatabaseHelper()
    /** block init from other class because this is shared instanse */
    private override init() {}
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    func saveContactList(contact: PhoneContact) {
          
        let contactListOb = NSEntityDescription.insertNewObject(forEntityName: "ContactList", into: context!) as! ContactList
        contactListOb.name = contact.givenName ?? "NA"
        contactListOb.number = contact.number ?? "NA"
        contactListOb.email = contact.email ?? "NA"
        do {
            if context?.hasChanges ?? false {
                try context?.save()
            }
        } catch{
            print("-------> data not save")
        }
    }
    
    
    func fetchContactList() ->[ContactList] {
        var contactList = [ContactList]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ContactList")
        do {
            contactList = try context?.fetch(fetchRequest) as! [ContactList]
        } catch {
            print("-----> can't fetch data")
        }
        return contactList
    }
    
}
