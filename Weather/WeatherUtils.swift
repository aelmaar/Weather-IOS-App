//
//  WeatherService.swift
//  Weather
//
//  Created by Anouar El Maaroufi on 3/7/2024.
//

import Foundation

struct WeatherService {

    static let apiKey = "9c3ebea404b5caabca4d58b5c28f7ff6"
    static func getWeatherData(from latitude: Double, and longtitude: Double, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longtitude)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Invalid URL"])))
            return
        }

        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "No data received"])
                completion(.failure(error))
                return
            }

            do {
                let decoder = JSONDecoder()
                let weatherResponse = try decoder.decode(WeatherData.self, from: data)
                completion(.success(weatherResponse))
            } catch {
                print("Error from her?")
                completion(.failure(error))
            }
        }

        task.resume()
    }
}

// Get the right weather image from the asset catalog
func getWeatherImage(weatherIcon: String) -> String {
    switch(weatherIcon.prefix(2)) {
        case "01": return "sun"
        case "02": return "few_cloud"
        case "03": return "scattered_cloud"
        case "04": return "broken_cloud"
        case "09": return "shower_rain"
        case "10": return "rain"
        case "11": return "thunderstorm"
        case "13": return "snow"
        default:
            return "mist"
    }
}

func saveCityInfo(cityInfo: CityInfo, insertFirstPosition: Bool = false) {
    let defaults = UserDefaults.standard
    var cityInfoArray = loadCityInfo() ?? []
    
    if insertFirstPosition {
        cityInfoArray.insert(cityInfo, at: 0)
    } else {
        cityInfoArray.append(cityInfo)
    }
    
    if let encoded = try? JSONEncoder().encode(cityInfoArray) {
        defaults.set(encoded, forKey: "SavedCities")
    }
}

func loadCityInfo() -> [CityInfo]? {
    let defaults = UserDefaults.standard
    if let savedData = defaults.object(forKey: "SavedCities") as? Data {
        if let cityInfoArray = try? JSONDecoder().decode([CityInfo].self, from: savedData) {
            return cityInfoArray
        }
    }
    return nil
}

func deleteCityInfo(index: Int) {
    let defaults = UserDefaults.standard

    if var cityInfoArray = loadCityInfo() {
        cityInfoArray.remove(at: index)
        
        if let encoded = try? JSONEncoder().encode(cityInfoArray) {
            defaults.set(encoded, forKey: "SavedCities")
        }
    }
}

func saveTemperatureUnitType(_ type: Bool) {
    
    UserDefaults.standard.set(type, forKey: "temperatureUnitType")
}

func getTemperatureUnitType() -> Bool? {
    return UserDefaults.standard.bool(forKey: "temperatureUnitType")
}

func convertTemperatureUnitValue(isCelsius: Bool, celsius: Double) -> Int {
    return !isCelsius ? Int((celsius * 9/5) + 32) : Int(celsius)
}


