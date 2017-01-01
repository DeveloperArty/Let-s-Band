//
//  RegistrationAnnotation.swift
//  Let's Band
//
//  Created by Artem Pavlov on 31.12.16.
//  Copyright © 2016 Den prod. All rights reserved.
//

import UIKit
import MapKit

class RegistrationAnnotation: NSObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        title = "Other users will see you here"
    }
    
}
