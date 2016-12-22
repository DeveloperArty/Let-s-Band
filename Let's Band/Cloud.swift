//
//  Cloud.swift
//  Let's Band
//
//  Created by Artem Pavlov on 21.12.16.
//  Copyright © 2016 Den prod. All rights reserved.
//

import Foundation
import CloudKit

class Cloud {
    
    // MARK: - Properties
    let container: CKContainer
    let publicDB: CKDatabase
    let privateDB: CKDatabase
    // Log In 
    var noUserWithThisNickname: Bool
    
    
    // MARK: - Initializers
    init() {
        container = CKContainer.default()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
        noUserWithThisNickname = true
    }
    
    // MARK: - Cloud Methods
    func registerNewUser(name: String, surname: String, dateOfBirth: Date, nickname: String, password: String, mail: String) {
        
        // saving public data
        let publicDataRecord = CKRecord(recordType: "publicUsersData")
        publicDataRecord["Name"] = name as CKRecordValue?
        publicDataRecord["Surname"] = surname as CKRecordValue?
        publicDataRecord["DateOfBirth"] = dateOfBirth as CKRecordValue?
        publicDataRecord["Nickname"] = nickname as CKRecordValue?
        publicDB.save(publicDataRecord, completionHandler: { record , error in
            if error == nil {
                print("public data saved correctly")
            } else {
                print("an error occured while saving public data; error: \(error?.localizedDescription)")
            }
        })
        
        //saving private data 
        let privateDataRecord = CKRecord(recordType: "privateUsersData")
        privateDataRecord["Password"] = password as CKRecordValue?
        privateDataRecord["Mail"] = mail as CKRecordValue?
        privateDB.save(privateDataRecord, completionHandler: { record , error in
            if error == nil {
                print("private data saved correctly")
            } else {
                print("an error occured while saving private data; error: \(error?.localizedDescription)")
            }
        })
    }
    
    func logIn(userNickname: String, userPassword: String) {

        // searching for user's data in the cloud
        let publicPredicate = NSPredicate(format: "Nickname = %@", userNickname)
        let publicDBQuery = CKQuery(recordType: "publicUsersData", predicate: publicPredicate)
            publicDB.perform(publicDBQuery, inZoneWith: nil, completionHandler: { recordFound, error in
                 if error != nil {
                    print("an error occured while performing a nickname query")
                 } else {
                    guard recordFound?.isEmpty == false else {
                        print("no users with requested nickname found")
                        return
                    }
                    print("user with requested nickname found, \(recordFound)")
                    self.noUserWithThisNickname = false
                }
            })
        
//        let privatePredicate = NSPredicate(value: true)
//        let privateDBQuery = CKQuery(recordType: "privateUsersData", predicate: privatePredicate)
//        privateDB.perform(privateDBQuery, inZoneWith: nil, completionHandler: { recordFound, error in
//            
//        })
    }
    
}
