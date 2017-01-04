//
//  Cloud.swift
//  Let's Band
//
//  Created by Artem Pavlov on 21.12.16.
//  Copyright © 2016 Den prod. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

class Cloud {
    
    // MARK: - Properties
    let container: CKContainer
    let publicDB: CKDatabase
    // Log In 
    var userNicknameFound = false
    var userPasswordFound = false
    
    
    // MARK: - Initializers
    init() {
        container = CKContainer.default()
        publicDB = container.publicCloudDatabase
    }
    
    
    // MARK: - Cloud Methods
    func registerNewUser(name: String, surname: String, dateOfBirth: Date, nickname: String, password: String, mail: String, senderViewController: UIViewController) {
        
        // saving public data
        let publicDataRecord = CKRecord(recordType: "publicUserData")
        publicDataRecord["Name"] = name as CKRecordValue
        publicDataRecord["Surname"] = surname as CKRecordValue
        publicDataRecord["DateOfBirth"] = dateOfBirth as CKRecordValue
        publicDataRecord["Nickname"] = nickname as CKRecordValue
        publicDataRecord["Password"] = password as CKRecordValue
        publicDataRecord["Mail"] = mail as CKRecordValue
        
        publicDB.save(publicDataRecord, completionHandler: { record , error in
            if error == nil {
                print("public data saved correctly")
                senderViewController.performSegue(withIdentifier: "ContinueRegistration", sender: nickname)
            } else {
                print("an error occured while saving public data; error: \(error?.localizedDescription)")
            }
        })
        
    }
    
    func logIn(userNickname: String, userPassword: String, senderViewController: UIViewController) {

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
                let record = recordsFound?.first
                guard let recordCreatorID = record?.creatorUserRecordID else {
                    print("error: record creator not found")
                    return
                }
                print("record creator found, user id: \(recordCreatorID)")
                
                // password check for the specific user
                let passwordPredicate = NSPredicate(format: "Password = %@ && creatorUserRecordID = %@", userPassword, recordCreatorID)
                let passwordQuery = CKQuery(recordType: "publicUserData", predicate: passwordPredicate)
                self.publicDB.perform(passwordQuery, inZoneWith: nil, completionHandler: { recordsFound, error in
                    if error != nil {
                        print("an error occured while performing a password query, error: \(error?.localizedDescription)")
                        return
                    } else {
                        guard recordsFound?.isEmpty == false else {
                            print("no matching passwords found")
                            return
                        }
                        print("requested password found, acccess enabled")
                        senderViewController.performSegue(withIdentifier: "SuccessfullLogIn", sender: nil)
                    }
                })

            }
        })
        
    }
    
    func addUserCoordinate(nickname: String, location: CLLocation, senderViewController: LocationSetViewController) {
        
        let nicknamePredicate = NSPredicate(format: "Nickname = %@", nickname)
        let nicknameQuery = CKQuery(recordType: "publicUserData", predicate: nicknamePredicate)
        
        publicDB.perform(nicknameQuery, inZoneWith: nil, completionHandler: { records, error in
            if error != nil {
                print("an error occured while performing a nickname query, error: \(error?.localizedDescription)")
                return
            } else {
                guard records?.isEmpty == false else {
                    print("no records found")
                    senderViewController.ignoreMapTap = false
                    return
                }
                guard let record = records?.first else {
                    return
                }
                record["Location"] = location as CKRecordValue
                self.publicDB.save(record, completionHandler: { record, error in
                    if error == nil {
                        print("location added correctly")
                        senderViewController.performSegue(withIdentifier: "RegistrationAlmostDone", sender: nickname)
                    }
                })
            }
        })
    }
    
    func addUserInstruments(nickname: String, instruments: [String], senderViewController: InstrumentsViewController) {
        
        print("\(instruments)")
        let nicknamePredicate = NSPredicate(format: "Nickname = %@", nickname)
        let nicknameQuery = CKQuery(recordType: "publicUserData", predicate: nicknamePredicate)
        
        publicDB.perform(nicknameQuery, inZoneWith: nil, completionHandler: { records, error in
            if error != nil {
                print("an error occured while performing a nickname query, error: \(error?.localizedDescription)")
                return
            } else {
                guard records?.isEmpty == false else {
                    print("no records found")
                    return
                }
                guard let record = records?.first else {
                    return
                }
                
                record["Instrumets"] = instruments as CKRecordValue
                self.publicDB.save(record, completionHandler: { record, error in
                    if error == nil {
                        print("user instrumets added successfully")
                        senderViewController.performSegue(withIdentifier: "RegistrationDoneSuccessfully", sender: nil)
                    } else {
                        print("an error occured while saving user instrumets")
                    }
                })
            }
        })
    }
    
    
}
