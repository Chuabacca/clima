//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation


class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    //Constants
    var cityParam = ""
    var stateParam = ""
    let weatherApi = "http://api.wunderground.com/api/32a6a9aecbf0859b/conditions/q/cupertino.json"


    //TODO: Declare instance variables here
    //This creates a new object from the location manager class
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()

    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO:Set up the location manager here.

        //This decalres that the WeatherViewController is the delegate of the CLLocationManager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:

    func setWeatherAPICall() -> String {
        return "http://api.wunderground.com/api/32a6a9aecbf0859b/conditions/q/\(stateParam)/\(cityParam).json"
    }
    

    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()

            //Debug
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")


            geocoder.reverseGeocodeLocation(location) { (placemark, error) in
                if placemark != nil {
                    let placemarkString = String(describing: placemark![0])
                    let placemarkArray = placemarkString.components(separatedBy: ", ")
                    let cityName = placemarkArray[2]
                    self.cityParam = cityName.components(separatedBy: " ")[0] + "_" + cityName.components(separatedBy: " ")[1]
                    let state = placemarkArray[3]
                    self.stateParam = state.components(separatedBy: " ")[0]

                    //Debug
                    print(self.cityParam)
                    print(self.stateParam)
                    print(self.setWeatherAPICall())

                }
                else {
                    print(error!)
                    return
                }

            }


        }

    }


    //Write the didFailWithError method here:
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    

    
    //Write the PrepareForSegue Method here
    
    
    
    
    
}


