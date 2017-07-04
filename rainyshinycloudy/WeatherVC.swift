//
//  WeatherVC.swift
//  rainyshinycloudy
//
//  Created by Brett Mayer on 6/24/17.
//  Copyright © 2017 Devslopes. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class WeatherVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherTypeLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!

    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var currentWeather: CurrentWeather!
    var forecast: Forecast!
    var forecasts = [Forecast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        tableView.delegate = self
        tableView.dataSource = self
    
        currentWeather = CurrentWeather()  //should do di for this
        forecast = Forecast()
    }
    
    override func viewDidAppear(_ animated: Bool) {  //appears before we download are weather details
        super.viewDidAppear(animated)
        locationAuthStatus()
        }
    
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude  //loca is accessible from anywhr in app
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            print(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
            currentWeather.downloadWeatherDetails {  //want location to be set before we run this
                self.forecast.downloadForecastData { (result) -> Void in
                    switch result {
                    case let .success(res):
                    self.forecasts = res
                    case let .failure(err):
                        print("Error: \(err)")
                    }
                    self.forecasts.remove(at: 0)
                    self.tableView.reloadData()  //wouldn't want to do this stuff in Forecast
                    self.updateMainUI()
                }
            }
                } else {
            locationManager.requestWhenInUseAuthorization()
            locationAuthStatus()
        }
    }
    
//    func downloadForecastData(completed: @escaping DownloadComplete) {  //THIS IS TEACHERS WAY
//        //downloading weather forecast data for tableview (teacher said put this in this file since table views are here..)
//        Alamofire.request(FORECAST_URL).responseJSON { response in
//            let result = response.result
//            print(result.value!)
//            
//            if let dict = result.value as? Dictionary<String, Any> {
//                if let list = dict["list"] as? [Dictionary<String, Any>] {
//                    for obj in list {
//                        let forecast = Forecast(weatherDict: obj)
//                        self.forecasts.append(forecast)
//                        print(obj)
//                    }
//                    self.forecasts.remove(at: 0)
//                    self.tableView.reloadData()
//                }
//            }
//            completed()
//        }
//        
//    }

    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1  //default value, not required method
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherCell {
            let forecast = forecasts[indexPath.row]
            cell.configureCell(forecast: forecast)
            return cell
        } else {
            return WeatherCell()
        }
    }
    
    func updateMainUI() {
        dateLabel.text = currentWeather.date
        currentTempLabel.text = "\(currentWeather.currentTemp)"
        currentWeatherTypeLabel.text = currentWeather.weatherType
        locationLabel.text = currentWeather.cityName
        currentWeatherImage.image = UIImage(named: currentWeather.weatherType) //images were cleverly named
        }

}

