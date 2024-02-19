//
//  HomeViewViewController.swift
//  Talent-Wars
//
//  Created by Natan de Camargo Rodrigues on 18/02/24.
//

import UIKit

class HomeViewController: UIViewController, UISearchBarDelegate {
    var coordinator: Coordinator?
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    
    var viewModel = HomeViewModel() // Instantiating the ViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting the view's title.
        title = "Popular Right now"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "homeBG") // The background color
        appearance.titleTextAttributes = [
            .font: UIFont(name: "Jomhuria-Regular", size: 40) ?? UIFont.systemFont(ofSize: 40), .foregroundColor: UIColor(named: "homeTitle") ?? UIColor.white
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        tableView.separatorStyle = .none
        searchBar.delegate = self
        
        viewModel.onMoviesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.fetchMoviesFromAPI()
        setupTableView()
        setupSearchBar()
        setupLayout()
        bindViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    // Implementation of UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterMovies(with: searchText)
        
        if searchText.isEmpty {
            title = "Popular Right now" // Title for the full list
        } else {
            title = "Your Results" // Title for the search results
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        viewModel.filterMovies(with: "")
        title = "Popular Right now" // Restore the original title
        searchBar.resignFirstResponder() // Hides the keyboard
    }
    
    private func bindViewModel() {
        viewModel.onMoviesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    private func setupTableView() {
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupSearchBar() {
        searchBar.placeholder = "Search"
    }
    
    private func setupLayout() {
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}


extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
        let movie = viewModel.filteredMovies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let coordinator = coordinator as? FlowCoordinatorController else { return }
        let movie = viewModel.filteredMovies[indexPath.row]
        coordinator.showMovieDetails(for: movie)
    }
}

