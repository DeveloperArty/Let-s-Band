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
    
    
    // MARK: - ViewController Lifecycle 
    override func viewDidLoad() {
        super.viewDidLoad()
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
