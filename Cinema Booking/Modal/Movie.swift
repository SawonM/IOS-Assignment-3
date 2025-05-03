//
//  Movie.swift
//  Cinema Booking
//
//  Created by Soorya Narayanan Sanand on 3/5/2025.
//

import Foundation

struct Movie: Identifiable, Decodable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String

    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }

    enum CodingKeys: String, CodingKey {
        case id, title, overview, posterPath = "poster_path", releaseDate = "release_date"
    }
}

