//
//  RatingViewController.swift
//  Talent-Wars
//
//  Created by Natan de Camargo Rodrigues on 19/02/24.
//

import UIKit

class RatingViewController: UIViewController, CoordinatingViewController {
    var coordinator: Coordinator?
    var movie: Movie?
    
    private let backgroundImageView = UIImageView()
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    var backButton = UIButton(type: .system)
    private let greenBackgroundView = UIView()
    private let movieTitleLabel = UILabel()
    private let youRatedThisLabel = UILabel()
    let favoriteButton = UIButton(type: .system)
    private let goToFavoritesButton = UIButton(type: .system)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewConfig()
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        goToFavoritesButton.addTarget(self, action: #selector(goToFavoritesButtonTapped), for: .touchUpInside)
    }
    
    
    func setupViewConfig() {
        SetupRatingViewController.setupViews(backgroundImageView: backgroundImageView, posterImageView: posterImageView, titleLabel: titleLabel, in: view)
        SetupRatingViewController.setupLayout(backgroundImageView: backgroundImageView, greenBackgroundView: greenBackgroundView, posterImageView: posterImageView, movieTitleLabel: movieTitleLabel, youRatedThisLabel: youRatedThisLabel, in: view)
        configureViewsWithMovie()
        SetupRatingViewController.setupBackButton(backButton: backButton, in: view)
        SetupRatingViewController.setupFavoriteButton(favoriteButton: favoriteButton, in: view, youRatedThisLabel: youRatedThisLabel)
        SetupRatingViewController.setupGoFavoritesButton(goToFavoritesButton: goToFavoritesButton, in: view)
        setupRateResetButton()
    }
    //MARK: - Buttons actions
    
    @objc func favoriteButtonTapped() {
        guard let movie = movie else { return }
        
        let isFavorite = FavoritesManager.shared.isFavorite(movieId: movie.id)
        if isFavorite {
            FavoritesManager.shared.removeFavorite(movieId: movie.id)
            // Update UI to reflect it's no longer favorite
            updateFavoriteButton(isFavorite: false)
        } else {
            FavoritesManager.shared.addFavorite(movie: movie)
            // Update UI to reflect it's favorite
            updateFavoriteButton(isFavorite: true)
        }
    }
    
    private func updateFavoriteButton(isFavorite: Bool) {
        let imageName = isFavorite ? "star.fill" : "star"
        let configuration = UIImage.SymbolConfiguration(pointSize: 28, weight: .medium, scale: .default)
        let starImage = UIImage(systemName: imageName, withConfiguration: configuration)?.withTintColor(UIColor(named: "favButton") ?? .orange, renderingMode: .alwaysOriginal)
        favoriteButton.setImage(starImage, for: .normal)
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func goToFavoritesButtonTapped() {
        coordinator?.showFavorites()
    }
    
    private func setupRateResetButton() {
        let buttonView = UIView()
        buttonView.backgroundColor = UIColor.systemBrown.withAlphaComponent(0.7) // Color for top part
        buttonView.layer.cornerRadius = 15
        buttonView.clipsToBounds = true
        buttonView.layer.shadowColor = UIColor.black.cgColor
        buttonView.layer.shadowOffset = CGSize(width: 0, height: 2)
        buttonView.layer.shadowRadius = 2
        buttonView.layer.shadowOpacity = 0.5
        
        let topLabel = UILabel()
        topLabel.text = "You’ve rated this"
        topLabel.font = UIFont.systemFont(ofSize: 16)
        topLabel.textColor = .white
        topLabel.backgroundColor = UIColor(named: "rateResetButton") // Color for top part
        topLabel.textAlignment = .center
        
        let bottomLabel = UILabel()
        bottomLabel.text = "click to reset"
        bottomLabel.font = UIFont.systemFont(ofSize: 12)
        bottomLabel.textColor = UIColor(named: "rateResetButton")
        bottomLabel.backgroundColor = .black // Color for bottom part
        bottomLabel.textAlignment = .center
        
        buttonView.addSubview(topLabel)
        buttonView.addSubview(bottomLabel)
        
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: buttonView.topAnchor),
            topLabel.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor),
            topLabel.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor),
            topLabel.heightAnchor.constraint(equalTo: buttonView.heightAnchor, multiplier: 0.6),
            
            bottomLabel.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor),
            bottomLabel.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor),
            bottomLabel.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor),
            bottomLabel.heightAnchor.constraint(equalTo: buttonView.heightAnchor, multiplier: 0.4),
        ])
        
        // Adding subview and setting constraints
        view.addSubview(buttonView)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -260),
            buttonView.widthAnchor.constraint(equalToConstant: 150),
            buttonView.heightAnchor.constraint(equalToConstant: 60),
        ])
        
    }
 
    private func configureViewsWithMovie() {
        guard let movie = movie else { return }
        
        // Set movie title
        movieTitleLabel.text = movie.title
        
        // Load and set background image
        if let backdropPath = movie.backdropPath {
            backgroundImageView.loadImage(fromPath: backdropPath)
        }
        
        // Load and set poster image
        if let posterPath = movie.posterPath {
            posterImageView.loadImage(fromPath: posterPath)
        }
    }
}

