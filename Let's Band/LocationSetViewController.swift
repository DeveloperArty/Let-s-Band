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
    @IBOutlet weak var popoverView: UIView!
    @IBOutlet weak var yepButton: UIButton!
    
    
    // MARK: - Properties
    let cloud = Cloud()
    // map
    var locationManager = CLLocationManager()
    // flags
    var setMapRegion = true
    var ignoreMapTap = false
    var senderIsProfileVC = false 
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
        setupUI()
        popoverView.alpha = 0
        self.mapView.isUserInteractionEnabled = false
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
    func setupUI() {
        yepButton.layer.cornerRadius = 25

    }
    
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 30
        locationManager.requestWhenInUseAuthorization()
    }
    
    func presentPopover() {
        
        DispatchQueue.main.async {
        UIView.animate(withDuration: 1,
                       delay: 2,
                       options: .curveEaseInOut,
                       animations: {
                        self.popoverView.alpha = 1
        },
                       completion: { bool in
                        self.mapView.isUserInteractionEnabled = true
        } )
        }
        
    }
    
    
    // MARK: - UIEvents
    @IBAction func userTappedMap(_ sender: UITapGestureRecognizer) {
        
        if ignoreMapTap == false {
            
            if senderIsProfileVC == false {
            
                let annotation = RegistrationAnnotation(coordinate: mapView.centerCoordinate)
                mapView.addAnnotation(annotation)
                let userCoordinateLatitude = mapView.centerCoordinate.latitude
                let userCoordinateLongitude = mapView.centerCoordinate.longitude
                userLocation = CLLocation(latitude: userCoordinateLatitude,
                                          longitude: userCoordinateLongitude)
                ignoreMapTap = true
                
            } else {
                
                let annotation = RegistrationAnnotation(coordinate: mapView.centerCoordinate)
                mapView.addAnnotation(annotation)
                let userCoordinateLatitude = mapView.centerCoordinate.latitude
                let userCoordinateLongitude = mapView.centerCoordinate.longitude
                let newUserLocation = CLLocation(latitude: userCoordinateLatitude, longitude: userCoordinateLongitude)
                cloud.updateUserLocation(nickname: self.receivedNickname,
                                         newLocation: newUserLocation,
                                         senderVC: self)
                ignoreMapTap = true
                
            }
        }
        
    }
    
    @IBAction func hidePopover(_ sender: UIButton) {
        
        popoverView.isHidden = true
        
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
