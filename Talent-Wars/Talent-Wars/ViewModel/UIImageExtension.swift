//
//  UIImageExtension.swift
//  Talent-Wars
//
//  Created by Natan de Camargo Rodrigues on 21/02/24.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImage(fromPath path: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(path)") else {
            self.image = nil // Or a default image
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            } else {
                DispatchQueue.main.async {
                    self.image = nil // Or error/default image
                }
            }
        }.resume()
    }
}
