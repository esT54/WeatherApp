//
//  Weather.swift
//  WeatherApp
//
//  Created by Семен Смирнягин on 05.02.2022.
//

struct Weather: Decodable {
    struct Main: Decodable {
        let temp: Double
        let feels_like: Double
    }
    let main: Main
    var base: String
}
