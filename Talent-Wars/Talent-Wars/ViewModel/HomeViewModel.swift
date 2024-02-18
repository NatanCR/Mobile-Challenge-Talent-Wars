//
//  HomeViewModel.swift
//  Talent-Wars
//
//  Created by Natan de Camargo Rodrigues on 18/02/24.
//

import Foundation
import UIKit

class HomeViewModel {
    
    // Este closure é chamado quando os filmes são atualizados
        var onMoviesUpdated: (() -> Void)?
        
        // Array de filmes
        var movies: [Movie] = [] {
            didSet {
                onMoviesUpdated?()
            }
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
                                // Decodifica a resposta JSON para a estrutura Welcome
                                let welcomeData = try JSONDecoder().decode(Welcome.self, from: data)
                                // Mapeia os resultados para a estrutura Movie
                                let movies = welcomeData.results.map { result -> Movie in
                                    // Aqui você precisa converter de Result para Movie
                                    // Ajuste de acordo com as propriedades da sua estrutura Movie
                                    return Movie(
                                        title: result.title,
                                        year: String(result.releaseDate.prefix(4)),
                                        userScore: "\(Int(result.voteAverage * 10))%", // Convertido para uma porcentagem
                                        category: self?.genreNames(from: result.genreIDS) ?? "",
                                        imagePath: nil // Você precisará carregar a imagem de maneira assíncrona
                                    )
                                }
                                // Atualiza a propriedade 'movies' na thread principal
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
                
                private func genreNames(from ids: [Int]) -> String {
                    // Aqui você pode mapear os IDs dos gêneros para nomes de gêneros
                    // Isso pode requerer uma chamada de API separada ou um dicionário local
                    // Por exemplo:
                    let genreDictionary = [28: "Action", 12: "Adventure", 16: "Animation", 35: "Comedy", 80: "Crime", 99: "Documentary", 18: "Drama", 10751: "Family", 14: "Fantasy", 36: "History", 27: "Horror", 10402: "Music", 9648: "Mystery", 10749: "Romance", 878: "Science Fiction", 10770: "TV Movie", 53: "Thriller", 10752: "War", 37: "Western"]
                    
                    // Junta os nomes dos gêneros em uma string separada por vírgulas
                    return ids.compactMap { genreDictionary[$0] }.joined(separator: ", ")
                }
}
