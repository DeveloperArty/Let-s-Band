//
//  SomeUserProfileViewController.swift
//  Let's Band
//
//  Created by Artem Pavlov on 16.01.17.
//  Copyright © 2017 Den prod. All rights reserved.
//

import UIKit

class SomeUserProfileViewController: ProfileViewController {
    
    
    // MARK: - Properties
    var receivedNickname: String? {
        willSet {
            print("SomeUserProfileViewController has successfully received user nickname; nickname: \(newValue)")
            loadNickname()
            self.loadInstruments()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - General Setup
    override func loadNickname() {
        self.nicknameLabel?.text = receivedNickname!
        print("nicknameLabel set successfully")
    }
    
    override func loadNameSurname() {
        guard let nickname = receivedNickname else {
            print("can not load name surname")
            return
        }
        cloud.loadNameSurnameFor(nickname: nickname, senderViewController: self)    }
    
    override func loadAge() {
        guard let nickname = receivedNickname else {
            print("can not load age")
            return
        }
        cloud.loadAgeFor(nickname: nickname, senderViewController: self)    }
    
    override func loadInstruments() {
        
        guard let nickname = receivedNickname else {
            print("can not load instruments")
            return
        }
        cloud.loadInstruments(nickname: nickname, senderViewController: self)
    }
    
    override func loadAddInfo() {
        guard let nickname = receivedNickname else {
            print("can not load info")
            return
        }
        cloud.loadAddInfoFor(nickname: nickname, senderViewController: self)    }
    
    override func loadLinks() {
        guard let nickname = receivedNickname else {
            print("can not load mail")
            return
        }
        cloud.loadMailFor(nickname: nickname, senderViewController: self)
    }

    
}
