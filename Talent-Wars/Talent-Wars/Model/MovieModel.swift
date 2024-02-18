//
//  MovieModel.swift
//  Talent-Wars
//
//  Created by Natan de Camargo Rodrigues on 18/02/24.
//

import Foundation
import UIKit

struct MoviesResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let title: String
    let year: String
    let userScore: String
    let category: String
    let imagePath: String? // Caminho para a imagem do poster ou backdrop
}
