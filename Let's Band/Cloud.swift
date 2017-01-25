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
import MapKit

class Cloud {
    
    // MARK: - Properties
    let container: CKContainer
    let publicDB: CKDatabase
    
    
    // MARK: - Initializers
    init() {
        container = CKContainer.default()
        publicDB = container.publicCloudDatabase
    }
    
    
    // MARK: - Log In:
    
    func logIn(userNickname: String, userPassword: String, senderViewController: LoginViewController) {

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
                print("record creator found")
                
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
                        DispatchQueue.main.async {
                        print("requested password found, acccess enabled")
                        senderViewController.defaults.set(userNickname, forKey: "nickname")
                        senderViewController.performSegue(withIdentifier: "SuccessfullLogIn", sender: nil)
                        }
                    }
                })

            }
        })
        
    }
    
    
    // MARK: - Registration:
    func registerNewUser(name: String, surname: String, dateOfBirth: Date, nickname: String, password: String, mail: String, additionalInformation: String, senderViewController: UIViewController) {
        
        // saving public data
        let publicDataRecord = CKRecord(recordType: "publicUserData")
        publicDataRecord["Name"] = name as CKRecordValue
        publicDataRecord["Surname"] = surname as CKRecordValue
        publicDataRecord["DateOfBirth"] = dateOfBirth as CKRecordValue
        publicDataRecord["Nickname"] = nickname as CKRecordValue
        publicDataRecord["Password"] = password as CKRecordValue
        publicDataRecord["Mail"] = mail as CKRecordValue
        publicDataRecord["Info"] = additionalInformation as CKRecordValue
        
        publicDB.save(publicDataRecord, completionHandler: { record , error in
            if error == nil {
                DispatchQueue.main.async {
                print("public data saved correctly")
                senderViewController.performSegue(withIdentifier: "Next", sender: nickname)
                }
            } else {
                print("an error occured while saving public data; error: \(error?.localizedDescription)")
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
                        DispatchQueue.main.async {
                        print("location added correctly")
                        senderViewController.performSegue(withIdentifier: "RegistrationAlmostDone", sender: nickname)
                        }
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
                        DispatchQueue.main.async {
                        print("user instrumets added successfully")
                        senderViewController.defaults.set(nickname, forKey: "nickname")
                        senderViewController.performSegue(withIdentifier: "RegistrationDoneSuccessfully", sender: nil)
                        }
                    } else {
                        print("an error occured while saving user instrumets")
                    }
                })
            }
        })
    }
    
    
    // MARK: - Loading data from the cloud
    func loadInstruments(nickname: String, senderViewController: ProfileViewController) {
        
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
                
                senderViewController.userInsts = record["Instrumets"] as? [String]
                return
            }
        })
        
    }
    
    func loadNameSurnameFor(nickname: String, senderViewController: ProfileViewController) {
        
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
                let name = record["Name"] as! String
                let surname = record["Surname"] as! String
                
                senderViewController.nameSurname = name + " " + surname
                return
            }
        })
        
    }
    
    func loadAgeFor(nickname: String, senderViewController: ProfileViewController) {
        
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
                
                let dateOfBirth = record["DateOfBirth"] as! Date
                let currentDate = Date()
                
                let calendar = Calendar.current
                let componentsB = calendar.dateComponents([.day , .month , .year], from: dateOfBirth)
                let componentsC = calendar.dateComponents([.day , .month , .year], from: currentDate)
                
                let yearB =  componentsB.year!
                let monthB = componentsB.month!
                let dayB = componentsB.day!
        
                let yearC = componentsC.year!
                let monthC = componentsC.month!
                let dayC = componentsC.day!
                
                var age = yearC - yearB
                if monthC < monthB {
                    age -= 1
                } else if monthC == monthB && dayC < dayB {
                    age -= 1
                }
                
                senderViewController.age = age
                return
            }
        })
    }
    
    func loadAddInfoFor(nickname: String, senderViewController: ProfileViewController) {
        
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
                
                senderViewController.addInfo = record["Info"] as? String
                return
            }
        })
        
    }
    
    func loadMailFor(nickname: String, senderViewController: ProfileViewController) {
        
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
                
                senderViewController.mail = record["Mail"] as? String
                return
            }
        })
        
    }
    
    
    // MARK: - Data Update 
    func updateUserMail(nickname: String, newMail: String, senderViewController: ProfileViewController) {
        
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
                record["Mail"] = newMail as CKRecordValue
                self.publicDB.save(record, completionHandler: { record, error in
                    if error == nil {
                        print("mail updated correctly")
                        senderViewController.mail = newMail
                        return
                    }
                })
            }
        })
        
    }
    
    func updateUserAddInfo(nickname: String, newInfo: String, senderViewController: ProfileViewController) {
        
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
                record["Info"] = newInfo as CKRecordValue
                self.publicDB.save(record, completionHandler: { record, error in
                    if error == nil {
                        print("additional information updated correctly")
                        senderViewController.addInfo = newInfo
                    }
                })
            }
        })
        
    }
    
    
    // MARK: - Seach for users
    func findOtherUsersWithDistance(distance: Double, userLocation: CLLocation, senderViewController: MapViewController) {
        
        let userPredicate = NSPredicate(format: "distanceToLocation:fromLocation: (Location,%@) < %f", userLocation, distance)
        let userQuery = CKQuery(recordType: "publicUserData", predicate: userPredicate)
        
        publicDB.perform(userQuery, inZoneWith: nil, completionHandler: { records, error in
            
            if error != nil {
                print("an error occured while performing a user query, error: \(error?.localizedDescription)")
            } else {
                guard records?.first != nil else {
                    print("no records found")
                    return
                }
                
                print("distance: \(distance)")
                
                var annotationsToShow: [SomeUserAnnotation?] = []
                
                for record in records! {
                    let locationFound = record["Location"] as! CLLocation
                    let nicknameFound = record["Nickname"] as! String
                    let allInstruments = record["Instrumets"] as! [String]
                    let mainInstrument = allInstruments.first
                    let annotation = SomeUserAnnotation(coordinate: locationFound.coordinate)
                    annotation.userName = nicknameFound
                    annotation.mainInstrument = mainInstrument 
                    annotation.otherInsts = allInstruments 
                    
                    annotationsToShow.append(annotation)
                    
                }
                
                print("annotations to send farther: \(annotationsToShow.count)")
                senderViewController.annotationsToShow = annotationsToShow
            }
        })
        
        return
    }
    
}
