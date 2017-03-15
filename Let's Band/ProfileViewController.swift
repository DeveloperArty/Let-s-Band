//
//  ProfileViewController.swift
//  Let's Band
//
//  Created by Artem Pavlov on 23.12.16.
//  Copyright © 2016 Den prod. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    
    //MARK: - Outlets
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var instScrollView: UIScrollView!
    @IBOutlet weak var nameSurnameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var addInfoTextView: UITextView!
    @IBOutlet weak var addInfoBackgroundView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var linksView: UIView!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var changeLocatioButton: UIButton!
    @IBOutlet weak var editInstsButton: UIButton!
    
    
    // MARK: - Properties
    // Cloud
    let defaults = UserDefaults()
    let cloud = Cloud()
    // for UI update
    var userInsts: [String]? = nil {
        willSet {
            print("user insts loaded; new value: \(newValue!)")
            self.showInsts(instruments: newValue!)
        }
    }
    var nameSurname: String? {
        willSet {
            print("Name Surname: \(newValue)")
            DispatchQueue.main.async {
                self.nameSurnameLabel.text = newValue!
            }
        }
    }
    var age: Int? {
        willSet {
            print("age: \(newValue)")
            DispatchQueue.main.async {
                self.ageLabel.text = "\(newValue!) y.o."
            }
        }
    }
    var addInfo: String? {
        willSet {
            DispatchQueue.main.async {
                self.addInfoTextView.text = newValue! 
            }
        }
    }
    var mail: String? {
        willSet {
            DispatchQueue.main.async {
                self.mailLabel.text = newValue! 
            }
        }
    }
    
    var instagram: String?
    var vk: String?
    var facebook: String?
    
    
    // Flags
    var userIsEditingNow = false

    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUserInfo()
        setupUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let nicknameFromDef = defaults.value(forKey: "nickname") as! String? else {
            return
        }
        if let vc = segue.destination as? LocationSetViewController {
            vc.senderIsProfileVC = true
            vc.receivedNickname = nicknameFromDef
        } else if let vc = segue.destination as? InstrumentsViewController {
            vc.senderIsProfileVC = true
            vc.receivedNickname = nicknameFromDef 
        }
        
    }
    
    
    // MARK: - Setup
    func setupUI() {
        addInfoTextView.isUserInteractionEnabled = false
        addInfoTextView.layer.cornerRadius = 0
        
        linksView.layer.cornerRadius = 0
        
        if editButton != nil {
            editButton.layer.cornerRadius = 10 
        }
        
        if changeLocatioButton != nil {
            changeLocatioButton.layer.cornerRadius = 10
            changeLocatioButton.isEnabled = false
            changeLocatioButton.isHidden = true
        }
        if editInstsButton != nil {
            editInstsButton.layer.cornerRadius = 10
            editInstsButton.layer.borderColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1).cgColor
            editInstsButton.layer.borderWidth = 5
            editInstsButton.isEnabled = false
            editInstsButton.isHidden = true
        }
    }
    
    func updateUserInfo() {
        loadNickname()
        loadInstruments()
        loadNameSurname()
        loadAge()
        loadAddInfo()
        loadLinks()
    }
    
    func loadNickname() {
        nicknameLabel.text = defaults.value(forKey: "nickname") as! String?
    }
    
    func loadInstruments() {
        guard let nicknameFromDef = defaults.value(forKey: "nickname") as! String? else {
            return
        }
        cloud.loadInstruments(nickname: nicknameFromDef, senderViewController: self)
    }
    
    func loadNameSurname() {
        guard let nicknameFromDef = defaults.value(forKey: "nickname") as! String? else {
            return
        }
        cloud.loadNameSurnameFor(nickname: nicknameFromDef, senderViewController: self)
    }
    
    func loadAge() {
        guard let nicknameFromDef = defaults.value(forKey: "nickname") as! String? else {
            return
        }
        cloud.loadAgeFor(nickname: nicknameFromDef, senderViewController: self)
    }
    
    func loadAddInfo() {
        guard let nicknameFromDef = defaults.value(forKey: "nickname") as! String? else {
            return
        }
        cloud.loadAddInfoFor(nickname: nicknameFromDef, senderViewController: self)
    }
    
    func loadLinks() {
        guard let nicknameFromDef = defaults.value(forKey: "nickname") as! String? else {
            return
        }
        cloud.loadLinksFor(nickname: nicknameFromDef, senderViewController: self)
    }
    
    func showInsts(instruments: [String]) {
        
            DispatchQueue.main.async {
                self.instScrollView.contentSize = CGSize(width: instruments.count * 90, height: 90)
                
                for (index, instrument) in instruments.enumerated() {
                    
                    let instView = UIImageView(frame: CGRect(x:  700, y: 0, width: 90, height: 90))
                    instView.image = UIImage(named: instrument)
                    self.instScrollView.addSubview(instView)
                    
                    UIView.animate(withDuration: 2,
                                   delay: Double(Int(arc4random_uniform(20))/10),
                                   options: UIViewAnimationOptions.curveEaseInOut,
                                   animations: {
                                    instView.frame = CGRect(x: 90 * index, y: 0, width: 90, height: 90)
                    },
                                   completion: nil)
                    
                }
            }
    }
    
    
    
    
    // MARK: - UI Events
    @IBAction func logOut(_ sender: UIButton) {
        let alert = UIAlertController(title: "Are you shure?", message: "We will miss you!", preferredStyle: .actionSheet)
        let actionOut = UIAlertAction(title: "Yep, I'm shure", style: .destructive, handler: { acto in
            self.defaults.set("-", forKey: "nickname")
            self.performSegue(withIdentifier: "LogOut", sender: nil)
        })
        let actionCancel = UIAlertAction(title: "Never mind..", style: .cancel, handler: nil)
        alert.addAction(actionOut)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func editProfile(_ sender: UIButton) {
        
        if userIsEditingNow == false {
            DispatchQueue.main.async {
                self.editButton.setTitle("Done", for: .normal)
                self.editButton.backgroundColor = UIColor.black
                
                self.addInfoTextView.isUserInteractionEnabled = true
            
                let mailRect = self.mailLabel.frame
                let textField = UITextField(frame: mailRect)
                textField.layer.cornerRadius = 10 
                self.linksView.addSubview(textField)
                textField.placeholder = "  mail"
                textField.backgroundColor = UIColor.white
                textField.textColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
                
                self.addInfoBackgroundView.backgroundColor = UIColor.white
                self.addInfoTextView.textColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
                
                self.userIsEditingNow = true
                
                self.editInstsButton.isEnabled = true
                self.editInstsButton.isHidden = false
                
                self.changeLocatioButton.isEnabled = true
                self.changeLocatioButton.isHidden = false
            }
        } else {
                DispatchQueue.main.async {
                    
                    self.editButton.setTitle("Edit", for: .normal)
                    self.editButton.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
                    
                    self.addInfoTextView.isUserInteractionEnabled = false
                    
                    guard let nicknameFromDef = self.defaults.value(forKey: "nickname") as! String? else {
                        return
                    }
                    
                    
                    if let textField = self.linksView.subviews.last as? UITextField {
                        if textField.text != "" && textField.text != nil {
                            print("new mail")
                            let newMail = textField.text!
                            self.cloud.updateUserMail(nickname: nicknameFromDef,
                                                 newMail: newMail,
                                                 senderViewController: self)
                        }
                        textField.removeFromSuperview()
                    }
                    
                    
                    if self.addInfoTextView.text != self.addInfo && self.addInfoTextView.text != nil {
                        self.cloud.updateUserAddInfo(nickname: nicknameFromDef,
                                                newInfo: self.addInfoTextView.text,
                                                senderViewController: self)
                    }
                    self.addInfoBackgroundView.backgroundColor = #colorLiteral(red: 0.273993969, green: 0.7009065747, blue: 0.9813830256, alpha: 1)
                    self.addInfoTextView.textColor = UIColor.white
                    
                    self.addInfoTextView.text = self.addInfo
                    
                    self.userIsEditingNow = false
                    
                    self.editInstsButton.isEnabled = false
                    self.editInstsButton.isHidden = true
                    
                    
                    self.changeLocatioButton.isEnabled = false
                    self.changeLocatioButton.isHidden = true
            }
        }
        
    }
    
    @IBAction func backgroundTap(_ sender: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
        
    }
}
