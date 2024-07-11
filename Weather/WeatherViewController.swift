//
//  ViewController.swift
//  Weather
//
//  Created by Anouar El Maaroufi on 27/6/2024.
//

import UIKit
import CoreLocation

// MARK - Search bar functionalities
extension WeatherViewController {
    @objc private func dismissSearch() {
        searchController.isActive = false
        overlayView.isHidden = true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        overlayView.isHidden = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        overlayView.isHidden = true
    }
}

// MARK - Functionalities for current location data
extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude

            updateCurrentLocationWeatherData(from: latitude, and: longitude)
            locationManager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            removeFirstRowIfNedded()
            locationManager.requestWhenInUseAuthorization()
            print("Authorization not determined")
        case .restricted, .denied:
            removeFirstRowIfNedded()
            print("Location access denied")
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location access granted")
            locationManager.startUpdatingLocation()
        @unknown default:
            fatalError("Unknown authorization status")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
    
    private func removeFirstRowIfNedded() {
        if let cityArray = loadCityInfo() {
            if cityArray.count > 0, cityArray[0].isMyLocation {
                deleteCityInfo(index: 0)
                self.weatherData.remove(at: 0)
                self.tableView.deleteSections(IndexSet(integer: 0), with: .automatic)
            }
        }
    }

    private func updateCurrentLocationWeatherData(from latitude: Double, and longitude: Double) {

        if self.shouldUpdateLocation { // When All requests completed then fetch my current location weather data
            
                WeatherService.getWeatherData(from: latitude, and: longitude) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(var weatherResponse):
                        
                        weatherResponse.isMyLocation = true
                        let newCityItem = CityInfo(cityName: weatherResponse.name, latitude: weatherResponse.coord.lat, longitude: weatherResponse.coord.lon, isMyLocation: true)
                        let previousSectionCount = self.weatherData.count
                        
                        if self.weatherData.isEmpty || !self.weatherData[0].isMyLocation {
                            self.weatherData.insert(weatherResponse, at: 0)
                        } else {
                            self.weatherData[0] = weatherResponse
                            deleteCityInfo(index: 0)
                        }
                        
                        saveCityInfo(cityInfo: newCityItem, insertFirstPosition: true)

                        DispatchQueue.main.async {
                            let newSectionCount = self.weatherData.count
                            let difference = newSectionCount - previousSectionCount
                            if difference > 0 {
                                self.tableView.performBatchUpdates({
                                    let indexSet = IndexSet(integer: 0)
                                    self.tableView.insertSections(indexSet, with: .fade)
                                }, completion: nil)
                            } else {
                                self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                            }
                        }
                        
                    case .failure(let error):
                        print("Error fetching weather data: \(error.localizedDescription)")
                    }
                    
                }
            }
        }
}

// MARK - Conform to the delegate protocol
extension WeatherViewController: WeatherDetailViewControllerDelegate {

    func addNewWeatherItem(_ weatherItem: WeatherData) {
        self.weatherData.append(weatherItem)
        self.searchController.isActive = false

        let newSectionCount = self.weatherData.count
            self.tableView.performBatchUpdates({
                let indexSet = IndexSet(integer: newSectionCount - 1)
                self.tableView.insertSections(indexSet, with: .automatic)
            }, completion: nil)
    }

}

// MARK - TableView Delegate

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return weatherData.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weaatherLocationCell", for: indexPath) as! WeatherLocationCell

        let weatherInstance = weatherData[indexPath.section]

        // customize the cell
        cell.backgroundColor = UIColor.transparentLightGray
        cell.layer.borderColor = UIColor.strokeGray.cgColor
        cell.layer.borderWidth = 0.5

        cell.locationName.text = weatherInstance.name
        cell.temperatureDegree.text = "\(convertTemperatureUnitValue(isCelsius: isCelsiusSelected, celsius: weatherInstance.main.temp))º"
        cell.temperatureLowHighDegree.text = "L:\(convertTemperatureUnitValue(isCelsius: isCelsiusSelected, celsius: weatherInstance.main.tempMin))º H:\(convertTemperatureUnitValue(isCelsius: isCelsiusSelected, celsius: weatherInstance.main.tempMax))º"
        cell.weatherType.text = "\(weatherInstance.weather[0].main)"
        cell.weatherImage.image = UIImage(named: getWeatherImage(weatherIcon: weatherInstance.weather[0].icon))

        if weatherInstance.isMyLocation {
            cell.navigatorImage.image = UIImage(named: "navigation")
        } else {
            cell.navigatorImage.image = nil
        }
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
        
        let weatherItem = weatherData[indexPath.section]

        weatherDetailController.weatherData = weatherItem
        weatherDetailController.isCelsius = self.isCelsiusSelected
        
        navigationController?.pushViewController(weatherDetailController, animated: true)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard !self.weatherData[indexPath.section].isMyLocation else { return false }
        return true
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard !self.weatherData[indexPath.section].isMyLocation else { return nil }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            deleteCityInfo(index: indexPath.section)
            self.weatherData.remove(at: indexPath.section)
            tableView.performBatchUpdates({
                let indexSet = IndexSet(integer: indexPath.section)
                tableView.deleteSections(indexSet, with: .fade)
            }, completion: { _ in
                completionHandler(true)
            })
        }

        // Add custom delete icon
        deleteAction.image = UIImage(systemName: "trash")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
}

class WeatherViewController: UIViewController, UISearchBarDelegate {
    
    var weatherData = [WeatherData]()
    var locationManager: CLLocationManager!
    var shouldUpdateLocation = false
    var isCelsiusSelected = true


    private lazy var overlayView: UIView = {
        
        var overlayView = UIView()
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlayView.isHidden = true
        view.addSubview(overlayView)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSearch))
        overlayView.addGestureRecognizer(tapGesture)
        
        return overlayView
    }()

    private lazy var searchController: UISearchController = {
        let searchResultsController = SearchResultsViewController()
        searchResultsController.mainViewController = self
        let searchController = UISearchController(searchResultsController: searchResultsController)

        searchController.searchResultsUpdater = searchController.searchResultsController as? UISearchResultsUpdating
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
        tableView.isHidden = true
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }()

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        
        return indicator
    }()

    private func setupMenuButton() {
        let menuButton = UIBarButtonItem(title: nil, image: UIImage(systemName: "ellipsis.circle"), primaryAction: nil, menu: createMenu())
        navigationItem.rightBarButtonItem = menuButton
    }

    private func createMenu() -> UIMenu {
        // Create the actions with temperature symbols and labels
        let celsiusAction = UIAction(title: "Celsius", image: UIImage(systemName: isCelsiusSelected ? "checkmark.square" : "square")) { _ in
            self.isCelsiusSelected = true
            self.tableView.reloadSections(IndexSet(integersIn: 0..<self.weatherData.count), with: .automatic)
            self.setupMenuButton()
        }
        let fahrenheitAction = UIAction(title: "Fahrenheit", image: UIImage(systemName: isCelsiusSelected ? "square" : "checkmark.square")) { _ in
            self.isCelsiusSelected = false
            self.tableView.reloadSections(IndexSet(integersIn: 0..<self.weatherData.count), with: .automatic)
            self.setupMenuButton()
        }

        saveTemperatureUnitType(self.isCelsiusSelected)
        return UIMenu(title: "Temperature unit type", children: [celsiusAction, fahrenheitAction])
    }

    // update the overlay frame based on the navigation bar frame updates
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateOverlayViewFrame()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        updateOverlayViewFrame()
    }

    private func updateOverlayViewFrame() {
        guard let navBar = navigationController?.navigationBar.frame else { return }
        
        overlayView.frame = CGRect(x: 0, y: navBar.maxY, width: view.bounds.width, height: view.bounds.height - navBar.height)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Get the api key from AppConfig
        if let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String {
            WeatherService.apiKey = apiKey
        } else {
            fatalError("API Key not found in config file.")
        }

        // Do any additional setup after loading the view.
        self.isCelsiusSelected = getTemperatureUnitType() ?? true
        setupMenuButton()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(red: 2/255.0, green: 103/255.0, blue: 255/255.0, alpha: 1.0),
        ]
        navigationItem.largeTitleDisplayMode = .always
        title = "Weather"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        // Get location access and data
        locationManager = CLLocationManager()

        fetchAllSavedLocations() { [weak self] in // Load the previously saved location data and update the state of the current location
            self?.shouldUpdateLocation = true
            self?.locationManager.delegate = self
            self?.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self?.locationManager.requestWhenInUseAuthorization()
            self?.locationManager.startUpdatingLocation()
            self?.loadingIndicator.stopAnimating()
            self?.loadingIndicator.isHidden = true
            self?.tableView.isHidden = false
        }
    }

    // Load weather data from the OpenWeatherApi by accessing UserDefaults
    private func fetchAllSavedLocations(completion: @escaping () -> Void) {
        var weatherDataDictionary: [Int: WeatherData] = [:]

        if let cityInfo = loadCityInfo() {
            let group = DispatchGroup()
            if cityInfo.isEmpty {
                completion()
            }
            for location in cityInfo {
                group.enter()
                WeatherService.getWeatherData(from: location.latitude, and: location.longitude) { result in
                    switch result {
                        case .success(var weatherResponse):
                            weatherResponse.isMyLocation = location.isMyLocation
                            weatherDataDictionary[location.id] = weatherResponse
                        case .failure(let error):
                            print("Error fetching weather data: \(error.localizedDescription)")
                    }
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                self.weatherData = cityInfo.compactMap { weatherDataDictionary[$0.id] }
                self.tableView.reloadData()
                completion()
            }
            
        } else {
            completion()
        }
    }
}


