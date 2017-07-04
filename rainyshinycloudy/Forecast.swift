//
//  Forecast.swift
//  rainyshinycloudy
//
//  Created by Brett Mayer on 6/27/17.
//  Copyright © 2017 Devslopes. All rights reserved.
//

enum ForecastResult {
    case success([Forecast])
    case failure(Error)
}


import UIKit
import Alamofire

class Forecast {
    private var _date: String!
    private var _weatherType: String!
    private var _highTemp: String!
    private var _lowTemp: String!
    
    //var weatherVC: WeatherVC!  now I don't need an instance of my vc, bad practice, used callback instead
    
    init() {}
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var highTemp: String {
        if _highTemp == nil {
            _highTemp = ""
        }
        return _highTemp
    }
    
    var lowTemp: String {
        if _lowTemp == nil {
            _lowTemp = ""
        }
        return _lowTemp
    }
    

        init(weatherDict: Dictionary<String, Any>) {
        if let temp = weatherDict["temp"] as? Dictionary<String, Any> {
        if let min = temp["min"] as? Double {
            let kelvinToFarenheit = round((min * (9/5) - 459.67))
            self._lowTemp = "\(kelvinToFarenheit)"
            (print(self._lowTemp))
            }
            
        if let max = temp["max"] as? Double {
            let kelvinToFarenheit = round((max * (9/5) - 459.67))
            self._highTemp = "\(kelvinToFarenheit)"
            print(self._highTemp)
            }
    
        }
        
        if let weather = weatherDict["weather"] as? [Dictionary<String, Any>] {
            if let main = weather[0]["main"] as? String {
                self._weatherType = main
                }
        }
        
        if let date = weatherDict["dt"] as? Double {
            let unixConvertedDate = Date(timeIntervalSince1970: date)
            let df = DateFormatter()
            df.dateStyle = .full
            df.dateFormat = "EEEE"
            df.timeStyle = .none
            self._date = unixConvertedDate.dayOfheWeek()
        }
    }
    

func downloadForecastData(completed: @escaping (ForecastResult) -> Void) {
    Alamofire.request(FORECAST_URL).responseJSON() { response in
        let result = response.result
        print(result.value!)
        var forecastJSON = [Forecast]()
        
        do {
        if let dict = result.value as? Dictionary<String, Any> {
            if let list = dict["list"] as? [Dictionary<String, Any>] {
                for obj in list {
                    print(obj)
                    let forecast = Forecast(weatherDict: obj)
                     forecastJSON.append(forecast)
                    }
                }
            }
            completed(.success(forecastJSON))  //inside Alamofire block
        }
        catch let err {
            print("Error: \(err)")
            completed(.failure(err))
        }

    }
}
    
    
}


extension Date {
    func dayOfheWeek() -> String {
        let df = DateFormatter()
        df.dateFormat = "EEEE"
        return df.string(from: self)  //self is then going to be unixConvertedDate
    }
}

