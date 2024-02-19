//
//  RatingViewController.swift
//  Talent-Wars
//
//  Created by Natan de Camargo Rodrigues on 19/02/24.
//

import UIKit

class RatingViewController: UIViewController {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
        configureViewsWithMovie()
        setupBackButton()
        setupFavoriteButton()
        setupGoFavoritesButton()
        setupRateResetButton()
    }
    
    private func setupFavoriteButton() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 28, weight: .medium, scale: .default)
        let starImage = UIImage(systemName: "star", withConfiguration: configuration)?.withTintColor(UIColor(named: "favButton") ?? .orange, renderingMode: .alwaysOriginal)
        favoriteButton.setImage(starImage, for: .normal)
        favoriteButton.backgroundColor = .white
        favoriteButton.tintColor = .yellow
        
        let buttonSize: CGFloat = 50
        favoriteButton.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        
        favoriteButton.layer.cornerRadius = buttonSize / 2
        favoriteButton.layer.masksToBounds = true
        
        
        // Adding the button to the view and setting its position and size
        view.addSubview(favoriteButton)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            favoriteButton.bottomAnchor.constraint(equalTo: youRatedThisLabel.bottomAnchor, constant: 125),
            favoriteButton.leadingAnchor.constraint(equalTo: youRatedThisLabel.leadingAnchor, constant: 230),
            favoriteButton.widthAnchor.constraint(equalToConstant: buttonSize),
            favoriteButton.heightAnchor.constraint(equalToConstant: buttonSize)
        ])
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    
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
    
    private func setupBackButton() {
        backButton = UIButton.createCustomButton(title: "Back to Search", imageName: "chevron.left", color: .white.withAlphaComponent(0.5))
        backButton.setTitleColor(UIColor.white, for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            backButton.widthAnchor.constraint(equalToConstant: 140),
            backButton.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    private func setupGoFavoritesButton() {
        // Configure the button
        let goToFavoritesButton = UIButton(type: .system)
        goToFavoritesButton.setTitle("Go to Favorites", for: .normal)
        goToFavoritesButton.backgroundColor = UIColor.white
        goToFavoritesButton.setTitleColor(UIColor.black, for: .normal)
        goToFavoritesButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        goToFavoritesButton.layer.shadowColor = UIColor.black.cgColor // The shadow color
        goToFavoritesButton.layer.shadowOffset = CGSize(width: 0, height: 4) // The direction and distance of the shadow
        goToFavoritesButton.layer.shadowOpacity = 0.5 // The transparency of the shadow
        goToFavoritesButton.layer.shadowRadius = 5 // How blurred the shadow will be
        
        // Apply rounded corners
        goToFavoritesButton.layer.cornerRadius = 30
        goToFavoritesButton.clipsToBounds = false
        
        view.addSubview(goToFavoritesButton)
        goToFavoritesButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            goToFavoritesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goToFavoritesButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -135),
            goToFavoritesButton.widthAnchor.constraint(equalToConstant: 250),
            goToFavoritesButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        goToFavoritesButton.addTarget(self, action: #selector(goToFavoritesButtonTapped), for: .touchUpInside)
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
        
        // Adding tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(rateButtonTapped))
        buttonView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func rateButtonTapped() {
        guard let movie = movie else { return }
        coordinator?.showRating(for: movie)
    }
    
    
    private func setupViews() {
        // Background image setup
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        view.addSubview(backgroundImageView)
        
        // Setup for posterImageView
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.layer.cornerRadius = 8
        posterImageView.layer.masksToBounds = true
        view.addSubview(posterImageView)
        
        // Setup for titleLabel
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        view.addSubview(titleLabel)
        
    }
    
    private func setupLayout() {
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        greenBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        movieTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        youRatedThisLabel.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        greenBackgroundView.backgroundColor = UIColor(named: "homeBG")
        
        movieTitleLabel.font = UIFont(name: "Jomhuria-Regular", size: 96)
        movieTitleLabel.textColor = .white
        movieTitleLabel.textAlignment = .center
        
        youRatedThisLabel.font = UIFont(name: "Jomhuria-Regular", size: 30)
        youRatedThisLabel.textColor = .white
        youRatedThisLabel.textAlignment = .center
        youRatedThisLabel.text = "You rated this"
        
        posterImageView.layer.borderColor = UIColor.white.cgColor
        posterImageView.layer.borderWidth = 4
        posterImageView.layer.cornerRadius = 8
        posterImageView.layer.masksToBounds = true
        
        view.addSubview(backgroundImageView)
        view.addSubview(greenBackgroundView)
        view.addSubview(posterImageView)
        view.addSubview(movieTitleLabel)
        view.addSubview(youRatedThisLabel)
        
        NSLayoutConstraint.activate([
            // Background image constraints
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            // Green background view constraints
            greenBackgroundView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor),
            greenBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            greenBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            greenBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Poster image constraints
            posterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            posterImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            posterImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 1.4),
            
            // Movie title label constraints
            movieTitleLabel.bottomAnchor.constraint(equalTo: backgroundImageView.centerYAnchor, constant: -8),
            movieTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            
            // "You rated this" label constraints
            youRatedThisLabel.bottomAnchor.constraint(equalTo: movieTitleLabel.topAnchor, constant: 110),
            youRatedThisLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
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

