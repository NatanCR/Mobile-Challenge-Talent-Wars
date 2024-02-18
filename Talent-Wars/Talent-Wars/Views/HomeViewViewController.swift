//
//  HomeViewViewController.swift
//  Talent-Wars
//
//  Created by Natan de Camargo Rodrigues on 18/02/24.
//

import UIKit

class HomeViewViewController: UIViewController, UISearchBarDelegate {
    var coordinator: Coordinator?
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    
    var viewModel = HomeViewModel() // Instanciando o ViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Defina o título da view.
        title = "Popular Right now"
        
        // Defina a cor de fundo da view para verde na área acima da tableView.
        view.backgroundColor = UIColor.green
        
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

        // Reverte para a aparência padrão da UINavigationBar
        navigationController?.navigationBar.standardAppearance = UINavigationBarAppearance()
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
    }
    
    // Implementação do UISearchBarDelegate
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            viewModel.filterMovies(with: searchText)
        }

        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.text = ""
            viewModel.filterMovies(with: "")
            searchBar.resignFirstResponder() // Esconde o teclado
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
        // Adicione mais configurações de searchBar se necessário
    }
    
    private func setupLayout() {
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        // A cor de fundo deve ser definida diretamente na searchBar e na tableView.
        searchBar.backgroundColor = .green
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


extension HomeViewViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel.filteredMovies.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
            let movie = viewModel.filteredMovies[indexPath.row]
            cell.configure(with: movie)
            return cell
        }
}

