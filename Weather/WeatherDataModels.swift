//
//  WeatherData.swift
//  Weather
//
//  Created by Anouar El Maaroufi on 3/7/2024.
//

import Foundation

struct WeatherData: Codable {
    let main: Main
    let weather: [Weather]
    let wind: Wind
    let clouds: Clouds
    let visibility: Int
    let name: String
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

struct WeatherDetailData {
    var locationName: String = ""
    var temp: Int = 0
    var description: String = ""
    var imageName: String = ""
    var tempMin: Int = 0
    var tempMax: Int = 0
    var feelsLike: Int = 0
    var windSpeed: Double = 0.0
    var pressure: Int = 0
    var humidity: Int = 0
    var visibility: Int = 0
    var cloudiness: Int = 0
}
