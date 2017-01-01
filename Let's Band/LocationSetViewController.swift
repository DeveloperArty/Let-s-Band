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

    var userLocation: CLLocation? {
        willSet {
            print("user coordinate is going to be updated")
            cloud.addUserCoordinate(nickname: receivedNickname, location: newValue!)
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
    
    
    // MARK: - Methods
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 30
        locationManager.requestWhenInUseAuthorization()
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
