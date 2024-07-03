//
//  WeatherDetailViewController.swift
//  Weather
//
//  Created by Anouar El Maaroufi on 29/6/2024.
//

import UIKit

// UTILITY
private func convertWindSpeedToKmh(_ speedInMps: Double) -> Int {
    return Int(speedInMps * 3.6)
}

class WeatherDetailViewController: UIViewController {

    private let containerView = UIView()
    var weatherDetailData: WeatherDetailData!
    
    var temperatueDegree: UILabel = {
        let label = UILabel()
        
        label.text = "22º"
        label.textColor = .transparentBlackSeventy
        label.font = .systemFont(ofSize: 64, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    var weatherImage: UIImageView = {
        let imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()
    
    var weatherDescription: UILabel = {
        let label = UILabel()
        
        label.text = "Clear Sky"
        label.textColor = .transparentBlackSeventy
        label.font = .systemFont(ofSize: 24, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    var temperatureLowHighDegree: UILabel = {
        let label = UILabel()
        
        label.text = "L:20º, H:27º"
        label.textColor = .transparentBlackSeventy
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = weatherDetailData.locationName
        navigationItem.largeTitleDisplayMode = .never

        setupWeatherMainUI()
        setupWeatherDetailUI()
    }

    private func setupWeatherMainUI() {
        // Fill the informations
        temperatueDegree.text = "\(weatherDetailData.temp)º"
        weatherDescription.text = "\(weatherDetailData.description)"
        temperatureLowHighDegree.text = "L:\(weatherDetailData.tempMin)º, H:\(weatherDetailData.tempMax)º"
        weatherImage.image = UIImage(named: weatherDetailData.imageName)

        containerView.translatesAutoresizingMaskIntoConstraints = false
            
        containerView.addSubview(temperatueDegree)
        containerView.addSubview(weatherImage)
        containerView.addSubview(weatherDescription)
        containerView.addSubview(temperatureLowHighDegree)

        view.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            temperatueDegree.topAnchor.constraint(equalTo: containerView.layoutMarginsGuide.topAnchor),
            temperatueDegree.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            weatherImage.centerXAnchor.constraint(equalTo: temperatueDegree.centerXAnchor),
            weatherImage.topAnchor.constraint(equalTo: temperatueDegree.bottomAnchor, constant: 10),
            weatherImage.widthAnchor.constraint(equalToConstant: 200),
            weatherImage.heightAnchor.constraint(equalToConstant: 200),
            
            weatherDescription.topAnchor.constraint(equalTo: weatherImage.bottomAnchor, constant: 10),
            weatherDescription.centerXAnchor.constraint(equalTo: weatherImage.centerXAnchor),
            
            temperatureLowHighDegree.topAnchor.constraint(equalTo: weatherDescription.bottomAnchor, constant: 5),
            temperatureLowHighDegree.centerXAnchor.constraint(equalTo: weatherDescription.centerXAnchor)
        ])
    }

    private func setupWeatherDetailUI() {
        let weatherDetailContainer = UIView()

        weatherDetailContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let warmView = weatherDetailInfoComponent(imageName: "celsius", fieldText: "Feel like", fieldValue: "\(weatherDetailData.feelsLike)º")
        let windView = weatherDetailInfoComponent(imageName: "wind", fieldText: "Wind", fieldValue: "\(convertWindSpeedToKmh(weatherDetailData.windSpeed)) km/h")
        let humidityView = weatherDetailInfoComponent(imageName: "humidity", fieldText: "Humidity", fieldValue: "\(weatherDetailData.humidity)%")
        let pressureView = weatherDetailInfoComponent(imageName: "thermometer", fieldText: "Pressure", fieldValue: "\(weatherDetailData.pressure)hPa")
        let visibilityView = weatherDetailInfoComponent(imageName: "visibility", fieldText: "Visibility", fieldValue: "\(weatherDetailData.visibility/1000) km")
        let cloudinessView = weatherDetailInfoComponent(imageName: "cloud", fieldText: "Cloudiness", fieldValue: "\(weatherDetailData.cloudiness)%")

        weatherDetailContainer.addSubview(warmView)
        weatherDetailContainer.addSubview(windView)
        weatherDetailContainer.addSubview(humidityView)
        weatherDetailContainer.addSubview(pressureView)
        weatherDetailContainer.addSubview(visibilityView)
        weatherDetailContainer.addSubview(cloudinessView)

        view.addSubview(weatherDetailContainer)

        NSLayoutConstraint.activate([
            weatherDetailContainer.topAnchor.constraint(equalTo: containerView.bottomAnchor),
            weatherDetailContainer.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            weatherDetailContainer.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            weatherDetailContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            
            warmView.topAnchor.constraint(equalTo: weatherDetailContainer.layoutMarginsGuide.topAnchor),
            warmView.leadingAnchor.constraint(equalTo: weatherDetailContainer.layoutMarginsGuide.leadingAnchor),
            
            windView.topAnchor.constraint(equalTo: warmView.topAnchor),
            windView.leadingAnchor.constraint(equalTo: cloudinessView.leadingAnchor),
            
            pressureView.centerYAnchor.constraint(equalTo: weatherDetailContainer.centerYAnchor),
            pressureView.leadingAnchor.constraint(equalTo: warmView.leadingAnchor),
            
            humidityView.centerYAnchor.constraint(equalTo: pressureView.centerYAnchor),
            humidityView.leadingAnchor.constraint(equalTo: cloudinessView.leadingAnchor),
            
            visibilityView.bottomAnchor.constraint(equalTo: weatherDetailContainer.layoutMarginsGuide.bottomAnchor),
            visibilityView.leadingAnchor.constraint(equalTo: pressureView.leadingAnchor),
            
            cloudinessView.bottomAnchor.constraint(equalTo: visibilityView.bottomAnchor),
            cloudinessView.trailingAnchor.constraint(equalTo: weatherDetailContainer.layoutMarginsGuide.trailingAnchor),
        ])
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
