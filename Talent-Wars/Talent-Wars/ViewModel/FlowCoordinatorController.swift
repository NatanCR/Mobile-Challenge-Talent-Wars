//
//  FlowCoordinatorController.swift
//  Talent-Wars
//
//  Created by Natan de Camargo Rodrigues on 18/02/24.
//

import Foundation
import UIKit

class FlowCoordinatorController: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    //MARK: - Start Flow
    
    func start() {
        let homeViewVC = HomeViewController()
        homeViewVC.coordinator = self
        navigationController.pushViewController(homeViewVC, animated: false)
    }
    
    func showMovieDetails(for movie: Movie) {
        let detailsVC = MovieDetailsViewController()
        detailsVC.coordinator = self  // Ensure this line is present
        detailsVC.movie = movie
        navigationController.pushViewController(detailsVC, animated: true)
    }
    
    func showRating(for movie: Movie) {
        let ratingVC = RatingViewController()
        ratingVC.coordinator = self
        ratingVC.movie = movie
        navigationController.pushViewController(ratingVC, animated: true)
    }
    
    func showFavorites() {
        let favoritesVC = FavoritesMoviesViewController()
        favoritesVC.coordinator = self
        // Getting the favorite movies and passing them to the FavoritesMoviesViewController
        let favoriteMovies = FavoritesManager.shared.getFavoriteMovies().map { favorite in
            // Here you create instances of Movie from the FavoriteMovie data
            return Movie(id: favorite.id,
                         title: "", // Default value or another appropriate one
                         releaseDate: "",
                         voteAverage: "",
                         overview: "",
                         backdropPath: nil,
                         posterPath: favorite.posterPath,
                         genreIDs: [])
        }
        
        // Setting the list of favorite movies in the FavoritesMoviesViewController
        favoritesVC.favoriteMovies = favoriteMovies
        navigationController.pushViewController(favoritesVC, animated: true)
    }
}

