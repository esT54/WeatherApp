//
//  ViewController.swift
//  WeatherApp
//
//  Created by Семен Смирнягин on 02.02.2022.
//

import UIKit

class MainViewController: UIViewController {
    
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
        if let view = view as? MainView {
            view.dropDownTableView.reloadData()
        }
    }
    
    func getTemperature(city: GeoCity) {
            Network.share.requestToApi(api: WeatherApi(lat: Int(city.lat), lon: Int(city.lon))) { (data: Weather) in
                let temp = String(format: "%.0f", data.main.temp - 273.15)
                DispatchQueue.main.async {
                    if let view = self.view as? MainView {
                        view.selectHiddenTable(true)
                        view.responceLabel.text = "Current temp = \(temp) °C"
                    }
                }
            }
        }
}
// MARK: MainViewDelegate
extension MainViewController: MainViewDelegate {
    func handleTouchedUpTestButton() {
        citiesArray = []
        guard let view = view as? MainView, let text = view.cityNameTextField.text else { return }
        Network.share.requestToApi(api: Geocoder(cityName: text.replacingOccurrences(of: " ", with: ""))) { (data: [GeoCity]) in
            self.citiesArray = data
            self.citiesArray = Array(Set(self.citiesArray))
            if self.citiesArray.count != 1 {
                DispatchQueue.main.async {
                    view.dropDownTableView.reloadData()
                    view.selectHiddenTable(false)
                }
            } else {
                if let city = self.citiesArray.first {
                    self.getTemperature(city: city)
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
            self.getTemperature(city: city)
        }
    }
}
