//
//  TMDbService.swift
//  NextFlicks
//
//  Created by Gabe Jimenez on 10/29/24.
//


import Foundation

class TMDbService {
    private let apiKey = "NO_KEY_FOR_U" // TMDb API key
    
    func fetchMovie(title: String, completion: @escaping (MovieData?) -> Void) {
        let query = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(query)"
        
        guard let url = URL(string: urlString) else { return completion(nil) }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(MovieSearchResult.self, from: data)
                if let firstResult = result.results.first {
                    let movie = MovieData(title: title, posterPath: firstResult.posterPath)
                    completion(movie)
                } else {
                    completion(nil)
                }
            } catch {
                completion(nil)
            }
        }.resume()
    }
}

struct MovieSearchResult: Decodable {
    let results: [MovieResult]
}

struct MovieResult: Decodable {
    let posterPath: String?
    
    private enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
    }
}
