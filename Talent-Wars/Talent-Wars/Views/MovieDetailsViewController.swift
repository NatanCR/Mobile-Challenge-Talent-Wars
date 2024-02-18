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
    
    var movie: Movie? {
        didSet {
            configureViewsWithMovie()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        setupScrollView()
        setupViews()
        setupLayout()
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
        movieImageView.contentMode = .scaleAspectFill
        movieImageView.clipsToBounds = true
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        ratingLabel.font = UIFont.systemFont(ofSize: 18)
        genresLabel.font = UIFont.systemFont(ofSize: 16)
        overviewTextView.isEditable = false
        overviewTextView.font = UIFont.systemFont(ofSize: 16)
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 8
        posterImageView.layer.borderWidth = 1
        posterImageView.layer.borderColor = UIColor.lightGray.cgColor
        
        // Add subviews to contentView
        [movieImageView, posterImageView, titleLabel, ratingLabel, genresLabel, overviewTextView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupLayout() {
        // Set up constraints
        // This will be a simplified version of your layout
        
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            movieImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            movieImageView.heightAnchor.constraint(equalToConstant: 200), // example height
            
            titleLabel.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            ratingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            ratingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            genresLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 8),
            genresLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            overviewTextView.topAnchor.constraint(equalTo: genresLabel.bottomAnchor, constant: 8),
            overviewTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            overviewTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            overviewTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            posterImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.widthAnchor.constraint(equalToConstant: 100), // Defina a largura conforme necessário
            posterImageView.heightAnchor.constraint(equalToConstant: 150)
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
        
        titleLabel.text = movie.title
        ratingLabel.text = movie.voteAverage
        overviewTextView.text = movie.overview
        
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
