//
//  SetupFavoritesMoviesViewController.swift
//  Talent-Wars
//
//  Created by Natan de Camargo Rodrigues on 21/02/24.
//

import Foundation
import UIKit

class SetupFavoritesMoviesViewController {
    
    //MARK: - Setup View Layout
    static func setupHeaderView(headerView: UIView, in view: UIView) {
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
    
    static func setupTitleLabel(titleLabel: UILabel, in view: UIView, headerView: UIView) {
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
    
    //MARK: - Buttons
    static func setupBackButton(backButton: UIButton, headerView: UIView, in view: UIView) {
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
//        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
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
    
    static func setupSearchButton(searchMoreButton: UIButton, in view: UIView) {
        // Configure the button
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
        
//        searchMoreButton.addTarget(self, action: #selector(searchMoreButtonTapped), for: .touchUpInside)
    }
}
