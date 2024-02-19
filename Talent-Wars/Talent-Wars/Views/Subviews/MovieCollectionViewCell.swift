//
//  MovieCollectionViewCell.swift
//  Talent-Wars
//
//  Created by Natan de Camargo Rodrigues on 19/02/24.
//

import Foundation
import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    let posterImageView = UIImageView()
    let favoriteButton = UIButton()
    let ratingLabel = UILabel()
    let ratingValueLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Setup of posterImageView
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 8
        contentView.addSubview(posterImageView)
        
        // Setup of favoriteButton
        let configuration = UIImage.SymbolConfiguration(pointSize: 28, weight: .medium, scale: .default)
        let starImage = UIImage(systemName: "star.fill", withConfiguration: configuration)?.withTintColor(UIColor(named: "favButton") ?? .orange, renderingMode: .alwaysOriginal)
        favoriteButton.setImage(starImage, for: .normal)
        favoriteButton.backgroundColor = .white
        favoriteButton.tintColor = .yellow
        favoriteButton.layer.cornerRadius = 25 // Adjust to half the size of the button so it's a circle
        favoriteButton.layer.shadowColor = UIColor.black.cgColor // The color of the shadow
        favoriteButton.layer.shadowOffset = CGSize(width: 0, height: 4) // The direction and distance of the shadow
        favoriteButton.layer.shadowOpacity = 0.5 // The transparency of the shadow
        favoriteButton.layer.shadowRadius = 5 // How blurred the shadow will be
        
        // Applies rounded corners
        favoriteButton.clipsToBounds = false
        contentView.addSubview(favoriteButton)
        
        // Setup of ratingLabel
        ratingLabel.text = "My Rating"
        ratingLabel.textAlignment = .center
        contentView.addSubview(ratingLabel)
        
        // Setup of ratingValueLabel
        ratingValueLabel.textAlignment = .center
        contentView.addSubview(ratingValueLabel)
    }
    
    private func setupLayout() {
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10), // Add space at the top
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10), // Add space on the left
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10), // Add space on the right
            
            // Constraints for favoriteButton below posterImageView
            favoriteButton.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: -30),
            favoriteButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 50),
            favoriteButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Constraints for ratingLabel below favoriteButton
            ratingLabel.topAnchor.constraint(equalTo: favoriteButton.bottomAnchor, constant: 4),
            ratingLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // Constraints for ratingValueLabel below ratingLabel
            ratingValueLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 2),
            ratingValueLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            ratingValueLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
            
        ])
    }
    
    func configure(with movie: Movie) {
        // Configure the cell with the movie data
        if let posterPath = movie.posterPath {
            loadImage(fromPath: posterPath, into: posterImageView)
        }
        //        ratingValueLabel.text = "\(movie.voteAverage)"
        ratingValueLabel.text = "0"
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
