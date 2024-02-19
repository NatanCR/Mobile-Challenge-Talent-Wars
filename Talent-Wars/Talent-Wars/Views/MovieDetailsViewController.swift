//
//  MovieDetailsViewController.swift
//  Talent-Wars
//
//  Created by Natan de Camargo Rodrigues on 18/02/24.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    var coordinator: Coordinator?
    
    // Subviews
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let posterImageView = UIImageView()
    let movieImageView = UIImageView()
    let titleLabel = UILabel()
    let ratingLabel = UILabel()
    let genresLabel = UILabel()
    let overviewTextView = UITextView()
    let releaseDate = UILabel()
    let userScore = UILabel()
    let overviewTitle = UILabel()
    let goFavButton = UIButton(type: .system)
    let backButton = UIButton(type: .system)
    let viewMovieTitle = UILabel()
    let favoriteButton = UIButton(type: .system)
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
        
        setupScrollView()
        setupViews()
        setupLayout()
        setupGoFavButton()
        setupRateItMyselfButton()
        setupBackButton()
        setupFavoriteButton()
        setupUserScoreProgressView()
    }
    
    //MARK: - Buttons
    
    private func setupBackButton() {
        backButton.setTitle("Back to Search", for: .normal) // Or use an arrow icon
        let configuration = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium, scale: .default)
        if let backImage = UIImage(systemName: "chevron.left", withConfiguration: configuration) {
            backButton.setImage(backImage, for: .normal)
            backButton.tintColor = UIColor.white
        }
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        backButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        backButton.setTitleColor(UIColor.white, for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        backButton.layer.cornerRadius = 12
        
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
        // Or, if you're presenting modally:
        dismiss(animated: true, completion: nil)
    }
    
    private func setupGoFavButton() {
        // Set up the button
        goFavButton.setTitle("View Favs", for: .normal)
        goFavButton.backgroundColor = UIColor(named: "goFavButton")
        goFavButton.setTitleColor(UIColor(named: "labelFavButton"), for: .normal)
        goFavButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        goFavButton.layer.shadowColor = UIColor.black.cgColor // The shadow color
        goFavButton.layer.shadowOffset = CGSize(width: 0, height: 4) // The direction and distance of the shadow
        goFavButton.layer.shadowOpacity = 0.5 // The transparency of the shadow
        goFavButton.layer.shadowRadius = 5 // How blurred the shadow will be
        
        // Apply rounded corners
        goFavButton.layer.cornerRadius = 30 // Adjust the value as needed
        goFavButton.clipsToBounds = false
        
        // Adding the button to the view and setting up constraints
        contentView.addSubview(goFavButton)
        goFavButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            goFavButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 80),
            goFavButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -270),
            goFavButton.widthAnchor.constraint(equalToConstant: 150),
            goFavButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        goFavButton.addTarget(self, action: #selector(goFavTapped), for: .touchUpInside)
    }
    
    @objc func goFavTapped() {
        coordinator?.showFavorites()
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
            favoriteButton.bottomAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: -30), // Adjust as necessary
            favoriteButton.leadingAnchor.constraint(equalTo: movieImageView.leadingAnchor, constant: 150), // Adjust as necessary
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
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupViews() {
        // Configure and add subviews
        viewMovieTitle.font = UIFont(name: "Jomhuria-Regular", size: 80)
        viewMovieTitle.textColor = UIColor.white
        movieImageView.contentMode = .scaleAspectFill
        movieImageView.clipsToBounds = true
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        releaseDate.font = UIFont.systemFont(ofSize: 13)
        releaseDate.textColor = UIColor(named: "grayLabel")
        genresLabel.font = UIFont.systemFont(ofSize: 13)
        genresLabel.textColor = UIColor(named: "grayLabel")
        ratingLabel.font = UIFont.boldSystemFont(ofSize: 20)
        userScore.font = UIFont.systemFont(ofSize: 13)
        overviewTitle.font = UIFont.boldSystemFont(ofSize: 18)
        overviewTextView.isEditable = false
        overviewTextView.font = UIFont.systemFont(ofSize: 16)
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 8
        posterImageView.layer.borderWidth = 1
        posterImageView.layer.borderColor = UIColor.lightGray.cgColor
        
        
        // Add subviews to contentView
        [viewMovieTitle, movieImageView, posterImageView, titleLabel, releaseDate, genresLabel, ratingLabel, userScore, overviewTitle, overviewTextView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            
            contentView.bringSubviewToFront(viewMovieTitle)
        }
    }
    
    //MARK: - Layout Position
    private func setupLayout() {
        // Set up constraints
        
        NSLayoutConstraint.activate([
            viewMovieTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60),
            viewMovieTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            movieImageView.topAnchor.constraint(equalTo: view.topAnchor),
            movieImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movieImageView.heightAnchor.constraint(equalToConstant: 300), // example height
            
            titleLabel.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 160),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            releaseDate.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            releaseDate.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 160),
            
            genresLabel.topAnchor.constraint(equalTo: releaseDate.bottomAnchor, constant: 8),
            genresLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 160),
            
            ratingLabel.topAnchor.constraint(equalTo: genresLabel.bottomAnchor, constant: 8),
            ratingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 160),
            
            userScore.topAnchor.constraint(equalTo: genresLabel.bottomAnchor, constant: 14),
            userScore.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 230),
            
            overviewTitle.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 130),
            overviewTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            overviewTextView.topAnchor.constraint(equalTo: overviewTitle.bottomAnchor, constant: 10),
            overviewTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            overviewTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            overviewTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            overviewTextView.heightAnchor.constraint(equalToConstant: 200),
            
            posterImageView.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: -50),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.widthAnchor.constraint(equalToConstant: 130), // Set width as necessary
            posterImageView.heightAnchor.constraint(equalToConstant: 180)
        ])
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
            loadImage(fromPath: backdropPath, into: movieImageView) // Assuming movieImageView is the UIImageView for the background image
        }
        
        // Load and set the poster image
        if let posterPath = movie.posterPath {
            loadImage(fromPath: posterPath, into: posterImageView) // Make sure you have somePosterImageView
        }
        
        // Set the list of genres
        genresLabel.text = genreNames(from: movie.genreIDs)
    }
    
    private func loadImage(fromPath path: String, into imageView: UIImageView) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(path)") else {
            imageView.image = nil // Or a default image
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            } else {
                DispatchQueue.main.async {
                    imageView.image = nil // Or error/default image
                }
            }
        }.resume()
    }
}
