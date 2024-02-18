//
//  MovieTableViewCell.swift
//  Talent-Wars
//
//  Created by Natan de Camargo Rodrigues on 18/02/24.
//

import Foundation
import UIKit

class MovieTableViewCell: UITableViewCell {
    
    private let movieImageView = UIImageView()
    private let titleLabel = UILabel()
    private let yearLabel = UILabel()
    private let userScoreLabel = UILabel()
    private let categoryLabel = UILabel()
    private let stackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        movieImageView.contentMode = .scaleAspectFill
        movieImageView.clipsToBounds = true
        movieImageView.layer.cornerRadius = 8
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .black
        
        yearLabel.font = UIFont.systemFont(ofSize: 14)
        yearLabel.textColor = .darkGray
        
        userScoreLabel.font = UIFont.systemFont(ofSize: 14)
        userScoreLabel.textColor = .black
        
        categoryLabel.font = UIFont.systemFont(ofSize: 12)
        categoryLabel.textColor = .gray
        categoryLabel.numberOfLines = 0
        
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = 4
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(yearLabel)
        stackView.addArrangedSubview(userScoreLabel)
        stackView.addArrangedSubview(categoryLabel)
        
        contentView.addSubview(movieImageView)
        contentView.addSubview(stackView)
        
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func layoutViews() {
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            movieImageView.widthAnchor.constraint(equalToConstant: 70),
            movieImageView.heightAnchor.constraint(equalToConstant: 105),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        yearLabel.text = movie.year
        userScoreLabel.text = movie.userScore
        categoryLabel.text = movie.category
        
        movieImageView.image = nil // Limpa a imagem antiga
        loadImage(fromPath: movie.imagePath)
    }
    
    func loadImage(fromPath path: String?) {
        guard let imagePath = path, let url = URL(string: "https://image.tmdb.org/t/p/w500\(imagePath)") else {
            print("invalid URL: \(path ?? "nil")")
            movieImageView.image = nil
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Error load image: \(error.localizedDescription)")
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.movieImageView.image = image
                }
            }
        }.resume()
    }
}
