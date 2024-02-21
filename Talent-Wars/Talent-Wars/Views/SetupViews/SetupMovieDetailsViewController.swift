//
//  SetupMovieDetailsViewController.swift
//  Talent-Wars
//
//  Created by Natan de Camargo Rodrigues on 21/02/24.
//

import Foundation
import UIKit

class SetupMovieDetailsViewController {
    //MARK: - ScrollView
    static func setupScrollView(_ scrollView: UIScrollView, contentView: UIView, in view: UIView) {
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
    
    //MARK: - Buttons
    static func setupGoFavButton(_ goFavButton: UIButton, in view: UIView, action: Selector, contentView: UIView) {
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
        
    }
    
    static func setupBackButton(_ backButtonVC: UIButton, in view: UIView, action: Selector) {
        var backButton = backButtonVC
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
    }
    
    static func setupFavoriteButton(_ favoriteButton: UIButton, in view: UIView, movieImageView: UIImageView, action: Selector) {
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
    }
    
    //MARK: - Layout Position
    static func setupViews(viewMovieTitle: UILabel, movieImageView: UIImageView, titleLabel: UILabel, releaseDate: UILabel, genresLabel: UILabel, ratingLabel: UILabel, userScore: UILabel, overviewTitle: UILabel, overviewTextView: UITextView, posterImageView: UIImageView, contentView: UIView) {
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
    
    static func setupLayout(viewMovieTitle: UILabel, movieImageView: UIImageView, contentView: UIView, in view: UIView, titleLabel: UILabel, releaseDate: UILabel, genresLabel: UILabel, ratingLabel: UILabel, userScore: UILabel, overviewTitle: UILabel, overviewTextView: UITextView, posterImageView: UIImageView) {
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
}
