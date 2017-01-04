//
//  InstrumentsViewController.swift
//  Let's Band
//
//  Created by Artem Pavlov on 01.01.17.
//  Copyright © 2017 Den prod. All rights reserved.
//

import UIKit

class InstrumentsViewController: UIViewController {

    
    // MARK: - Outlets
    
    
    // MARK: - Properties
    let cloud = Cloud()
    var receivedNickname = "" {
        willSet {
            print("InstrumetsViewController has received user nickname, nickname: \(newValue)")
        }
    }
    
    
}
