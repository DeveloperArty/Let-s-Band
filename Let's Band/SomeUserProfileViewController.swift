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
        cloud.loadLinksFor(nickname: nickname, senderViewController: self)
    }

    // UI Events
    @IBAction func instaIconTapped(_ sender: UITapGestureRecognizer) {
        
        print("insta!")
        
        if let instaNick = self.instagram {
            let url = URL(string: "https://www.instagram.com/\(instaNick)/")
            UIApplication.shared.open(url!, options: [String: Any](), completionHandler: nil)
        }
    }
    
    @IBAction func vkIconTapped(_ sender: Any) {
        
        print("vk!")
        
        if let vkNick = self.vk {
            let url = URL(string: "https://vk.com/\(vkNick)")
            UIApplication.shared.open(url!, options: [String: Any](), completionHandler: nil)
        }
    }
    
    @IBAction func fbIconTapped(_ sender: Any) {
        
        print("fb!")
        
        if let fbNick = self.facebook {
            let url = URL(string: "https://ru-ru.facebook.com/\(fbNick)")
            UIApplication.shared.open(url!, options: [String: Any](), completionHandler: nil)
        }
    }
}
