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
        let homeViewVC = HomeViewViewController()
        homeViewVC.coordinator = self
        navigationController.pushViewController(homeViewVC, animated: false)
    }
    
    func showMovieDetails(for movie: Movie) {
           let detailsVC = MovieDetailsViewController()
           detailsVC.movie = movie
           navigationController.pushViewController(detailsVC, animated: true)
       }
    
    func showFavorites() {
            let favoritesVC = FavoritesMoviesViewController()
            // Aqui você pode configurar o FavoritesViewController com os filmes favoritos
            // Por exemplo, passando os IDs dos filmes favoritos para ele
            navigationController.pushViewController(favoritesVC, animated: true)
        }
}
