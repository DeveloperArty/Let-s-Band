//
//  ProfileViewController.swift
//  Let's Band
//
//  Created by Artem Pavlov on 23.12.16.
//  Copyright © 2016 Den prod. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    
    // MARK: - Properties
    let defaults = UserDefaults()
    

    // MARK: - UI Events
    @IBAction func logOut(_ sender: UIButton) {
        defaults.set(nil, forKey: "nickname")
        self.performSegue(withIdentifier: "LogOut", sender: nil)
    }

    
}
