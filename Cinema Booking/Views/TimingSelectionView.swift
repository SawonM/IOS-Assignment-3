//  TimingSelectionView.swift
//  Cinema Booking
//
//  Updated for light mode on 3/5/2025.

import SwiftUI

struct TimingSelectionView: View {
    let movie: Movie

    @State private var selectedDateIndex: Int = 0
    @State private var showDetails: Bool = false
    @State private var cast: [CastMember] = []

    let availableDates: [String] = ["TODAY", "TOMORROW", "SUN 4 MAY", "MON 5 MAY"]
    let showtimesPerDay: [[TheatreShowtime]] = [
        [
            TheatreShowtime(location: "Broadway Cineplex", time: "4:15 PM"),
            TheatreShowtime(location: "Starline Pictures HQ", time: "1:45 PM"),
            TheatreShowtime(location: "Nova Lux Cinema", time: "5:00 PM")
        ],
        [
            TheatreShowtime(location: "Broadway Cineplex", time: "6:15 PM"),
            TheatreShowtime(location: "Starline Pictures HQ", time: "7:30 PM"),
            TheatreShowtime(location: "Nova Lux Cinema", time: "8:00 PM")
        ],
        [
            TheatreShowtime(location: "Starline Pictures HQ", time: "1:45 PM"),
            TheatreShowtime(location: "Broadway Cineplex", time: "6:15 PM"),
            TheatreShowtime(location: "Nova Lux Cinema", time: "5:00 PM")
        ],
        [
            TheatreShowtime(location: "Starline Pictures HQ", time: "1:45 PM"),
            TheatreShowtime(location: "Broadway Cineplex", time: "6:15 PM"),
            TheatreShowtime(location: "Nova Lux Cinema", time: "5:00 PM")
        ]
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                movieHeader

                Button(action: {
                    withAnimation {
                        showDetails.toggle()
                    }
                }) {
                    HStack {
                        Text("Cast & Synopsis")
                            .foregroundColor(.black)
                            .font(.headline)
                        Spacer()
                        Image(systemName: showDetails ? "chevron.up" : "chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                }

                if showDetails {
                    VStack(alignment: .leading, spacing: 12) {
                        if !movie.overview.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Synopsis")
                                    .foregroundColor(.black)
                                    .font(.subheadline)
                                Text(movie.overview)
                                    .foregroundColor(.gray)
                                    .font(.caption)
                            }
                        }

                        if !cast.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Cast")
                                    .foregroundColor(.black)
                                    .font(.subheadline)

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(cast.prefix(15)) { member in
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
                                                    .foregroundColor(.black)
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
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }

                Text("Times and Tickets")
                    .foregroundColor(.black)
                    .font(.title2)
                    .bold()

                datePickerBar

                ForEach(showtimesPerDay[selectedDateIndex]) { showtime in
                    NavigationLink(destination: SeatSelectionView(movie: movie, showtime: showtime)) {
                        showtimeCard(showtime: showtime)
                    }
                }

                Spacer()
            }
            .padding()
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("CineQuick")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
        }
        .onAppear {
            TMDBService.fetchCast(for: movie.id) { fetchedCast in
                self.cast = fetchedCast
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
                    .foregroundColor(.black)
                    .font(.title3)
                    .bold()

                Text("Mild Themes, Violence")
                    .foregroundColor(.gray)

                Text("Release Date \(movie.releaseDate)")
                    .foregroundColor(.gray)
            }
        }
    }

    var datePickerBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(0..<availableDates.count, id: \ .self) { index in
                    Button(action: {
                        selectedDateIndex = index
                    }) {
                        Text(availableDates[index])
                            .foregroundColor(index == selectedDateIndex ? .white : .gray)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(index == selectedDateIndex ? Color.blue : Color(white: 0.85))
                            .cornerRadius(8)
                    }
                }
            }
        }
    }

    func showtimeCard(showtime: TheatreShowtime) -> some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(Color.blue)
                .frame(width: 6)

            VStack(alignment: .leading, spacing: 2) {
                Text(showtime.time)
                    .foregroundColor(.black)
                    .font(.headline)

                Text("Location: \(showtime.location)")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(white: 0.95))
        }
        .cornerRadius(12)
    }
}

struct TheatreShowtime: Identifiable {
    let id = UUID()
    let location: String
    let time: String
}
