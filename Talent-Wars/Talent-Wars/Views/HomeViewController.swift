//
//  HomeViewViewController.swift
//  Talent-Wars
//
//  Created by Natan de Camargo Rodrigues on 18/02/24.
//

import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate {
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
        
        viewModel.fetchMoviesFromAPI()
        setupTableView()
        setupLayout()
        setupSearchTextField()
        setupTitleLabel()
        bindViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
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
    
    private func setupSearchTextField() {
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black, // Change to your desired placeholder color
            .font: UIFont.boldSystemFont(ofSize: 17) // You can also set the font here if needed
        ]
        
        // Set the attributedPlaceholder property with the NSAttributedString
        searchBar.attributedPlaceholder = NSAttributedString(string: "Search", attributes: placeholderAttributes)
        searchBar.borderStyle = .none
        searchBar.backgroundColor = UIColor.white
        searchBar.clearButtonMode = .whileEditing
        searchBar.returnKeyType = .search
        
        searchBar.layer.cornerRadius = 26
        searchBar.layer.masksToBounds = true
        
        // Set the font and text alignment
        searchBar.font = UIFont.boldSystemFont(ofSize: 17)
        searchBar.textAlignment = .left
        
        // Set padding for the left side of the text field
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: searchBar.frame.height))
        searchBar.leftView = paddingView
        searchBar.leftViewMode = .always
        
        // Set the clear button
        searchBar.clearButtonMode = .whileEditing
    }
    
    //MARK: - View Layout
    
    private func setupLayout() {
        
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
    
    //MARK: - TableView
    private func setupTableView() {
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    //MARK: - View Title Label
    private func setupTitleLabel() {
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

