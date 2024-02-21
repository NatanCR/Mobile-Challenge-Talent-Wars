//
//  SetupRatingViewController.swift
//  Talent-Wars
//
//  Created by Natan de Camargo Rodrigues on 21/02/24.
//

import Foundation
import UIKit

class SetupRatingViewController {
    
    //MARK: - Buttons
    static func setupFavoriteButton(favoriteButton: UIButton, in view: UIView, youRatedThisLabel: UILabel) {
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
    }
    
    static func setupBackButton(backButton: UIButton, in view: UIView) {
        backButton.setTitle("Back to Search", for: .normal)
        let configuration = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium, scale: .default)
        if let backImage = UIImage(systemName: "chevron.left", withConfiguration: configuration) {
            backButton.setImage(backImage, for: .normal)
            backButton.tintColor = UIColor.white
        }
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        backButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        backButton.setTitleColor(UIColor.white, for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
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
    
    static func setupGoFavoritesButton(goToFavoritesButton: UIButton, in view: UIView) {
        // Configure the button
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
    }
    
    //MARK: - View Layout
    static func setupViews(backgroundImageView: UIImageView, posterImageView: UIImageView, titleLabel: UILabel, in view: UIView) {
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
    
    static func setupLayout(backgroundImageView: UIImageView, greenBackgroundView: UIView, posterImageView: UIImageView, movieTitleLabel: UILabel, youRatedThisLabel: UILabel, in view: UIView) {
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
}
