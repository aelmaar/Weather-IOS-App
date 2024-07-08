//
//  SearchResultsViewController.swift
//  Weather
//
//  Created by Anouar El Maaroufi on 3/7/2024.
//

import UIKit
import MapKit

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchRestuls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)

        let mapItem = searchRestuls[indexPath.row]
        cell.textLabel?.text = mapItem.placemark.locality
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMapItem = searchRestuls[indexPath.row]
        let coordinate = selectedMapItem.placemark.coordinate
        
        let latitude = coordinate.latitude
        let longtitude = coordinate.longitude
        
        WeatherService.getWeatherData(from: latitude, and: longtitude) { [weak self] result in
            switch result {
            case .success(let weatherResponse):
                DispatchQueue.main.async {
                    let weatherDetailController = WeatherDetailViewController()

                    weatherDetailController.delegate = self?.mainViewController
                    weatherDetailController.isCelsius = getTemperatureUnitType() ?? true
                    let navController = UINavigationController(rootViewController: weatherDetailController)
                    navController.modalPresentationStyle = .fullScreen

                    weatherDetailController.weatherData = weatherResponse
                    weatherDetailController.isNewLocation = true

                    self?.present(navController, animated: true)
                    
                }
            case .failure(let error):
                print("Error fetching weather data: \(error.localizedDescription)")
            }
        }
    }
    
}

class SearchResultsViewController: UIViewController, UISearchResultsUpdating {

    private let tableView = UITableView()
    private var searchRestuls: [MKMapItem] = []
    weak var mainViewController: WeatherViewController!
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            self.searchRestuls.removeAll()
            self.tableView.reloadData()
            return
        }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            self.searchRestuls = response.mapItems
            self.tableView.reloadData()
            
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "locationCell")
        view.addSubview(tableView)
        navigationItem.hidesSearchBarWhenScrolling = false
//        navigationController?.isNavigationBarHidden = true

//        addChild(customNavigationController)
//        customNavigationController.view.frame = view.bounds
//        view.addSubview(customNavigationController.view)
//        customNavigationController.didMove(toParent: self)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
