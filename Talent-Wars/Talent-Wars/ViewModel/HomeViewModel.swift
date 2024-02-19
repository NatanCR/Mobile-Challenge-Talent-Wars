//
//  HomeViewModel.swift
//  Talent-Wars
//
//  Created by Natan de Camargo Rodrigues on 18/02/24.
//

import Foundation
import UIKit

class HomeViewModel {
    
    // This closure is called when the movies are updated
    var onMoviesUpdated: (() -> Void)?
    
    // Array of movies
    var movies: [Movie] = [] {
        didSet {
            filteredMovies = movies
            onMoviesUpdated?()
        }
    }
    
    var filteredMovies: [Movie] = []
    
    func filterMovies(with searchText: String) {
        if searchText.isEmpty {
            filteredMovies = movies
        } else {
            filteredMovies = movies.filter { movie in
                movie.title.lowercased().contains(searchText.lowercased())
            }
        }
        onMoviesUpdated?()
    }
    
    func fetchMoviesFromAPI() {
        let headers = [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmMDYyMmIzMjkzNGRiNmNmMWJlNTM5ZGNmOTVlZDExYSIsInN1YiI6IjY0M2RhMzE1ZWZkM2MyMDRiMWY3ZTE1ZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.MkLud7qz2bbw-GtmPbJDpntgUJG8b-UHnV5oR64AGRg"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { [weak self] (data, response, error) -> Void in
            if let error = error {
                print(error)
            } else if let data = data,
                      let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 {
                do {
                    // // Decodes the JSON response into the Welcome structure
                    let welcomeData = try JSONDecoder().decode(Welcome.self, from: data)
                    // Maps the results to the Movie structure
                    let movies = welcomeData.results.map { result -> Movie in
                        // Here you need to convert from Result to Movie
                        return Movie(id: result.id,
                                     title: result.title,
                                     releaseDate: String(result.releaseDate.prefix(4)),
                                     voteAverage: "\(Int(result.voteAverage * 10))%",
                                     overview: result.overview,
                                     backdropPath: result.backdropPath,
                                     posterPath: result.posterPath,
                                     genreIDs: result.genreIDS)
                    }
                    // Updates the 'movies' property on the main thread
                    DispatchQueue.main.async {
                        self?.movies = movies
                        self?.onMoviesUpdated?()
                    }
                } catch {
                    print("Erro ao decodificar os dados: \(error)")
                }
            }
        })
        dataTask.resume()
    }
}

extension UIImageView {
    func loadImage(fromPath path: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(path)") else {
            self.image = nil // Or a default image
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            } else {
                DispatchQueue.main.async {
                    self.image = nil // Or error/default image
                }
            }
        }.resume()
    }
}

extension UIButton {
    static func createCustomButton(title: String, imageName: String, color: UIColor, shadow: Bool = true) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        let configuration = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium, scale: .default)
        if let image = UIImage(systemName: imageName, withConfiguration: configuration) {
            button.setImage(image, for: .normal)
        }
        button.backgroundColor = color
        button.tintColor = .white
        if shadow {
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 4)
            button.layer.shadowOpacity = 0.5
            button.layer.shadowRadius = 5
        }
        button.layer.cornerRadius = 12
        
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 10)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)
        
        return button
    }
}
