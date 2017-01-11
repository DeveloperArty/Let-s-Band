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

class MapViewController: UIViewController {
    
    
    // MARK: - Outlets
    @IBOutlet weak var mainMap: MKMapView!
    @IBOutlet weak var distanceField: UITextField!
    
    
    // MARK: - Properties 
    // map setup
    var locationManager = CLLocationManager()
    var setMapRegion = true
    // cloud
    let cloud = Cloud()
    // map objects
    var annotationsToShow: [MKAnnotation?] = [] {
        willSet {
            guard newValue.isEmpty == false else {
                print("no annotations to add")
                return
            }
            print("annotationsToShow: \(newValue.count)")
            mainMap.addAnnotations(newValue as! [MKAnnotation])
        }
    }
    
    
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
    
    
    // testing
    @IBAction func tapToGo(_ sender: UITapGestureRecognizer) {
        
        view.endEditing(true)
        
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


// MARK: - MapView Delegate Methods
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        } 
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "SomeUser")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "SomeUser")
        } else {
            annotationView?.annotation = annotation
        }

        annotationView?.image = UIImage(named: "Balalaika")
        return annotationView
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        
        print("mapViewDidFinishRenderingMap")
        
        let currentRegion = mapView.region
        let distanceInMeters = currentRegion.span.latitudeDelta * 111 * 1000
        let centerScreenLocation = CLLocation(latitude: currentRegion.center.latitude,
                                              longitude: currentRegion.center.longitude)
        cloud.findOtherUsersWithDistance(distance: distanceInMeters,
                                         userLocation: centerScreenLocation,
                                         senderViewController: self)
        
    }
    
}
