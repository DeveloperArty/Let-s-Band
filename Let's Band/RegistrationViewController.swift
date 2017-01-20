//
//  RegistrationViewController.swift
//  Let's Band
//
//  Created by Artem Pavlov on 21.12.16.
//  Copyright © 2016 Den prod. All rights reserved.
//

import UIKit
import MapKit

class RegistrationViewController: UIViewController {
    
    
    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    
    @IBOutlet weak var nicknameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmation: UITextField!
    
    @IBOutlet weak var mailField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var addInfoTextView: UITextView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - Propreties
    let cloud = Cloud()
    var nicknameToSendFarther: String = "" {
        willSet {
            print("ntsf: \(newValue)")
        }
    }
    
    
    // MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? LocationSetViewController else {
            return
        }
        vc.receivedNickname = nicknameToSendFarther
    }
    
    
    // MARK: - Setup
    func setupUI() {
        
        nextButton.layer.cornerRadius = 10
        
    }
    
    
    // MARK: - UI Events
    @IBAction func backgroundTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
        guard let name = nameField.text else {
            nameField.layer.borderWidth = 2
            nameField.layer.borderColor = UIColor.red.cgColor
            return
        }
        guard let surname = surnameField.text else {
            surnameField.layer.borderWidth = 2
            surnameField.layer.borderColor = UIColor.red.cgColor
            return
        }
        guard let nickname = nicknameField.text else {
            nicknameField.layer.borderWidth = 2
            nicknameField.layer.borderColor = UIColor.red.cgColor
            return
        }
        self.nicknameToSendFarther = nickname
        guard let password = passwordField.text else {
            passwordField.layer.borderWidth = 2
            passwordField.layer.borderColor = UIColor.red.cgColor
            return
        }
        guard let mail = mailField.text else {
            mailField.layer.borderWidth = 2
            mailField.layer.borderColor = UIColor.red.cgColor
            return
        }
        let dateOfBirth = datePicker.date
        
        guard let addInfo = addInfoTextView.text else {
            return 
        }
        
        cloud.registerNewUser(name: name,
                              surname: surname,
                              dateOfBirth: dateOfBirth,
                              nickname: nickname,
                              password: password,
                              mail: mail,
                              additionalInformation: addInfo,
                              senderViewController: self)
        
        
    }
    
    
}
