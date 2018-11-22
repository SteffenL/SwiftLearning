//
//  ViewController.swift
//  Clima
//
//  Created by Steffen André Langnes on 12/11/2018.
//  Copyright © 2018 Steffen André Langnes. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class MainViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    @IBOutlet weak var weatherView: UIStackView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var citylabel: UILabel!

    let apiKey = "78e473c109de0b69ddfd0bc696e96411"
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather"

    let locationManager = CLLocationManager()
    var cityOverride: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)

        updateWeatherData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCity" {
            let viewController = segue.destination as! ChangeCityViewController
            viewController.city = citylabel.text
            viewController.delegate = self
        }
    }

    @objc func willEnterForeground() {
        updateWeatherData()
    }

    @objc func didEnterBackground() {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy < 0 {
            return
        }

        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil

        print(location.coordinate)
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        updateWeatherData(latitude: latitude, longitude: longitude)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Unable to get location:", error)
    }

    func updateWeatherData() {
        if cityOverride == nil {
            fetchLocation()
        } else {
            updateWeatherData(city: cityOverride!)
        }
    }

    func updateWeatherDataForCity(_ city: String) {

    }

    func updateWeatherData(city: String) {
        let params = ["q": city, "appid": apiKey, "units": "standard"]
        fetchWeatherData(parameters: params)
    }

    func updateWeatherData(latitude: Double, longitude: Double) {
        let params = ["lat": String(latitude), "lon": String(longitude), "appid": apiKey, "units": "standard"]
        fetchWeatherData(parameters: params)
    }

    func fetchWeatherData(parameters: [String: String]) {
        Alamofire.request(weatherURL, method: .get, parameters: parameters).validate().responseJSON { (response) in
            switch (response.result) {
            case .success(let value):
                let json = SwiftyJSON.JSON(value)
                let city = json["name"].stringValue
                let temperature = json["main"]["temp"].doubleValue
                let condition = json["weather"][0]["id"].intValue

                self.updateWeatherUI(city: city, temperature: temperature, condition: condition)
            case .failure(let error):
                print("HTTP error", error)
            }
        }
    }

    func cityWasChanged(city: String) {
        cityOverride = city.isEmpty ? nil : city
    }

    @IBAction func changeCityPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "changeCity", sender: self)
    }

    func fetchLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    private func updateWeatherUI(city: String, temperature: Double, condition: Int) {
        let celsiusTemperature = TemperatureConverter.convert(temperature, from: .kelvin, to: .celsius)
        temperatureLabel.text = "\(Int(celsiusTemperature))℃"
        conditionLabel.text = WeatherConditionMapper.text(condition)
        citylabel.text = city
        weatherView.isHidden = false
    }
}
