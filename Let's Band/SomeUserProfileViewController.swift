//
//  SomeUserProfileViewController.swift
//  Let's Band
//
//  Created by Artem Pavlov on 16.01.17.
//  Copyright © 2017 Den prod. All rights reserved.
//

import UIKit

class SomeUserProfileViewController: ProfileViewController {

    
    // MARK: - Outlets
    @IBOutlet weak var privateDataRequestButton: UIButton!
    
    
    
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
        setupUIElements()
    }
    
    // MARK: - General Setup
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
    
    func setupUIElements() {
        setupRequestButton()
    }
    
    
    // MARK: - UI Setup
    func setupRequestButton() {
        privateDataRequestButton.layer.borderWidth = 3
        privateDataRequestButton.layer.borderColor = UIColor.black.cgColor
        privateDataRequestButton.layer.cornerRadius = 5
    }
    
    
    // MARK: - UI Events
    @IBAction func requestPrivateData(_ sender: UIButton) {
        
        guard let nickname = nicknameLabel.text else {
            return
        }
        guard let selfNickname = defaults.value(forKey: "nickname") as! String? else {
            return
        }
        cloud.sendPrivateDataRequest(toUserWithNickname: nickname, fromUserWithNickname: selfNickname)
        
    }
    
    
    
}
