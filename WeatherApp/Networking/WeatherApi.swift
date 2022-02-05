//
//  WeatherApi.swift
//  WeatherApp
//
//  Created by Семен Смирнягин on 05.02.2022.
//

import Foundation

class WeatherApi: Api {
    func getUrl() -> URL? {
        URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=c1429c472414f10327bdebc2c9026697")
    }
    var lat: Int
    var lon: Int
    
    init(lat: Int, lon: Int) {
        self.lat = lat
        self.lon = lon
    }
}
