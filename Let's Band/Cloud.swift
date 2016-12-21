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
    
    // MARK: - Initializers
    init() {
        container = CKContainer.default()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
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
    
}
