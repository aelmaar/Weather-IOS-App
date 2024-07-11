//
//  WeatherData.swift
//  Weather
//
//  Created by Anouar El Maaroufi on 3/7/2024.
//

import Foundation

// This model for JSON data parser

struct WeatherData: Codable {
    let coord: Coordinates
    let main: Main
    let weather: [Weather]
    let wind: Wind
    let clouds: Clouds
    let visibility: Int
    let name: String
    var isMyLocation: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case coord
        case main
        case weather
        case wind
        case clouds
        case visibility
        case name
    }
}

struct Main: Codable {
    let temp: Double
    let feelsLike: Double
    let pressure: Int
    let humidity: Int
    let tempMin: Double
    let tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case pressure
        case humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
}

struct Clouds: Codable {
    let all: Int
}

struct Coordinates: Codable {
    let lon: Double
    let lat: Double
}

// This model will be used to save data locally using UserDefaults

struct CityInfo: Codable {
    static var nextID: Int = 0
    var id: Int = 0
    let cityName: String
    let latitude: Double
    let longitude: Double
    var isMyLocation: Bool = false
}
