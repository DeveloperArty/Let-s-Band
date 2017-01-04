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
    let intrumets = ["Balalaika", "Drums", "Guitar", "Vocal", "Piano", "Saxophone", "Violin", "Electric Guitar"]
    
    
    
}


// MARK: - TableView DataSource Protocol Methods
extension InstrumentsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.intrumets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InstrumentCell", for: indexPath)
        let instName = self.intrumets.sorted()[indexPath.row]
        let image = UIImage(named: instName)
        cell.imageView?.image = image
        cell.textLabel?.text = instName
        return cell 
    }
    
}


// MARK: - TableView Delegate Protocol Methods
extension InstrumentsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
}
