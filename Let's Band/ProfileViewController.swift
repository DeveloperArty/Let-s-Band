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
    
    
    // MARK: - Properties
    let defaults = UserDefaults()
    let cloud = Cloud()
    var userInsts: [String]? = nil {
        willSet {
            print("user insts loaded; new value: \(newValue!)")
            self.showInsts(instruments: newValue!)
        }
    }
    

    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUserInfo()
    }
    
    
    // MARK: - Setup
    func updateUserInfo() {
        loadNickname()
        loadInstruments()
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
        defaults.set("-", forKey: "nickname")
        self.performSegue(withIdentifier: "LogOut", sender: nil)
    }

    
}
