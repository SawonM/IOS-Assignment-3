//
//  TimingSelectionView.swift
//  Cinema Booking
//
//  Created by Soorya Narayanan Sanand on 3/5/2025.
//


import SwiftUI

struct TimingSelectionView: View {
    let movie: Movie

    let theatreOptions: [TheatreShowtime] = [
        TheatreShowtime(location: "Broadway Cineplex", time: "4:15 PM"),
        TheatreShowtime(location: "Nova Lux Cinema", time: "6:45 PM"),
        TheatreShowtime(location: "Starline Pictures HQ", time: "9:30 PM")
    ]

    var body: some View {
        List(theatreOptions) { showtime in
            NavigationLink(
                destination: SeatSelectionView(
                    movie: movie,
                    showtime: showtime
                )
            ) {
                VStack(alignment: .leading) {
                    Text(showtime.location)
                        .font(.headline)
                    Text(showtime.time)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 6)
            }
        }
        .navigationTitle("Choose Showtime")
    }
}

struct TheatreShowtime: Identifiable {
    let id = UUID()
    let location: String
    let time: String
}
