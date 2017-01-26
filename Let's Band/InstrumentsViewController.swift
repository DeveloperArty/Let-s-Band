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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var letsBandButton: UIButton!
    
    
    // MARK: - Properties
    let cloud = Cloud()
    let defaults = UserDefaults.standard
    var receivedNickname = "" {
        willSet {
            print("InstrumetsViewController has received user nickname, nickname: \(newValue)")
        }
    }
    let intrumets = ["Balalaika",
                     "Drums",
                     "Guitar",
                     "Vocal",
                     "Piano",
                     "Saxophone",
                     "Violin",
                     "Electric Guitar",
                     "Home Studio",
                     "Synth"]
    //flags
    var senderIsProfileVC = false 
    
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - UI Events
    @IBAction func letsBandButtonPressed(_ sender: UIButton) {
        
        guard let selectedInstsIndexPaths = tableView.indexPathsForSelectedRows else {
            return
        }
        var selectedInsts = [String]()
        for indexPath in selectedInstsIndexPaths {
            selectedInsts.append(self.intrumets.sorted()[indexPath.row])
        }
        if senderIsProfileVC == false {
        cloud.addUserInstruments(nickname: self.receivedNickname, instruments: selectedInsts, senderViewController: self)
        } else {
            cloud.updateUserInsts(nickname: receivedNickname, newInsts: selectedInsts, senderVC: self)
        }
        
    }
    
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 70))
        view.backgroundColor = #colorLiteral(red: 0.2894832545, green: 0.7035414203, blue: 1, alpha: 1)
        let textLabel = UILabel(frame: CGRect(x: 10, y: 30, width: 300, height: 30))
        view.addSubview(textLabel)
        textLabel.font = textLabel.font.withSize(24)
        textLabel.text = "Select your instruments"
        textLabel.textColor = UIColor.white
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
}
