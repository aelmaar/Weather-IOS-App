//
//  ViewController.swift
//  Weather
//
//  Created by Anouar El Maaroufi on 27/6/2024.
//

import UIKit

// MARK - TableView Delegates
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weaatherLocationCell", for: indexPath) as! WeatherLocationCell

        cell.backgroundColor = UIColor.transparentLightGray
        cell.layer.borderColor = UIColor.strokeGray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10

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
}

class ViewController: UIViewController, UISearchBarDelegate {
    
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

        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a location"
        searchController.searchBar.searchBarStyle = .minimal
        
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
        title = "Weather"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(red: 2/255.0, green: 103/255.0, blue: 255/255.0, alpha: 1.0),
        ]
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: menuButton)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
        
    }

}

