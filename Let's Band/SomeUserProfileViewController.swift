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
    
    // MARK: - Setup 
    override func loadNickname() {
        self.nicknameLabel?.text = receivedNickname!
        print("nicknameLabel set successfully")
    }
    
    override func loadInstruments() {
        
        guard let nickname = receivedNickname else {
            print("can not load instruments")
            return
        }
        cloud.loadInstruments(nickname: nickname, senderViewController: self)
        print("loading instruments")
    }

}
