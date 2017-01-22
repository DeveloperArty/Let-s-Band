//
//  GreetingViewController.swift
//  Let's Band
//
//  Created by Artem Pavlov on 21.12.16.
//  Copyright © 2016 Den prod. All rights reserved.
//

import UIKit

class GreetingViewController: UIViewController {

    
    // MARK: - UI Outlets
    @IBOutlet weak var yepButton: UIButton!
    @IBOutlet weak var myPhotoImageView: UIImageView!
    
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    // MARK: - UI Setup
    func setupUI() {
        yepButton.layer.cornerRadius = 30
    }
    
}
