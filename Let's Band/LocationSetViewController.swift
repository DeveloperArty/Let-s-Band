//
//  LocationSetViewController.swift
//  Let's Band
//
//  Created by Artem Pavlov on 30.12.16.
//  Copyright © 2016 Den prod. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LocationSetViewController: UIViewController {
    
    
    // MARK: - Outlets 
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MARK: - Properties
    let cloud = Cloud()
    // map
    var locationManager = CLLocationManager()
    var setMapRegion = true
    var ignoreMapTap = false
    // data to save in the cloud
    var userLocation: CLLocation? {
        willSet {
            print("user coordinate is going to be updated")
            cloud.addUserCoordinate(nickname: receivedNickname, location: newValue!, senderViewController: self)
        }
    }
    var receivedNickname = "" {
        willSet {
            print("LocationSetViewController has received user nickname, nickname: \(newValue)")
        }
    }
    
    
    // MARK: - ViewConroller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        setUpLocationManager()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentPopover()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? InstrumentsViewController else {
            return
        }
        vc.receivedNickname = self.receivedNickname
    }
    
    
    // MARK: - Methods
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 30
        locationManager.requestWhenInUseAuthorization()
    }
    
    func presentPopover() {
        let alert = UIAlertController(title: "Set your location", message: "Other users will see you where the cat is. Once you're ready, just tap the map! You could change your location later in your profile settings", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - UIEvents
    @IBAction func userTappedMap(_ sender: UITapGestureRecognizer) {
        
        if ignoreMapTap == false {
            let annotation = RegistrationAnnotation(coordinate: mapView.centerCoordinate)
            mapView.addAnnotation(annotation)
            let userCoordinateLatitude = mapView.centerCoordinate.latitude
            let userCoordinateLongitude = mapView.centerCoordinate.longitude
            userLocation = CLLocation(latitude: userCoordinateLatitude, longitude: userCoordinateLongitude)
            ignoreMapTap = true
        }
        
    }
    
}


// MARK: - LocationManager Delegate Protocol Conformance 
extension LocationSetViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("autorization status has changed to \(status)")
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        default:
            locationManager.stopUpdatingLocation()
            mapView.showsUserLocation = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count == 1 && setMapRegion == true {
            let region = MKCoordinateRegionMakeWithDistance(locations.first!.coordinate, 300, 300)
            mapView.setRegion(region, animated: true)
            setMapRegion = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("an error occured while updating user location; error: \(error.localizedDescription)")
    }
    
    
}
