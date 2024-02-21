//
//  HomeViewModel.swift
//  Talent-Wars
//
//  Created by Natan de Camargo Rodrigues on 18/02/24.
//

import Foundation
import UIKit

class HomeViewModel {
    private let apiKey = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmMDYyMmIzMjkzNGRiNmNmMWJlNTM5ZGNmOTVlZDExYSIsInN1YiI6IjY0M2RhMzE1ZWZkM2MyMDRiMWY3ZTE1ZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.MkLud7qz2bbw-GtmPbJDpntgUJG8b-UHnV5oR64AGRg"
    
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
            "Authorization": "Bearer \(apiKey)"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { [weak self] (data, response, error) -> Void in
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
