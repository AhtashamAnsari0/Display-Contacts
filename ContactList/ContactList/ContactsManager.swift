//
//  File.swift
//  ContactList
//
//  Created by Ahtasham Ansari on 02/05/20.
//  Copyright © 2020 AhtashamAnsari. All rights reserved.
//

import Foundation
import ContactsUI

enum ContactsFilter {
    case none
    case mail
    case message
}

struct PhoneContact {
    var givenName: String?
    var number: String?
    var email: String?
    
    init(givenName:String?, number:String?, email:String?) {
        self.givenName = givenName
        self.number = number
        self.email = email
    }
}

class ContactsManager {
    
    //MARK: - Properties
    
    static let manager = ContactsManager()
    
    let arrContactsDicts = NSMutableArray()
    
    //MARK: - Helpers
    
    private func getContacts(from contactStore: CNContactStore, filter: ContactsFilter = .none) -> [CNContact] {
        
        var results: [CNContact] = []
        
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey] as [Any]
        
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            return results
        }
        
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
            } catch {
                return results
            }
        }
        
        return results
    }
    
    
    private func contactsAuthorization(for store: CNContactStore, completionHandler: @escaping ((_ isAuthorized: Bool) -> Void)) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .authorized:
            completionHandler(true)
        case .notDetermined:
            store.requestAccess(for: CNEntityType.contacts, completionHandler: { (isAuthorized: Bool, error: Error?) in
                completionHandler(isAuthorized)
            })
        case .denied:
            completionHandler(false)
        case .restricted:
            completionHandler(false)
        @unknown default:
            break
        }
    }
    
    private func parse(_ contact: CNContact) -> PhoneContact? {
        
        for phoneNumber in contact.phoneNumbers {
            
            let number = phoneNumber.value
            if phoneNumber.label?.contains("Mobile") ?? false {
                
                var emailAddress = ""
                if (contact.emailAddresses as NSArray).count != 0 {
                    emailAddress = (contact.emailAddresses.first!).value as String
                }
                return PhoneContact(givenName: contact.givenName, number: number.stringValue, email: emailAddress)
            }
            return nil
        }
        
        return nil
    }
    
    //MARK: - Actions
    
    func fetchAllContacts(completionHandler: @escaping (_ success: Bool, Error?) -> Void) {
        
        var phoneContacts = [PhoneContact]()
        
        let contactStore = CNContactStore()
        
        contactsAuthorization(for: contactStore) { isAuthorized in
            if isAuthorized {
                let contacts = self.getContacts(from: contactStore)
                for contact in contacts {
                    if let phoneContact = self.parse(contact) {
                        
                        if phoneContact.givenName != "SPAM" {
                            phoneContacts.append(phoneContact)
                        }
                    } else {
                        continue
                    }
                }
                let contactList =  DatabaseHelper.sharedInstance.fetchContactList()
                if contactList.count > 0 {
                    
                }else {
                    self.saveNewContactInDatabase(contactList: phoneContacts) { (success) in
                        completionHandler(true, nil)
                    }
                }
                
                
            } else {
                completionHandler(false, nil)
            }
        }
    }
    
    private func saveNewContactInDatabase(contactList:[PhoneContact], completionHandler:@escaping (_ success:Bool) -> ()) -> Void {
            
            for newContact in contactList {
                DatabaseHelper.sharedInstance.saveContactList(contact: newContact)
            }
            completionHandler(true)
    }
    
    
}
