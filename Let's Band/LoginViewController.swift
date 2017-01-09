//
//  LoginViewController.swift
//  Let's Band
//
//  Created by Artem Pavlov on 21.12.16.
//  Copyright © 2016 Den prod. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    // MARK: - Outlets
    @IBOutlet weak var nicknameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    //MARK: - Properties
    let cloud = Cloud()
    var logInIsSucsessfull = false
    let defaults = UserDefaults()
    
    
    // MARK: - ViewController Lifecycle 
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkIfLogedIn()
    }

    
    // MARK: - Methods
    func checkIfLogedIn() {
        let nickname = defaults.value(forKey: "nickname")
        if  nickname == nil || nickname as? String == "-" {
            print("log in required, nickname: \(nickname)")
            return
        } else {
            print("log in not required, nickname: \(nickname)")
            self.performSegue(withIdentifier: "SuccessfullLogIn", sender: nil)
        }
    }
    
    
    // MARK: - UI Events
    @IBAction func backgroundTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func logInButtonPressed(_ sender: UIButton) {
        guard let nickname = nicknameField.text else {
            return
        }
        guard let password = passwordField.text else {
            return
        }
        cloud.logIn(userNickname: nickname, userPassword: password, senderViewController: self)
    }
    
    
}
