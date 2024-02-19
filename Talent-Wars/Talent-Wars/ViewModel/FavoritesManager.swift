// Em FavoritesManager.swift

import Foundation
import UIKit

class FavoritesManager {
    static let shared = FavoritesManager()

    private let favoritesKey = "FavoritesKey"
    
    // Structure to store minimal data of movies
    struct FavoriteMovie: Codable {
        let id: Int
        let posterPath: String
    }

    // Dictionary to store favorite movies by ID
    private var favorites: [Int: FavoriteMovie] {
        get {
            // Load and deserialize the saved data
            guard let data = UserDefaults.standard.data(forKey: favoritesKey),
                  let favorites = try? JSONDecoder().decode([Int: FavoriteMovie].self, from: data) else {
                return [:]
            }
            return favorites
        }
        set {
            // Serialize and save the data
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: favoritesKey)
        }
    }

    func addFavorite(movie: Movie) {
        let favoriteMovie = FavoriteMovie(id: movie.id, posterPath: movie.posterPath ?? "")
        favorites[movie.id] = favoriteMovie
    }

    func removeFavorite(movieId: Int) {
        favorites.removeValue(forKey: movieId)
    }

    func isFavorite(movieId: Int) -> Bool {
        favorites.contains { $0.key == movieId }
    }

    func getFavoriteMovies() -> [FavoriteMovie] {
        Array(favorites.values)
    }
}
