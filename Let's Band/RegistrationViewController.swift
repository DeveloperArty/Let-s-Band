//
//  RegistrationViewController.swift
//  Let's Band
//
//  Created by Artem Pavlov on 21.12.16.
//  Copyright © 2016 Den prod. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    // MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - UI Events
    @IBAction func backgroundTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}
