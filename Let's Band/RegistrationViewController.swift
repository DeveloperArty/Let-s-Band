//
//  RegistrationViewController.swift
//  Let's Band
//
//  Created by Artem Pavlov on 21.12.16.
//  Copyright © 2016 Den prod. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    
    // MARK: - Outlets
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var nicknameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmation: UITextField!
    @IBOutlet weak var mailField: UITextField!
    
    
    // MARK: - Class Propreties
    let cloud = Cloud()
    
    
    // MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    // MARK: - UI Events
    @IBAction func backgroundTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func letsBandButtonPressed(_ sender: UIButton) {
        guard let name = nameField.text else {
            return
        }
        guard let surname = surnameField.text else {
            return
        }
        guard let nickname = nicknameField.text else {
            return
        }
        guard let password = passwordField.text else {
            return
        }
        guard let mail = mailField.text else {
            return
        }
        let dateOfBirth = datePicker.date
        cloud.registerNewUser(name: name, surname: surname, dateOfBirth: dateOfBirth, nickname: nickname, password: password, mail: mail,senderViewController: self)
    }
    
    
}
