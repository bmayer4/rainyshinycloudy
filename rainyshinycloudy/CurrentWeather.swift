//
//  CurrentWeather.swift
//  rainyshinycloudy
//
//  Created by Brett Mayer on 6/25/17.
//  Copyright © 2017 Devslopes. All rights reserved.
//

import UIKit
import Alamofire

class CurrentWeather {
    private var _cityName: String!
    private var _date: String!
    private var _weatherType: String!
    private var _currentTemp: Double!
    
    var cityName: String {
        if _cityName == nil {
            _cityName = "somecity"
        }
        return _cityName
    }
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        let df = DateFormatter()
        df.dateStyle = .long
        df.timeStyle = .none
        let currentDate = df.string(from: Date())
        self._date = "Today, \(currentDate)"
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = "someweathertype"
        }
        return _weatherType
    }
    
    var currentTemp: Double {
        if _currentTemp == nil {
            _currentTemp = 100.0
        }
        return _currentTemp
    }
    
    func downloadWeatherDetails(completedd: @escaping DownloadComplete) {
        //Alamofire download
        Alamofire.request(CURRENT_WEATHER_URL).responseJSON { response in
            let result = response.result  //came in as a dictionary of dictionaries
            print(result.value!)
            if let dict = result.value as?  Dictionary<String, Any> {  //could have done [String:Any]
                if let name = dict["name"] as? String {
                    self._cityName = name.capitalized
                    print(self._cityName)
                    }
                if let weather = dict["weather"] as? [Dictionary<String, Any>] {
                    if let main = weather[0]["main"] as? String {
                        self._weatherType = main.capitalized
                        print(self._weatherType)
                        }
                    }
                if let main = dict["main"] as? Dictionary<String, Any> {
                    if let currentTemp = main["temp"] as? Double {
                        //in kelvin as default
                        let kelvinToFarenheit = round((currentTemp * (9/5) - 459.67))  //this is the formula
                        self._currentTemp = kelvinToFarenheit
                        print(self._currentTemp)
                            }
                        }
                    }
             completedd()
        }  //end Alamofire.request
        }  //end func

    
} //end CurrentWeather
