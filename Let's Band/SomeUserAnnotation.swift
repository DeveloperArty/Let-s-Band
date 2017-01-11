//
//  SomeUserAnnotation.swift
//  Let's Band
//
//  Created by Artem Pavlov on 10.01.17.
//  Copyright © 2017 Den prod. All rights reserved.
//

import UIKit
import MapKit

class SomeUserAnnotation: NSObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D
    var userName: String?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
}
