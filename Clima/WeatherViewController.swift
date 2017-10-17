//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire


class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    //Constants
    var cityParam = ""
    var stateParam = ""

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

    func callAPI() {
        let url = "http://api.wunderground.com/api/32a6a9aecbf0859b/conditions/q/\(stateParam)/\(cityParam).json"
        print(url)
        Alamofire.request(url).responseJSON { response in
            guard response.result.isSuccess else {
                return
            }
            //Debug
            print(response.result.value!)
            do {
                let decoder = JSONDecoder()
                let resp = try decoder.decode(WeatherData.self, from: response.data!)
                //Debug
                print("Temp: \(resp.currentObservation.tempF) F")
                self.temp = resp.currentObservation.tempF
                self.updateUIWithWeatherData()
            }
            catch {
                print("Error: \(error)")
            }
        }

    }

    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/

    struct WeatherData: Codable {
        struct CurrentObservation: Codable {
            let tempF: Double
            enum CodingKeys: String, CodingKey {
                case tempF = "temp_f"
            }
        }

        let currentObservation: CurrentObservation
        enum CodingKeys: String, CodingKey {
            case currentObservation = "current_observation"
        }
    }
    
    //Write the updateWeatherData method here:
    

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    
    func updateUIWithWeatherData() {
        temperatureLabel.text = "\(Int(temp))°"
        cityLabel.text = cityName
    }
    
    
    
    
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
                    self.cityName = placemarkArray[2]
                    self.cityParam = self.cityName.components(separatedBy: " ")[0] + "_" + self.cityName.components(separatedBy: " ")[1]
                    let state = placemarkArray[3]
                    self.stateParam = state.components(separatedBy: " ")[0]
                    self.callAPI()

                    //Debug
                    print(self.cityParam)
                    print(self.stateParam)

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

    func userEnteredANewCityName(city: String) {
        <#code#>
    }
    
    //Write the PrepareForSegue Method here

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destinationVC = segue.destination as! ChangeCityViewController
            destinationVC.delegate = self
        }
    }
    
    
    
    
    
}


