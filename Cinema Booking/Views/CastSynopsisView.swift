//
//  CastSynopsisView.swift
//  Cinema Booking
//
//  Created by Soorya Narayanan Sanand on 3/5/2025.
//


//  CastSynopsisView.swift
//  Cinema Booking
//
//  Created by Soorya Narayanan Sanand on 3/5/2025.

import SwiftUI

struct CastSynopsisView: View {
    let movie: Movie
    @State private var cast: [CastMember] = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                movieHeader

                if !movie.overview.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Synopsis")
                            .foregroundColor(.white)
                            .font(.headline)

                        Text(movie.overview)
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }
                }

                if !cast.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Cast")
                            .foregroundColor(.white)
                            .font(.headline)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(cast.prefix(20)) { member in
                                    VStack(spacing: 4) {
                                        if let url = member.profileURL {
                                            AsyncImage(url: url) { image in
                                                image.resizable()
                                            } placeholder: {
                                                Color.gray
                                            }
                                            .frame(width: 60, height: 90)
                                            .cornerRadius(6)
                                        } else {
                                            Color.gray
                                                .frame(width: 60, height: 90)
                                                .cornerRadius(6)
                                        }

                                        Text(member.name)
                                            .font(.caption2)
                                            .foregroundColor(.white)
                                            .lineLimit(1)

                                        Text(member.character)
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                            .lineLimit(1)
                                    }
                                    .frame(width: 80)
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color.black.ignoresSafeArea())
        .onAppear {
            TMDBService.fetchCast(for: movie.id) { fetchedCast in
                self.cast = fetchedCast
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("CineQuick")
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
    }

    var movieHeader: some View {
        HStack(alignment: .top, spacing: 16) {
            if let url = movie.posterURL {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image.resizable()
                    } else {
                        Color.gray
                    }
                }
                .frame(width: 100, height: 150)
                .cornerRadius(8)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .foregroundColor(.white)
                    .font(.title3)
                    .bold()

                Text("Release Date: \(movie.releaseDate)")
                    .foregroundColor(.gray)
            }
        }
    }
}
