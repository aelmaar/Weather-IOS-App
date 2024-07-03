//
//  ViewController.swift
//  Weather
//
//  Created by Anouar El Maaroufi on 27/6/2024.
//

import UIKit

// MARK - TableView Delegates

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return weatherData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weaatherLocationCell", for: indexPath) as! WeatherLocationCell

        let weatherInstance = weatherData[indexPath.row]

        // customize the cell
        cell.backgroundColor = UIColor.transparentLightGray
        cell.layer.borderColor = UIColor.strokeGray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10
        
        // Cell's data source
        cell.locationName.text = weatherInstance.name
        cell.temperatureDegree.text = "\(Int(weatherInstance.main.temp))º"
        cell.temperatureLowHighDegree.text = "L:\(Int(weatherInstance.main.tempMin))º H:\(Int(weatherInstance.main.tempMax))º"
        cell.weatherType.text = "\(weatherInstance.weather[0].main)"
        cell.weatherImage.image = UIImage(named: getWeatherImage(weatherIcon: weatherInstance.weather[0].icon))
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)

        let weatherDetailController = WeatherDetailViewController()
        
        let weatherInstance = weatherData[indexPath.row]
        
        var data = WeatherDetailData()
        
        data.locationName = weatherInstance.name
        data.temp = Int(weatherInstance.main.temp)
        data.description = weatherInstance.weather[0].description
        data.tempMin = Int(weatherInstance.main.tempMin)
        data.tempMax = Int(weatherInstance.main.tempMax)
        data.feelsLike = Int(weatherInstance.main.feelsLike)
        data.windSpeed = weatherInstance.wind.speed
        data.pressure = weatherInstance.main.pressure
        data.humidity = weatherInstance.main.humidity
        data.visibility = weatherInstance.visibility
        data.cloudiness = weatherInstance.clouds.all
        data.imageName = getWeatherImage(weatherIcon: weatherInstance.weather[0].icon)

        weatherDetailController.weatherDetailData = data
        navigationController?.pushViewController(weatherDetailController, animated: true)
    }
}

class WeatherViewController: UIViewController, UISearchBarDelegate {
    
    private var weatherData = [WeatherData]()

    private lazy var menuButton: UIButton = {
        let menuButton = UIButton(type: .system)
        
        if let menuIcon = UIImage(systemName: "ellipsis") {
            menuButton.setImage(menuIcon, for: .normal)
        }
        menuButton.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 0.5)
        menuButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        menuButton.layer.cornerRadius = 15
        menuButton.tintColor = UIColor.lightGray
        return menuButton
    }()

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)

        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a location"
        searchController.searchBar.searchBarStyle = .minimal
        definesPresentationContext = true
        
        return searchController
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(WeatherLocationCell.self, forCellReuseIdentifier: "weaatherLocationCell")
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(red: 2/255.0, green: 103/255.0, blue: 255/255.0, alpha: 1.0),
        ]
        navigationItem.largeTitleDisplayMode = .always
        title = "Weather"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: menuButton)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        getWeatherData()
    }

    // Get weather data from the OpenWeatherApi
    private func getWeatherData() {
        let apiKey = "9c3ebea404b5caabca4d58b5c28f7ff6"
        let city = "Agadir"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL")
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let decoder = JSONDecoder()
                let weatherResponse = try decoder.decode(WeatherData.self, from: data)

                self.weatherData.append(weatherResponse)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                // Access the parsed data
                let temperature = weatherResponse.main.temp
                let feelsLike = weatherResponse.main.feelsLike
                let pressure = weatherResponse.main.pressure
                let humidity = weatherResponse.main.humidity
                let visibility = weatherResponse.visibility
                let windSpeed = weatherResponse.wind.speed
                let windDirection = weatherResponse.wind.deg
                let cloudiness = weatherResponse.clouds.all
                
                print("Temperature: \(temperature)°C")
                print("Feels Like: \(feelsLike)°C")
                print("Pressure: \(pressure) hPa")
                print("Humidity: \(humidity)%")
                print("Visibility: \(visibility) meters")
                print("Wind Speed: \(windSpeed) m/s")
                print("Wind Direction: \(windDirection)°")
                print("Cloudiness: \(cloudiness)%")
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
            }
        }

        task.resume()
    }

    // Get the right weather image from the asset catalog
    private func getWeatherImage(weatherIcon: String) -> String {
        switch(weatherIcon) {
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
}


