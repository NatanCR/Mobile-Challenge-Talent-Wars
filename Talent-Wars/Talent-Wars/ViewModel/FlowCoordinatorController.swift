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
        detailsVC.coordinator = self  // Certifique-se de que esta linha está presente
        detailsVC.movie = movie
        navigationController.pushViewController(detailsVC, animated: true)
    }
    
    func showFavorites() {
        //        let favoritesVC = FavoritesMoviesViewController()
        //        favoritesVC.favoriteMovieIds = FavoritesManager.shared.getFavoriteMovieIds()
        //        navigationController.pushViewController(favoritesVC, animated: true)
        
        let favoritesVC = FavoritesMoviesViewController()
        favoritesVC.coordinator = self
        // Obtendo os filmes favoritos e passando-os para a FavoritesMoviesViewController
        let favoriteMovies = FavoritesManager.shared.getFavoriteMovies().map { favorite in
            // Aqui você cria instâncias de Movie a partir dos dados de FavoriteMovie
            // Adapte para corresponder à sua estrutura de Movie
            return Movie(id: favorite.id,
                         title: "", // Valor padrão ou outro apropriado
                         releaseDate: "",
                         voteAverage: "",
                         overview: "",
                         backdropPath: nil,
                         posterPath: favorite.posterPath,
                         genreIDs: [])
        }
        
        // Configurando a lista de filmes favoritos na FavoritesMoviesViewController
        favoritesVC.favoriteMovies = favoriteMovies
        navigationController.pushViewController(favoritesVC, animated: true)
    }
}

