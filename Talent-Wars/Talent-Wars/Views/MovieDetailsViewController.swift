//
//  MovieDetailsViewController.swift
//  Talent-Wars
//
//  Created by Natan de Camargo Rodrigues on 18/02/24.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    // Subviews
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let posterImageView = UIImageView()
    let movieImageView = UIImageView()
    let titleLabel = UILabel()
    let ratingLabel = UILabel()
    let genresLabel = UILabel()
    let overviewTextView = UITextView()
    let releaseDate = UILabel()
    let userScore = UILabel()
    let overviewTitle = UILabel()
    let goFavButton = UIButton(type: .system)
    let backButton = UIButton(type: .system)
    let viewMovieTitle = UILabel()
    
    var movie: Movie? {
        didSet {
            configureViewsWithMovie()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.isHidden = true
        
        setupScrollView()
        setupViews()
        setupLayout()
        setupGoFavButton()
        setupBackButton()
    }
    
    private func setupBackButton() {
        backButton.setTitle("Back to Search", for: .normal) // Ou use um ícone de seta
        let configuration = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium, scale: .default)
        if let backImage = UIImage(systemName: "chevron.left", withConfiguration: configuration) {
            backButton.setImage(backImage, for: .normal)
            backButton.tintColor = UIColor.white
        }
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        backButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        backButton.setTitleColor(UIColor.white, for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
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
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
        // Ou, se você estiver apresentando de forma modal:
        dismiss(animated: true, completion: nil)
    }
    
    private func setupGoFavButton() {
        // Configure o botão
        goFavButton.setTitle("View Favs", for: .normal)
        goFavButton.backgroundColor = UIColor(named: "favButton")
        goFavButton.setTitleColor(UIColor(named: "labelFavButton"), for: .normal)
        goFavButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        goFavButton.layer.shadowColor = UIColor.black.cgColor // A cor da sombra
        goFavButton.layer.shadowOffset = CGSize(width: 0, height: 4) // A direção e distância da sombra
        goFavButton.layer.shadowOpacity = 0.5 // A transparência da sombra
        goFavButton.layer.shadowRadius = 5 // O quão borrada a sombra será
        
        // Aplica cantos arredondados
        goFavButton.layer.cornerRadius = 30 // Ajuste o valor conforme necessário
        goFavButton.clipsToBounds = false
        
        // Adicione o botão à view e configure as constraints
        contentView.addSubview(goFavButton)
        goFavButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            goFavButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 70),
            goFavButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -270), // Ajuste conforme necessário
            goFavButton.widthAnchor.constraint(equalToConstant: 150), // Ajuste conforme necessário
            goFavButton.heightAnchor.constraint(equalToConstant: 60) // Ajuste conforme necessário
        ])
        
        // Adicione uma ação para o botão
        goFavButton.addTarget(self, action: #selector(goFavTapped), for: .touchUpInside)
    }
    
    @objc func goFavTapped() {
        navigationController?.popViewController(animated: true)
        // Implemente o que deve acontecer quando o botão for tocado
        
    }
    
    private func setupScrollView() {
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
    
    private func setupViews() {
        // Configure and add subviews
        viewMovieTitle.font = UIFont(name: "Jomhuria-Regular", size: 80)
        viewMovieTitle.textColor = UIColor.white
        movieImageView.contentMode = .scaleAspectFill
        movieImageView.clipsToBounds = true
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        releaseDate.font = UIFont.systemFont(ofSize: 13)
        releaseDate.textColor = UIColor.gray
        genresLabel.font = UIFont.systemFont(ofSize: 13)
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
    
    private func setupLayout() {
        // Set up constraints
        // This will be a simplified version of your layout
        
        NSLayoutConstraint.activate([
            viewMovieTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
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
            posterImageView.widthAnchor.constraint(equalToConstant: 130), // Defina a largura conforme necessário
            posterImageView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    private func genreNames(from ids: [Int]) -> String {
        // Aqui você pode mapear os IDs dos gêneros para nomes de gêneros
        // Isso pode requerer uma chamada de API separada ou um dicionário local
        // Por exemplo:
        let genreDictionary = [28: "Action", 12: "Adventure", 16: "Animation", 35: "Comedy", 80: "Crime", 99: "Documentary", 18: "Drama", 10751: "Family", 14: "Fantasy", 36: "History", 27: "Horror", 10402: "Music", 9648: "Mystery", 10749: "Romance", 878: "Science Fiction", 10770: "TV Movie", 53: "Thriller", 10752: "War", 37: "Western"]
        
        // Junta os nomes dos gêneros em uma string separada por vírgulas
        return ids.compactMap { genreDictionary[$0] }.joined(separator: ", ")
    }
    
    private func configureViewsWithMovie() {
        guard let movie = movie else { return }
        
        viewMovieTitle.text = movie.title
        titleLabel.text = movie.title
        releaseDate.text = movie.releaseDate
        ratingLabel.text = movie.voteAverage
        overviewTextView.text = movie.overview
        userScore.text = "user score"
        overviewTitle.text = "Overview"
        
        // Carregar e definir a imagem de fundo
        if let backdropPath = movie.backdropPath {
            loadImage(fromPath: backdropPath, into: movieImageView) // Supondo que movieImageView é o UIImageView para a imagem de fundo
        }
        
        // Carregar e definir a imagem do poster
        if let posterPath = movie.posterPath {
            loadImage(fromPath: posterPath, into: posterImageView) // Certifique-se de ter um somePosterImageView
        }
        
        // Definir a lista de gêneros
        genresLabel.text = genreNames(from: movie.genreIDs)
    }
    
    private func loadImage(fromPath path: String, into imageView: UIImageView) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(path)") else {
            imageView.image = nil // Ou defina uma imagem padrão
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            } else {
                DispatchQueue.main.async {
                    imageView.image = nil // Ou sua imagem de erro/padrão
                }
            }
        }.resume()
    }
}

