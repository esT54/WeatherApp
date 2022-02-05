//
//  GeocoderApi.swift
//  WeatherApp
//
//  Created by Семен Смирнягин on 02.02.2022.
//
// key = c1429c472414f10327bdebc2c9026697

import Foundation
protocol Api {
    func getUrl() -> URL?
}

class Geocoder: Api {
    var cityName: String = ""
    func getUrl() -> URL? {
        URL(string: "http://api.openweathermap.org/geo/1.0/direct?q=\(cityName)&limit=5&appid=c1429c472414f10327bdebc2c9026697")
    }
    
    var params: [String : String] = [:]
    
    func getData(name: String) {
        
    }
    
    init(cityName: String) {
        self.cityName = cityName
    }
}


