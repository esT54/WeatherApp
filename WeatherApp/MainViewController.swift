//
//  ViewController.swift
//  WeatherApp
//
//  Created by Семен Смирнягин on 02.02.2022.
//

import UIKit

class MainViewController: UIViewController {

    override func loadView() {
        view = MainView()
        if let view = view as? MainView {
            view.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
// MARK: MainViewDelegate
extension MainViewController: MainViewDelegate {
    func handleTouchedUpTestButton() {
        guard let view = view as? MainView, let text = view.cityNameTextField.text else { return }
        Network.share.requestToApi(api: Geocoder(cityName: text)) { (data: [GeoCity]) in
            var countries = Set<GeoCity>()
            data.forEach { city in
                countries.insert(city)
            }
            if countries.count != 1 {
                countries.forEach { city in
                    print(city.name + " " + city.country)
                }
            } else {
                if let city = countries.first {
                    print(city)
                    Network.share.requestToApi(api: WeatherApi(lat: Int(city.lat), lon: Int(city.lon))) { (data: Weather) in
                        let temp = Int(data.main.temp - 273.15)
                        DispatchQueue.main.async {
                            view.responceLabel.text = "Current temp = \(temp)"
                        }
                    }
                }
            }
        }
    }
}
