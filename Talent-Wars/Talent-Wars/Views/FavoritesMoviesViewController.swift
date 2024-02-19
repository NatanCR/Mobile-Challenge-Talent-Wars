//
//  FavoritesMoviesViewController.swift
//  Talent-Wars
//
//  Created by Natan de Camargo Rodrigues on 18/02/24.
//

import UIKit

class FavoritesMoviesViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var viewModel = HomeViewModel() // Added to use the data model
    weak var coordinator: FlowCoordinatorController?
    
    var favoriteMovies: [Movie] = [] // Here should have the favorite movies to display
    var favoriteMovieIds: [Int] = []
    
    private let titleLabel = UILabel()
    let backButton = UIButton(type: .system)
    private let headerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHeaderView()
        setupBackButton()
        setupTitleLabel()
        setupCollectionView()
        loadFavoriteMovies()
        setupSearchButton()
    }
    
    private func setupHeaderView() {
        headerView.backgroundColor = UIColor(named: "homeBG")

        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 98)
        ])
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let itemWidth = view.frame.width * 0.35
        let itemHeight = view.frame.height * 0.35
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20) // Spacing between items and collectionView border
        
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCollectionViewCell")
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4)
        ])
    }
    
    private func setupBackButton() {
        backButton.setTitle("Back", for: .normal)
        let configuration = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium, scale: .default)
        if let backImage = UIImage(systemName: "chevron.left", withConfiguration: configuration) {
            backButton.setImage(backImage, for: .normal)
            backButton.tintColor = UIColor.black
        }
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        backButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        backButton.setTitleColor(UIColor.black, for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        backButton.layer.cornerRadius = 12
        
        headerView.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            backButton.widthAnchor.constraint(equalToConstant: 80),
            backButton.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "My Favorites" // The title text
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Jomhuria-Regular", size: 96)
        titleLabel.textColor = UIColor(named: "homeTitle")

        headerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func loadFavoriteMovies() {
        let favoriteMoviesData = FavoritesManager.shared.getFavoriteMovies()
        favoriteMovies = favoriteMoviesData.map { favorite in
            // Creating a Movie object from FavoriteMovie data
            return Movie(id: favorite.id,
                         title: "", // Default value or retrieve from elsewhere if needed
                         releaseDate: "",
                         voteAverage: "",
                         overview: "",
                         backdropPath: nil,
                         posterPath: favorite.posterPath,
                         genreIDs: [])
        }
        collectionView.reloadData()
        
    }
    
    private func setupSearchButton() {
        // Configure the button
        let searchMoreButton = UIButton(type: .system)
        searchMoreButton.setTitle("Search for More", for: .normal)
        searchMoreButton.backgroundColor = UIColor(named: "searchButton")
        searchMoreButton.setTitleColor(UIColor.black, for: .normal)
        searchMoreButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        searchMoreButton.layer.shadowColor = UIColor.black.cgColor // The shadow color
        searchMoreButton.layer.shadowOffset = CGSize(width: 0, height: 4) // The direction and distance of the shadow
        searchMoreButton.layer.shadowOpacity = 0.5 // The transparency of the shadow
        searchMoreButton.layer.shadowRadius = 5 // How blurry the shadow will be
        
        // Apply rounded corners
        searchMoreButton.layer.cornerRadius = 30
        searchMoreButton.clipsToBounds = false
        
        
        view.addSubview(searchMoreButton)
        searchMoreButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchMoreButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchMoreButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            searchMoreButton.widthAnchor.constraint(equalToConstant: 250),
            searchMoreButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        searchMoreButton.addTarget(self, action: #selector(searchMoreButtonTapped), for: .touchUpInside)
    }
    
    @objc private func searchMoreButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension FavoritesMoviesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as? MovieCollectionViewCell else {
            fatalError("Unable to dequeue MovieCollectionViewCell")
        }
        let movie = favoriteMovies[indexPath.item]
        cell.configure(with: movie)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension FavoritesMoviesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Item selection action, such as showing movie details
    }
}
