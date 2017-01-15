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
        
        self.navigationItem.title = "Map"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let vc = segue.destination as? SomeUserProfileViewController else {
            return
        }
        vc.receivedNickname = sender as? String
        
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


// MARK: - MapView Delegate Methods
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // ignore user location annotation
        if annotation is MKUserLocation {
            return nil
        }
        // that's what is needed
        else if annotation is SomeUserAnnotation {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "SomeUser")
        if annotationView == nil {
            annotationView = SomeUserAnnotationView(annotation: annotation, reuseIdentifier: "SomeUser")
        } else {
            annotationView?.annotation = annotation
        }
            let ann = annotation as! SomeUserAnnotation
            let mainInstName = ann.mainInstrument!
            annotationView?.canShowCallout = true
            
            // resizing image for annotation view
            let requiredImage = UIImage(named: mainInstName)
            let size = CGSize(width: 60, height: 60)
            UIGraphicsBeginImageContext(size)
            requiredImage?.draw(in: CGRect(x: 0, y: 0, width: 60, height: 60))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            annotationView?.image = resizedImage
            
            return annotationView
        }
        // ignore 
        else {
            return nil
        }
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let someUserAnnView = view as? SomeUserAnnotationView else {
            print("not SomeUserAnnotationView selected")
            return
        }
        let someUserAnn = someUserAnnView.annotation as! SomeUserAnnotation
        let userNickname = someUserAnn.userName
        print("SomeUserAnnotationView selected, nickname: \(userNickname)")
        self.performSegue(withIdentifier: "ShowThatUserAccount", sender: userNickname)

    }
    
}
