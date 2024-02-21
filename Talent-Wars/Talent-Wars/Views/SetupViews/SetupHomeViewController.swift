//
//  SetupHomeViewController.swift
//  Talent-Wars
//
//  Created by Natan de Camargo Rodrigues on 21/02/24.
//

import Foundation
import UIKit

class SetupHomeViewController {
    //MARK: - View Title Label
    static func setupTitleLabel(_ titleView: UILabel, in view: UIView) {
        titleView.text = "Popular Right now"
        titleView.textAlignment = .center
        titleView.font = UIFont(name: "Jomhuria-Regular", size: 60)
        titleView.textColor = UIColor(named: "homeTitle")
        
        view.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            titleView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    //MARK: - Search Bar
    static func setupSearchTextField(_ searchBar: UITextField) {
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: 17)
        ]
        
        // Set the attributedPlaceholder property with the NSAttributedString
        searchBar.attributedPlaceholder = NSAttributedString(string: "Search", attributes: placeholderAttributes)
        searchBar.borderStyle = .none
        searchBar.backgroundColor = UIColor.white
        searchBar.clearButtonMode = .whileEditing
        searchBar.returnKeyType = .search
        
        searchBar.layer.cornerRadius = 26
        searchBar.layer.masksToBounds = true
        
        // Setting the font and text alignment
        searchBar.font = UIFont.boldSystemFont(ofSize: 17)
        searchBar.textAlignment = .left
        
        // Setting padding for the left side of the text field
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: searchBar.frame.height))
        searchBar.leftView = paddingView
        searchBar.leftViewMode = .always
        
        // Setting the clear button
        searchBar.clearButtonMode = .whileEditing
    }
    
    //MARK: - TableView
    static func setupTableView(_ tableView: UITableView, dataSource: UITableViewDataSource, delegate: UITableViewDelegate) {
            tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieTableViewCell")
            tableView.dataSource = dataSource
            tableView.delegate = delegate
        }
    
    
    
    //MARK: - View Layout
    static func setupLayout(in view: UIView, tableView: UITableView, searchBar: UITextField, greenBackgroundView: UIView) {
        
        view.addSubview(greenBackgroundView)
        view.addSubview(tableView)
        view.addSubview(searchBar)
        
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        greenBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.backgroundColor = .white
        greenBackgroundView.backgroundColor = UIColor(named: "homeBG")
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            
            // Green background view constraints
            greenBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            greenBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            greenBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            greenBackgroundView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            
            tableView.topAnchor.constraint(equalTo: greenBackgroundView.topAnchor, constant: 250),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
