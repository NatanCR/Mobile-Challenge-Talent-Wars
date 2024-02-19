//
//  FavoritesMoviesViewController.swift
//  Talent-Wars
//
//  Created by Natan de Camargo Rodrigues on 18/02/24.
//

import UIKit

class FavoritesMoviesViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var viewModel = HomeViewModel() // Adicionado para utilizar o modelo de dados
    weak var coordinator: FlowCoordinatorController?
    
    var favoriteMovies: [Movie] = [] // Aqui você deve ter os filmes favoritos para exibir
    var favoriteMovieIds: [Int] = []
    
    private let titleLabel = UILabel()
    let backButton = UIButton(type: .system)
    private let headerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        navigationController?.navigationBar.isHidden = true
        setupHeaderView()
        setupBackButton()
        setupTitleLabel()
        setupCollectionView()
        loadFavoriteMovies()
        setupSearchButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupHeaderView() {
            // Configure o cabeçalho com a cor de fundo verde
            headerView.backgroundColor = UIColor(named: "homeBG") // Substitua green pela cor específica que você estava usando

            view.addSubview(headerView)
            headerView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                headerView.topAnchor.constraint(equalTo: view.topAnchor),
                headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                headerView.heightAnchor.constraint(equalToConstant: 98) // Altura padrão de uma navigation bar, ajuste conforme necessário
            ])
        }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let itemWidth = view.frame.width * 0.35 
        let itemHeight = view.frame.height * 0.35
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20) // Espaçamento entre os itens e borda da collectionView
        
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCollectionViewCell")
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10), // Ajuste a constante conforme necessário
//            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // Defina uma altura fixa para a collectionView ou use uma proporção da view do controlador
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4) // Exemplo com proporção
        ])
    }
    
    private func setupBackButton() {
        backButton.setTitle("Back", for: .normal) // Ou use um ícone de seta
        let configuration = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium, scale: .default)
        if let backImage = UIImage(systemName: "chevron.left", withConfiguration: configuration) {
            backButton.setImage(backImage, for: .normal)
            backButton.tintColor = UIColor.black
        }
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        backButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        backButton.setTitleColor(UIColor.black, for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
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
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
        // Ou, se você estiver apresentando de forma modal:
        dismiss(animated: true, completion: nil)
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "My Favorites" // O texto do seu título
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Jomhuria-Regular", size: 96) // Ajuste o tamanho da fonte conforme necessário
        titleLabel.textColor = UIColor(named: "homeTitle") // Ajuste a cor conforme necessário

        headerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50), // Ajuste a constante conforme necessário
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 60) // Ajuste a altura conforme necessário
        ])
    }
    
    private func loadFavoriteMovies() {
        let favoriteMoviesData = FavoritesManager.shared.getFavoriteMovies()
        favoriteMovies = favoriteMoviesData.map { favorite in
            // Criando um objeto Movie a partir dos dados de FavoriteMovie
            // Você deve preencher os outros campos de acordo com a sua estrutura Movie
            return Movie(id: favorite.id,
                         title: "", // Valor padrão ou recupere de outro lugar se necessário
                         releaseDate: "",
                         voteAverage: "",
                         overview: "",
                         backdropPath: nil,
                         posterPath: favorite.posterPath,
                         genreIDs: [])
        }
        collectionView.reloadData()
        
    }
    
    private func setupSearchButton() {
        // Configure o botão
        let searchMoreButton = UIButton(type: .system)
        searchMoreButton.setTitle("Search for More", for: .normal)
        searchMoreButton.backgroundColor = UIColor(named: "searchButton")
        searchMoreButton.setTitleColor(UIColor.black, for: .normal)
        searchMoreButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        searchMoreButton.layer.shadowColor = UIColor.black.cgColor // A cor da sombra
        searchMoreButton.layer.shadowOffset = CGSize(width: 0, height: 4) // A direção e distância da sombra
        searchMoreButton.layer.shadowOpacity = 0.5 // A transparência da sombra
        searchMoreButton.layer.shadowRadius = 5 // O quão borrada a sombra será
        
        // Aplica cantos arredondados
        searchMoreButton.layer.cornerRadius = 30 // Ajuste o valor conforme necessário
        searchMoreButton.clipsToBounds = false
        
        // Adicione o botão à view e configure as constraints
        view.addSubview(searchMoreButton)
        searchMoreButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchMoreButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchMoreButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),// Ajuste conforme necessário
            searchMoreButton.widthAnchor.constraint(equalToConstant: 250), // Ajuste conforme necessário
            searchMoreButton.heightAnchor.constraint(equalToConstant: 60) // Ajuste conforme necessário
        ])
        
        // Adicione uma ação para o botão
        searchMoreButton.addTarget(self, action: #selector(searchMoreButtonTapped), for: .touchUpInside)
    }
    
    @objc private func searchMoreButtonTapped() {
        // Implemente a navegação para a tela de busca
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
        // Implemente a ação de seleção de item, como mostrar detalhes do filme
    }
}
