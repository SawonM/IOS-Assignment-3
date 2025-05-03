//
//  TMDBService.swift
//  Cinema Booking
//
//  Created by Soorya Narayanan Sanand on 3/5/2025.
//

import Foundation

class TMDBService {
    static let apiKey = "0dafa62f605f54d3691635e33f82d5a0"

    static func fetchPopularMovies(completion: @escaping ([Movie]) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&language=en-US&page=1") else {
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion([])
                return
            }

            let result = try? JSONDecoder().decode(MovieListResponse.self, from: data)
            DispatchQueue.main.async {
                completion(result?.results ?? [])
            }
        }.resume()
    }
}

struct MovieListResponse: Decodable {
    let results: [Movie]
}
