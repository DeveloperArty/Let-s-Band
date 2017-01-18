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
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var dontHaveLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    
    
    //MARK: - Properties
    let cloud = Cloud()
    var logInIsSucsessfull = false
    let defaults = UserDefaults()
    
    
    // MARK: - ViewController Lifecycle 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkIfLogedIn()
    }

    
    // MARK: - UI Setup
    func setupUI() {
        setupBackground()
        setupTextFields()
        setupLogInButton()
        setupDontHaveLabel()
        setupImageView()
    }
    
    func setupBackground() {
        view.backgroundColor = #colorLiteral(red: 0.2894832545, green: 0.7035414203, blue: 1, alpha: 1)
    }
    
    func setupTextFields() {
        nicknameField.borderStyle = .roundedRect
        passwordField.borderStyle = .roundedRect
    }
    
    func setupLogInButton() {
        logInButton.layer.cornerRadius = 10
        logInButton.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
    }
    
    func setupDontHaveLabel() {
        dontHaveLabel.textColor = UIColor.white
    }
    
    func setupImageView() {
        logoImageView.layer.cornerRadius = 15
        logoImageView.layer.borderColor = UIColor.white.cgColor
        logoImageView.layer.borderWidth = 3
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
