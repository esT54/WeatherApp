//
//  Weather.swift
//  WeatherApp
//
//  Created by Семен Смирнягин on 05.02.2022.
//

struct CurrentWeather: Decodable {
    struct Main: Decodable {
        let temp: Double
        let feels_like: Double
    }
    struct Weather: Decodable {
        let main: String
    }
    let main: Main
    let base: String
    let name: String
    let weather: [Weather]
}
