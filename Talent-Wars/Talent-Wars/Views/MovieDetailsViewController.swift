//
//  MovieDetailsViewController.swift
//  Talent-Wars
//
//  Created by Natan de Camargo Rodrigues on 18/02/24.
//

import UIKit

class MovieDetailsViewController: UIViewController, CoordinatingViewController {
    var coordinator: Coordinator?
    
    // Subviews
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let posterImageView = UIImageView()
    private let movieImageView = UIImageView()
    private let titleLabel = UILabel()
    private let ratingLabel = UILabel()
    private let genresLabel = UILabel()
    private let overviewTextView = UITextView()
    private let releaseDate = UILabel()
    private let userScore = UILabel()
    private let overviewTitle = UILabel()
    private let goFavButton = UIButton(type: .system)
    private var backButton = UIButton(type: .system)
    private let viewMovieTitle = UILabel()
    private let favoriteButton = UIButton(type: .system)
    private let userScoreProgressView = UIProgressView(progressViewStyle: .bar)
    
    var movie: Movie? {
        didSet {
            configureViewsWithMovie()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.isHidden = true
        
        SetupMovieDetailsViewController.setupScrollView(scrollView, contentView: contentView, in: view)
        SetupMovieDetailsViewController.setupViews(viewMovieTitle: viewMovieTitle, movieImageView: movieImageView, titleLabel: titleLabel, releaseDate: releaseDate, genresLabel: genresLabel, ratingLabel: ratingLabel, userScore: userScore, overviewTitle: overviewTitle, overviewTextView: overviewTextView, posterImageView: posterImageView, contentView: contentView)
        SetupMovieDetailsViewController.setupLayout(viewMovieTitle: viewMovieTitle, movieImageView: movieImageView, contentView: contentView, in: view, titleLabel: titleLabel, releaseDate: releaseDate, genresLabel: genresLabel, ratingLabel: ratingLabel, userScore: userScore, overviewTitle: overviewTitle, overviewTextView: overviewTextView, posterImageView: posterImageView)
        SetupMovieDetailsViewController.setupGoFavButton(goFavButton, in: view, contentView: contentView)

        setupRateItMyselfButton()
        setupBackButton()
        SetupMovieDetailsViewController.setupFavoriteButton(favoriteButton, in: view, movieImageView: movieImageView)

        setupUserScoreProgressView()
        
        goFavButton.addTarget(self, action: #selector(goFavTapped), for: .touchUpInside)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - Buttons actions
    
    private func setupBackButton() {
        backButton = UIButton.createCustomButton(title: "Back to Search", imageName: "chevron.left", color: .white.withAlphaComponent(0.5))
        backButton.setTitleColor(UIColor.white, for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            backButton.widthAnchor.constraint(equalToConstant: 140),
            backButton.heightAnchor.constraint(equalToConstant: 28)
        ])
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func goFavTapped() {
        coordinator?.showFavorites()
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
    
    private func setupRateItMyselfButton() {
        let buttonView = UIView()
        buttonView.backgroundColor = UIColor.systemBrown.withAlphaComponent(0.7) // Color for top part
        buttonView.layer.cornerRadius = 15
        buttonView.clipsToBounds = true
        buttonView.layer.shadowColor = UIColor.black.cgColor
        buttonView.layer.shadowOffset = CGSize(width: 0, height: 2)
        buttonView.layer.shadowRadius = 2
        buttonView.layer.shadowOpacity = 0.5
        
        let topLabel = UILabel()
        topLabel.text = "Rate it myself"
        topLabel.font = UIFont.systemFont(ofSize: 16)
        topLabel.textColor = .white
        topLabel.backgroundColor = UIColor(named: "ratingButton") // Color for top part
        topLabel.textAlignment = .center
        
        let bottomLabel = UILabel()
        bottomLabel.text = "add personal rating"
        bottomLabel.font = UIFont.systemFont(ofSize: 12)
        bottomLabel.textColor = UIColor(named: "addRating")
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
        
        // Adding subview and configuring constraints
        contentView.addSubview(buttonView)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -90),
            buttonView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -270),
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
    
    //MARK: - View Configuration
    
    private func setupUserScoreProgressView() {
        userScoreProgressView.translatesAutoresizingMaskIntoConstraints = false
        userScoreProgressView.progressTintColor = UIColor(named: "progressView")
        userScoreProgressView.trackTintColor = UIColor(named: "progressViewDefault")
        contentView.addSubview(userScoreProgressView)
        
        let margin: CGFloat = 60 // Margin to the right of the screen
        
        NSLayoutConstraint.activate([
            userScoreProgressView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 15), // Space after the poster
            userScoreProgressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin), // Margin to the right of the screen
            userScoreProgressView.centerYAnchor.constraint(equalTo: userScore.centerYAnchor, constant: 20), // Vertical alignment with the score label
            userScoreProgressView.heightAnchor.constraint(equalToConstant: 4) // Height of the progress bar
        ])
        
        updateProgressView(with: movie?.voteAverage ?? "")
    }
    
    private func updateProgressView(with percentageString: String) {
        // Replace "%" with empty and convert to Float
        let percentageValue = (percentageString.replacingOccurrences(of: "%", with: "") as NSString).floatValue
        // Convert to a fraction of 1 (e.g., 70% becomes 0.7)
        let progressValue = percentageValue / 100.0
        // Set the progress of the progress bar
        userScoreProgressView.setProgress(progressValue, animated: true)
    }
    
    //MARK: - Elements Config
    
    private func genreNames(from ids: [Int]) -> String {
        let genreDictionary = [28: "Action", 12: "Adventure", 16: "Animation", 35: "Comedy", 80: "Crime", 99: "Documentary", 18: "Drama", 10751: "Family", 14: "Fantasy", 36: "History", 27: "Horror", 10402: "Music", 9648: "Mystery", 10749: "Romance", 878: "Science Fiction", 10770: "TV Movie", 53: "Thriller", 10752: "War", 37: "Western"]
        
        // Join the genre names into a string separated by commas
        return ids.compactMap { genreDictionary[$0] }.joined(separator: ", ")
    }
    
    private func configureViewsWithMovie() {
        guard let movie = movie else { return }
        
        viewMovieTitle.text = movie.title
        titleLabel.text = movie.title
        releaseDate.text = movie.releaseDate
        ratingLabel.text = movie.voteAverage
        overviewTextView.text = movie.overview
        userScore.text = "user score"
        overviewTitle.text = "Overview"
        
        // Load and set the background image
        if let backdropPath = movie.backdropPath {
            movieImageView.loadImage(fromPath: backdropPath) // Assuming movieImageView is the UIImageView for the background image
        }
        
        // Load and set the poster image
        if let posterPath = movie.posterPath {
            posterImageView.loadImage(fromPath: posterPath) // Make sure you have somePosterImageView
        }
        
        // Set the list of genres
        genresLabel.text = genreNames(from: movie.genreIDs)
    }
}
