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
    // Log In 
    var userNicknameFound: Bool
    var userPasswordFound: Bool
    
    
    // MARK: - Initializers
    init() {
        container = CKContainer.default()
        publicDB = container.publicCloudDatabase
        userNicknameFound = false
        userPasswordFound = false
    }
    
    
    // MARK: - Cloud Methods
    func registerNewUser(name: String, surname: String, dateOfBirth: Date, nickname: String, password: String, mail: String) {
        
        // saving public data
        let publicDataRecord = CKRecord(recordType: "publicUserData")
        publicDataRecord["Name"] = name as CKRecordValue?
        publicDataRecord["Surname"] = surname as CKRecordValue?
        publicDataRecord["DateOfBirth"] = dateOfBirth as CKRecordValue?
        publicDataRecord["Nickname"] = nickname as CKRecordValue?
        publicDataRecord["Password"] = password as CKRecordValue?
        publicDataRecord["Mail"] = mail as CKRecordValue?

        publicDB.save(publicDataRecord, completionHandler: { record , error in
            if error == nil {
                print("public data saved correctly")
            } else {
                print("an error occured while saving public data; error: \(error?.localizedDescription)")
            }
        })
        
    }
    
    func logIn(userNickname: String, userPassword: String) {

        // searching for user's data in the cloud
        
        // searching for a nickname
        let nicknamePredicate = NSPredicate(format: "Nickname = %@", userNickname)
        let nicknameQuery = CKQuery(recordType: "publicUserData", predicate: nicknamePredicate)
        publicDB.perform(nicknameQuery, inZoneWith: nil, completionHandler: { recordsFound, error in
            if error != nil {
                print("an error occured while performing a nickname query, error: \(error?.localizedDescription)")
            } else {
                guard recordsFound?.isEmpty == false else {
                    print("no users with requested nickname found")
                    return
                }
                print("user with requested nickname found")
                self.userNicknameFound = true
            }
        })
        
        // searching for a password
        let passwordPredicate = NSPredicate(format: "Password = %@", userPassword)
        let passwordQuery = CKQuery(recordType: "publicUserData", predicate: passwordPredicate)
        publicDB.perform(passwordQuery, inZoneWith: nil, completionHandler: { recordsFound, error in
            if error != nil {
                print("an error occured while performing a password query")
            } else {
                guard recordsFound?.isEmpty == false else {
                    print("no matching passwords found")
                    return
                }
                print("requested password found")
                self.userPasswordFound = true 
            }
        })
        
    }
    
}
