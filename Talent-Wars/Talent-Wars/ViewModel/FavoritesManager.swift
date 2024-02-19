//
//  FavoritesManager.swift
//  Talent-Wars
//
//  Created by Natan de Camargo Rodrigues on 19/02/24.
//

import Foundation
import UIKit

class FavoritesManager {
    static let shared = FavoritesManager()

    private let favoritesKey = "FavoritesKey"
    private var favorites: Set<Int> {
        get {
            Set(UserDefaults.standard.array(forKey: favoritesKey) as? [Int] ?? [])
        }
        set {
            UserDefaults.standard.set(Array(newValue), forKey: favoritesKey)
        }
    }

    func addFavorite(movieId: Int) {
        favorites.insert(movieId)
    }

    func removeFavorite(movieId: Int) {
        favorites.remove(movieId)
    }

    func isFavorite(movieId: Int) -> Bool {
        favorites.contains(movieId)
    }

    func getFavorites() -> [Int] {
        Array(favorites)
    }
}

