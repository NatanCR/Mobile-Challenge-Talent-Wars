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

public struct Movie: Codable {
    let title: String
    let releaseDate: String
    let voteAverage: String
    let overview: String
    let backdropPath: String?
    let posterPath: String?
    let genreIDs: [Int]
    
    // Você pode adicionar propriedades calculadas ou métodos para obter a URL da imagem e formatar a data, por exemplo.
    var formattedReleaseYear: String {
        String(releaseDate.prefix(4))
    }
}
