//
//  WeatherLocationCell.swift
//  Weather
//
//  Created by Anouar El Maaroufi on 27/6/2024.
//

import UIKit
import SwipeCellKit

class WeatherLocationCell: SwipeTableViewCell {

    // MARK - Views
    
    internal lazy var navigatorImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()

    internal lazy var locationName: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 23, weight: .medium)
        label.textColor = UIColor.transparentBlackSeventy
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    internal lazy var weatherType: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = UIColor.transparentBlackFourty
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    internal lazy var temperatureDegree: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 33, weight: .medium)
        label.textColor = UIColor.transparentBlackNinty
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    internal lazy var temperatureLowHighDegree: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = UIColor.transparentBlackFourty
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    internal lazy var weatherImage: UIImageView = {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()
    // MARK - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUIs()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUIs()
    }
    
    func setupUIs() {
        contentView.addSubview(locationName)
        contentView.addSubview(weatherType)
        contentView.addSubview(temperatureDegree)
        contentView.addSubview(temperatureLowHighDegree)
        contentView.addSubview(weatherImage)
        contentView.addSubview(navigatorImage)
        
        NSLayoutConstraint.activate([
//            navigationImage.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
//            navigationImage.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
//            navigationImage.widthAnchor.constraint(equalToConstant: 17),
//            navigationImage.heightAnchor.constraint(equalToConstant: 17),
            
            locationName.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            locationName.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            
//            navigatorImage.leadingAnchor.constraint(equalTo: locationName.trailingAnchor, constant: 5),
//            navigatorImage.centerYAnchor.constraint(equalTo: locationName.centerYAnchor),
            navigatorImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            navigatorImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            navigatorImage.widthAnchor.constraint(equalToConstant: 20),
            navigatorImage.heightAnchor.constraint(equalToConstant: 20),
            
            weatherType.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            weatherType.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            
            temperatureDegree.topAnchor.constraint(equalTo: locationName.topAnchor),
            temperatureDegree.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            
            temperatureLowHighDegree.bottomAnchor.constraint(equalTo: weatherType.bottomAnchor),
            temperatureLowHighDegree.trailingAnchor.constraint(equalTo: temperatureDegree.trailingAnchor),
            
            weatherImage.widthAnchor.constraint(equalToConstant: 36),
            weatherImage.heightAnchor.constraint(equalToConstant: 36),
            weatherImage.centerYAnchor.constraint(equalTo: temperatureDegree.centerYAnchor),
            weatherImage.trailingAnchor.constraint(equalTo: temperatureDegree.leadingAnchor, constant: -10)
        ])
        
    }

    private func setupSelectionColor() {
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .transparentLightGray
        self.selectedBackgroundView = selectedBackgroundView
    }
}
