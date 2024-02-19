//
//  MovieCollectionViewCell.swift
//  Talent-Wars
//
//  Created by Natan de Camargo Rodrigues on 19/02/24.
//

import Foundation
import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    let posterImageView = UIImageView()
    let favoriteButton = UIButton()
    let ratingLabel = UILabel()
    let ratingValueLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Configuração do posterImageView
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 8
        contentView.addSubview(posterImageView)
        
        // Configuração do favoriteButton
        let configuration = UIImage.SymbolConfiguration(pointSize: 28, weight: .medium, scale: .default)
        let starImage = UIImage(systemName: "star.fill", withConfiguration: configuration)?.withTintColor(UIColor(named: "favButton") ?? .orange, renderingMode: .alwaysOriginal)
        favoriteButton.setImage(starImage, for: .normal)
        favoriteButton.backgroundColor = .white
        favoriteButton.tintColor = .yellow
        favoriteButton.layer.cornerRadius = 25 // Ajuste para a metade do tamanho do botão para que seja um círculo
        favoriteButton.layer.shadowColor = UIColor.black.cgColor // A cor da sombra
        favoriteButton.layer.shadowOffset = CGSize(width: 0, height: 4) // A direção e distância da sombra
        favoriteButton.layer.shadowOpacity = 0.5 // A transparência da sombra
        favoriteButton.layer.shadowRadius = 5 // O quão borrada a sombra será
        
        // Aplica cantos arredondados
        favoriteButton.clipsToBounds = false
        contentView.addSubview(favoriteButton)
        
        // Configuração do ratingLabel
        ratingLabel.text = "My Rating"
        ratingLabel.textAlignment = .center
        contentView.addSubview(ratingLabel)
        
        // Configuração do ratingValueLabel
        ratingValueLabel.textAlignment = .center
        contentView.addSubview(ratingValueLabel)
    }
    
    private func setupLayout() {
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10), // Adicione espaço no topo
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10), // Adicione espaço à esquerda
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10), // Adicione espaço à direita
//            posterImageView.bottomAnchor.constraint(equalTo: favoriteButton.topAnchor, constant: -10), // Espaço antes do botão favorito
            
            // Constraints para o favoriteButton abaixo do posterImageView
            favoriteButton.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: -30),
            favoriteButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 50),
            favoriteButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Constraints para o ratingLabel abaixo do favoriteButton
            ratingLabel.topAnchor.constraint(equalTo: favoriteButton.bottomAnchor, constant: 4),
            ratingLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // Constraints para o ratingValueLabel abaixo do ratingLabel
            ratingValueLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 2),
            ratingValueLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // Se necessário, adicione uma constraint para a parte inferior do ratingValueLabel
            // para garantir que ele não saia da célula
            ratingValueLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
            
        ])
    }
    
    func configure(with movie: Movie) {
        // Configure a célula com os dados do filme
        if let posterPath = movie.posterPath {
            loadImage(fromPath: posterPath, into: posterImageView) // Certifique-se de ter um somePosterImageView
        }
        //        ratingValueLabel.text = "\(movie.voteAverage)"
        ratingValueLabel.text = "0"
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
