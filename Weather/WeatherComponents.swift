//
//  WeatherMainInfoView.swift
//  Weather
//
//  Created by Anouar El Maaroufi on 29/6/2024.
//

import UIKit

func weatherDetailInfoComponent(imageName: String, fieldText: String, fieldValue: String) -> UIView {
    let view = UIView()

    view.translatesAutoresizingMaskIntoConstraints = false

    let containerImageView = UIView()
    containerImageView.translatesAutoresizingMaskIntoConstraints = false
    containerImageView.layer.cornerRadius = 27.5
    containerImageView.backgroundColor = .transparentLightGray

    let imageView = UIImageView(image: UIImage(named: imageName))
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
    containerImageView.addSubview(imageView)
    
    view.addSubview(containerImageView)
    
    let fieldTextLabel = UILabel()
    fieldTextLabel.text = fieldText
    fieldTextLabel.font = .systemFont(ofSize: 12, weight: .semibold)
    fieldTextLabel.textColor = .transparentBlackFourty
    fieldTextLabel.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(fieldTextLabel)

    let fieldValueLabel = UILabel()
    fieldValueLabel.text = fieldValue
    fieldValueLabel.font = .systemFont(ofSize: 20, weight: .semibold)
    fieldValueLabel.textColor = .transparentBlackNinty
    fieldValueLabel.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(fieldValueLabel)

    NSLayoutConstraint.activate([
        containerImageView.widthAnchor.constraint(equalToConstant: 55),
        containerImageView.heightAnchor.constraint(equalToConstant: 55),
        containerImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        containerImageView.topAnchor.constraint(equalTo: view.topAnchor),
        containerImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

        imageView.widthAnchor.constraint(equalToConstant: 30),
        imageView.heightAnchor.constraint(equalToConstant: 30),
        imageView.centerXAnchor.constraint(equalTo: containerImageView.centerXAnchor),
        imageView.centerYAnchor.constraint(equalTo: containerImageView.centerYAnchor),

        fieldTextLabel.leadingAnchor.constraint(equalTo: containerImageView.trailingAnchor, constant: 5),
        fieldTextLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor, constant: -10),
        fieldTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),

        fieldValueLabel.leadingAnchor.constraint(equalTo: fieldTextLabel.leadingAnchor),
        fieldValueLabel.bottomAnchor.constraint(equalTo: containerImageView.bottomAnchor),
        fieldValueLabel.trailingAnchor.constraint(equalTo: fieldTextLabel.trailingAnchor),
    ])
    return view
}
