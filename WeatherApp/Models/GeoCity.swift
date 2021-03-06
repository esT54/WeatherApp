//
//  GeoCity.swift
//  WeatherApp
//
//  Created by Семен Смирнягин on 04.02.2022.
//

struct GeoCity: Decodable {
    var country: String
    var lat: Double
    var lon: Double
    var name: String
}

extension GeoCity: Equatable, Hashable {
    static func == (lhs: GeoCity, rhs: GeoCity) -> Bool {
        lhs.country == rhs.country &&
        lhs.name == rhs.name
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(country)
        hasher.combine(name)
    }
}
