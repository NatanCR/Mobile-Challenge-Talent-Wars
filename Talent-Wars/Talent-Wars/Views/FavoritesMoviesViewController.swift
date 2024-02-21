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
    private let backButton = UIButton(type: .system)
    private let headerView = UIView()
    private let searchMoreButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        SetupFavoritesMoviesViewController.setupHeaderView(headerView: headerView, in: self.view)
        SetupFavoritesMoviesViewController.setupBackButton(backButton: backButton, headerView: headerView, in: self.view)
        SetupFavoritesMoviesViewController.setupTitleLabel(titleLabel: titleLabel, in: self.view, headerView: headerView)
        setupCollectionView()
        loadFavoriteMovies()
        SetupFavoritesMoviesViewController.setupSearchButton(searchMoreButton: searchMoreButton, in: self.view)
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        searchMoreButton.addTarget(self, action: #selector(searchMoreButtonTapped), for: .touchUpInside)
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
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
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
