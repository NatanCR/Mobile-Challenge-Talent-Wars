//
//  UIButtonExtension.swift
//  Talent-Wars
//
//  Created by Natan de Camargo Rodrigues on 21/02/24.
//

import Foundation
import UIKit

extension UIButton {
    static func createCustomButton(title: String, imageName: String, color: UIColor, shadow: Bool = true) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        let configuration = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium, scale: .default)
        if let image = UIImage(systemName: imageName, withConfiguration: configuration) {
            button.setImage(image, for: .normal)
        }
        button.backgroundColor = color
        button.tintColor = .white
        if shadow {
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 4)
            button.layer.shadowOpacity = 0.5
            button.layer.shadowRadius = 5
        }
        button.layer.cornerRadius = 12
        
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 10)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)
        
        return button
    }
}
