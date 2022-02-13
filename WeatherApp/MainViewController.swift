//
//  ViewController.swift
//  WeatherApp
//
//  Created by Семен Смирнягин on 02.02.2022.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    
    var locationManager = CLLocationManager()
    var citiesArray = [GeoCity]()

    override func loadView() {
        view = MainView()
        if let view = view as? MainView {
            view.viewDelegate = self
            view.dropDownTableView.dataSource = self
            view.dropDownTableView.delegate = self
            view.dropDownTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        getCurrentLocation()
        
        if let view = view as? MainView {
            view.dropDownTableView.reloadData()
        }
        self.hideKeyboardWhenTappedAround()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let view = view as? MainView else { return }
        if let keyboardFrame =
            notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
            as? NSValue
        {
            let keyBoardHeight = keyboardFrame.cgRectValue.height
            let bottomSpace = view.frame.height - (view.testButton.frame.origin.y + view.testButton.frame.height) - 16
            
            if bottomSpace < keyBoardHeight {
                view.frame.origin.y -= keyBoardHeight - bottomSpace
            }
        }
    }
    
    @objc private func keyboardWillHide() {
        view.frame.origin.y = 0
    }
    
    func getTemperature(lat: Float, lon: Float) {
            Network.share.requestToApi(api: WeatherApi(lat: lat, lon: lon)) { (data: CurrentWeather) in
                let temp = String(format: "%.0f", data.main.temp - 273.15)
                let feelsLike = String(format: "%.0f", data.main.feels_like - 273.15)
                DispatchQueue.main.async {
                    if let view = self.view as? MainView {
                        view.selectHiddenTable(true)
                        view.tempLabel.text = "Temp = \(temp) °C"
                        view.feelsLikeLabel.text = "Feels like: \(feelsLike) °C"
                        if let sky = data.weather.first?.main {
                            view.skyLabel.text = "Sky is \(sky)"
                        }
                    }
                }
            }
        }
    deinit {
        NotificationCenter.default.removeObserver(self)
        locationManager.stopUpdatingLocation()
    }
}
// MARK: MainViewDelegate
extension MainViewController: MainViewDelegate {
    func getCurrentLocation() {
        if let location = locationManager.location {
            let lat = Float(location.coordinate.latitude)
            let lon = Float(location.coordinate.longitude)
            
            Network.share.requestToApi(api: WeatherApi(lat: lat, lon: lon)) { (data: CurrentWeather) in
                let temp = String(format: "%.0f", data.main.temp - 273.15)
                let feelsLike = String(format: "%.0f", data.main.feels_like - 273.15)
                DispatchQueue.main.async {
                    if let view = self.view as? MainView {
                        view.selectHiddenTable(true)
                        view.tempLabel.text = "Temp: \(temp) °C"
                        view.feelsLikeLabel.text = "Feels like: \(feelsLike) °C"
                        if let sky = data.weather.first?.main {
                            view.skyLabel.text = "Sky is \(sky)"
                        }
                        view.cityNameTextField.text = data.name
                    }
                }
            }
        }
    }
    
    func handleTouchedUpTestButton() {
        citiesArray = []
        guard let view = view as? MainView, let text = view.cityNameTextField.text else { return }
        Network.share.requestToApi(api: Geocoder(cityName: text.replacingOccurrences(of: " ", with: ""))) { (result: Result<[GeoCity], Error>) in
            switch result {
            case .success(let data):
                self.citiesArray = data
                self.citiesArray = Array(Set(self.citiesArray))
                let a = self.citiesArray.count
                switch a {
                case 0:
                    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    DispatchQueue.main.async {
                        self.showSimpleAlert(title: "Error",
                                        message: "Didn't find any cities with name: \(text)",
                                        action: action,
                                        viewController: self)
                    }
                case 1:
                    if let city = self.citiesArray.first {
                        self.getTemperature(lat: Float(city.lat),
                                            lon: Float(city.lon))
                    }
                default:
                    DispatchQueue.main.async {
                        view.dropDownTableView.reloadData()
                        view.selectHiddenTable(false)
                    }
                }
            case .failure(let failure):
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                DispatchQueue.main.async {
                    self.showSimpleAlert(title: "Error",
                                    message: String(describing: failure),
                                    action: action,
                                    viewController: self)
                }
            }
        }
    }
}
// MARK: UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let city = citiesArray[indexPath.row]
        cell.textLabel?.text = city.name + ", " + city.country
        return cell
    }
}
// MARK: UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = citiesArray[indexPath.row]
        if let view = view as? MainView {
            view.cityNameTextField.text = city.name + ", " + city.country
        }
        DispatchQueue.main.async {
            self.getTemperature(lat: Float(city.lat), lon: Float(city.lon))
        }
    }
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboardView() {
        view.endEditing(true)
    }
}
