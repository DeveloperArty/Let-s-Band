//
//  MapViewController.swift
//  Let's Band
//
//  Created by Artem Pavlov on 23.12.16.
//  Copyright © 2016 Den prod. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, UISplitViewControllerDelegate {
    
    
    // MARK: - Outlets
    @IBOutlet weak var mainMap: MKMapView!
    
    
    // MARK: - Properties 
    var locationManager = CLLocationManager()
    var setMapRegion = true
    
    
    // MARK: - ViewController Lifecycle
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
    
}


// MARK: - LocationManager Delegate Protocol Conformance
extension MapViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("autorisation status has changed to \(status)")
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            mainMap.showsUserLocation = true
        default:
            locationManager.startUpdatingLocation()
            mainMap.showsUserLocation = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count == 1 && setMapRegion == true {
            let region = MKCoordinateRegionMakeWithDistance(locations.first!.coordinate, 300, 300)
            mainMap.setRegion(region, animated: true)
            print("region set")
            self.setMapRegion = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("an error occured; error: \(error.localizedDescription)")
    }
    
    
}
