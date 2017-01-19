//
//  MainDataRegistrationViewController.swift
//  Let's Band
//
//  Created by Artem Pavlov on 19.01.17.
//  Copyright © 2017 Den prod. All rights reserved.
//

import UIKit

class MainDataRegistrationViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    let userDataTypes = ["Name",
                         "Surname",
                         "Password",
                         "Confirm Password",
                         "Mail"]
    
    let placeholders = ["requested","optional","requested","requested","requested"]
    
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.headerView(forSection: 0)?.textLabel?.textColor = UIColor.white
    }

}


// MARK: - TableView DataSource Methods
extension MainDataRegistrationViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return userDataTypes.count
        } else {
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionOneCell", for: indexPath) as! RegistrationTableViewCell
            cell.dataTypeLabel?.text = userDataTypes[indexPath.row]
            cell.dataTextField.borderStyle = .none
            cell.dataTextField.placeholder = placeholders[indexPath.row]
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionTwoCell", for: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionTreeCell", for: indexPath)
            return cell
        }
    }
    
}


// MARK: - TableView Delegate Methods 
extension MainDataRegistrationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Now let us know something about you"
        } else if section == 1 {
            return "Birth Date"
        }else {
            return "Additional Information"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }

}
