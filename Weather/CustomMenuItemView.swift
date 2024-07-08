//
//  CustomMenuItemView.swift
//  Weather
//
//  Created by Anouar El Maaroufi on 8/7/2024.
//

import UIKit

extension UIView {
    func asImage() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

class CustomMenuItemView: UIView {
    
    init(title: String, leadingImage: UIImage?, trailingImage: UIImage?) {
        super.init(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 17)
        
        let leadingImageView = UIImageView(image: leadingImage)
        leadingImageView.contentMode = .scaleAspectFit
        leadingImageView.translatesAutoresizingMaskIntoConstraints = false
        leadingImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        leadingImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        let trailingImageView = UIImageView(image: trailingImage)
        trailingImageView.contentMode = .scaleAspectFit
        trailingImageView.translatesAutoresizingMaskIntoConstraints = false
        trailingImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        trailingImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [leadingImageView, label, trailingImageView])
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = .center

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
