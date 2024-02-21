//
//  HomeViewViewController.swift
//  Talent-Wars
//
//  Created by Natan de Camargo Rodrigues on 18/02/24.
//

import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate, CoordinatingViewController {
    var coordinator: Coordinator?
    
    private let tableView = UITableView()
    private let titleView = UILabel()
    private let greenBackgroundView = UIView()
    private var searchBar = UITextField()
    
    var viewModel = HomeViewModel() // Instantiating the ViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        searchBar.delegate = self
        
        viewModel.onMoviesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        setupViewConfig()
        bindViewModel()
    }
    
    func setupViewConfig() {
        viewModel.fetchMoviesFromAPI()
        SetupHomeViewController.setupLayout(in: self.view, tableView: tableView, searchBar: searchBar, greenBackgroundView: greenBackgroundView)
        SetupHomeViewController.setupSearchTextField(searchBar)
        SetupHomeViewController.setupTitleLabel(titleView, in: self.view)
        SetupHomeViewController.setupTableView(tableView, dataSource: self, delegate: self)
    }
    
    //MARK: - SearchBar
    // Implement UITextFieldDelegate methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let searchText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        viewModel.filterMovies(with: searchText)
        
        if searchText.isEmpty {
            titleView.text = "Popular Right now"
        } else {
            titleView.text = "Your Results"
        }
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        viewModel.filterMovies(with: "")
        titleView.text = "Popular Right now"
        textField.resignFirstResponder()
        return false
    }
    
    //MARK: - Reload Data
    private func bindViewModel() {
        viewModel.onMoviesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
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

