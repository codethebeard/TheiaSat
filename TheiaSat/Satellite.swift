//
//  Satellite.swift
//  TheiaSat
//
//  Created by Michael VanDyke on 6/1/19.
//  Copyright © 2019 Michael VanDyke. All rights reserved.
//

import Foundation
import MapKit

class Satellite: NSObject, MKAnnotation {
    let name: String
    var altitude: Double
    var coordinate: CLLocationCoordinate2D
    
    init(name: String, coordinate: CLLocationCoordinate2D, altitude: Double) {
        self.name = name
        self.coordinate = coordinate
        self.altitude = altitude
    }
    
    var subtitle: String? {
        return nil
    }
    
    var title: String? {
        return self.name
    }
}
