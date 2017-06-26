//
//  Constants.swift
//  rainyshinycloudy
//
//  Created by Brett Mayer on 6/25/17.
//  Copyright © 2017 Devslopes. All rights reserved.
//

import Foundation

let BASE_URL = "http://samples.openweathermap.org/data/2.5/weather?"
let LATITUDE = "lat="
let LONGITUDE = "&lon="
let APP_ID = "&appid="
let API_KEY = "95edc136f4d3da6b9a6a006d56581fad"

typealias DownloadComplete = () -> ()

let CURRENT_WEATHER_URL = "\(BASE_URL)\(LATITUDE)-36\(LONGITUDE)123\(APP_ID)\(API_KEY)"

func CWU(lat: Int, long: Int) -> String {
    return "\(BASE_URL)\(LATITUDE)" + "\(lat)" + "\(LONGITUDE)" + "\(long)" + "\(APP_ID)\(API_KEY)"
}

