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

            do {
                let result = try JSONDecoder().decode(MovieListResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(result.results)
                }
            } catch {
                print("❌ Popular movies decoding failed:", error.localizedDescription)
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }.resume()
    }

    static func fetchUpcomingMovies(completion: @escaping ([Movie]) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=\(apiKey)&language=en-US&page=1") else {
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion([])
                return
            }

            do {
                let result = try JSONDecoder().decode(MovieListResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(result.results)
                }
            } catch {
                print("❌ Upcoming movies decoding failed:", error.localizedDescription)
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }.resume()
    }

    static func fetchCast(for movieID: Int, completion: @escaping ([CastMember]) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieID)/credits?api_key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion([])
                return
            }
            do {
                let result = try JSONDecoder().decode(CreditsResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(result.cast)
                }
            } catch {
                print("Decoding error:", error)
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }.resume()
    }
}

struct MovieListResponse: Decodable {
    let results: [Movie]
}

struct CreditsResponse: Decodable {
    let cast: [CastMember]
}
