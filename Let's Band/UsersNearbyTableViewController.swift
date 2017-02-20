//
//  UsersNearbyTableViewController.swift
//  Let's Band
//
//  Created by Artem Pavlov on 15.02.17.
//  Copyright © 2017 Den prod. All rights reserved.
//

import UIKit
import CoreLocation

class UsersNearbyTableViewController: UITableViewController {

    // MARK: - Proprties
    let locationManager = CLLocationManager()
    let cloud = Cloud()
    var users = [Int: [(inst: String, nickname: String)]]() {
        willSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var users1 = [(inst: String, nickname: String)]() {
        willSet {
            users[0] = newValue
        }
    }
    var users3n1 = [(inst: String, nickname: String)]() {
        willSet {
            users[1] = newValue 
        }
    }
    var users5n3 = [(inst: String, nickname: String)]() {
        willSet {
            users[2] = newValue
        }
    }
    var users5 = [(inst: String, nickname: String)]() {
        willSet {
            users[3] = newValue
        }
    }
    // flags
    var needToUpdateLoc = true
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpLocationManager()
        print("did load table Vc")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let vc = segue.destination as? SomeUserProfileViewController else {
            return
        }
        vc.receivedNickname = sender as? String
        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if users[section] == nil {
            return 1
        } else {
            return users[section]!.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "someUserCell", for: indexPath) as! UserNearbyTableViewCell
        if users[indexPath.section] != nil {
            let userData = users[indexPath.section]?[indexPath.row]
            cell.nicknameLabel.text = userData?.nickname
            cell.instImageView.image = UIImage(named: (userData?.inst)!)
        }
        return cell
    }
    
    // MARK: - Table view delegate 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nickname = users[indexPath.section]?[indexPath.row].nickname
        self.performSegue(withIdentifier: "ShowThatUserAccount", sender: nickname)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "less than 1 km"
        } else if section == 1 {
            return "between 1 and 3 km"
        } else if section == 2 {
            return "between 3 and 5 km"
        } else {
            return "more than 5 km"
        }
    }
 
    // MARK: - Setup
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 30
    }

}


extension UsersNearbyTableViewController: CLLocationManagerDelegate {
    
    // MARK: LocMan Delegate Methods
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("autorisation status has changed to \(status)")
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print("started")
//            locationManager.startUpdatingLocation()
        default:
            print("stopped")
//            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if needToUpdateLoc == true {
            guard let location = locations.first else {
                print("no loc")
                return
            }
            print("locman has updted loc")
            cloud.findOtherUsersWithDistance(distance: 1000,
                                             userLocation: location,
                                             senderViewController: self)
//            needToUpdateLoc = false 
//        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("an error occured; error: \(error.localizedDescription)")
    }
    
}

