//
//  MoviePickerView.swift
//  Cinema Booking
//
//  Created by Soorya Narayanan Sanand on 3/5/2025.
//

import SwiftUI

struct MoviePickerView: View {
    @State private var movies: [Movie] = []

    var body: some View {
        NavigationView {
            List(movies) { movie in
                NavigationLink(destination: TimingSelectionView(movie: movie)) {
                    HStack {
                        if let url = movie.posterURL {
                            AsyncImage(url: url) { phase in
                                if let image = phase.image {
                                    image.resizable()
                                } else {
                                    Color.gray
                                }
                            }
                            .frame(width: 50, height: 75)
                            .cornerRadius(4)
                        }

                        VStack(alignment: .leading) {
                            Text(movie.title)
                                .font(.headline)
                            Text(movie.releaseDate)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Select a Movie")
            .onAppear {
                TMDBService.fetchPopularMovies { movies in
                    self.movies = movies
                }
            }
        }
    }
}
