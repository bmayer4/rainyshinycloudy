//
//  Location.swift
//  rainyshinycloudy
//
//  Created by Brett Mayer on 7/1/17.
//  Copyright © 2017 Devslopes. All rights reserved.
//

import Foundation
import CoreLocation

class Location {
    static var sharedInstance = Location() //singleton class

    private init() {}  ////This prevents others from using the default '()' initializer for this class.
    
    var latitude: Double!
    var longitude: Double!
    
}
