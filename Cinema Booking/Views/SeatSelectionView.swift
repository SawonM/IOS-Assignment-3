//
//  SeatSelectionView.swift
//  Cinema Booking
//
//  Created by Soorya Narayanan Sanand on 3/5/2025.
//

import SwiftUI

struct SeatSelectionView: View {
    @StateObject private var viewModel = SeatSelectionViewModel()
    let movie: Movie
    let showtime: TheatreShowtime

    var body: some View {
        ScrollView {
            VStack() {
                header
                showtimeInfo
                
                Text("Choose your seats")
                    .foregroundColor(.black)
                    .font(.headline)
                    .padding(10)

                seatGrid
                legend

                if !viewModel.selectedSeats.isEmpty {
                    NavigationLink(
                        destination: TicketPurchaseView(
                            viewModel: TicketPurchaseViewModel(
                                movie: movie,
                                seatIDs: Array(viewModel.selectedSeats)
                            ),
                            showtime: showtime
                        )
                    ) {
                        Text("PROCEED")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .padding(10)
                    }
                }

                Spacer()
            }
            .padding()
        }
        .background(Color(.white).ignoresSafeArea())
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("CineQuick")
                    .font(.headline)
                    .foregroundColor(.black)
            }
        }
        .padding()
    }

    var header: some View {
        HStack() {
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
                Text(movie.overview)
                    .foregroundColor(.gray)
                    .lineLimit(3)
                Text("Release Date: \(movie.releaseDate)")
                    .foregroundColor(.gray)
                    .padding(.top)
            }
        }
    }

    var showtimeInfo: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(Color.blue)
                .frame(width: 6)

            VStack(alignment: .leading, spacing: 2) {
                Text(showtime.time)
                    .foregroundColor(.black)
                Text("Location: \(showtime.location)")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.white))
        }
        .cornerRadius(12)
        .padding(.vertical, 20)
    }

    var seatGrid: some View {
        VStack(spacing: 10) {
            ForEach(viewModel.rows, id: \.self) { row in
                HStack(spacing: 10) {
                    Text(row)
                        .foregroundColor(.black)
                        .frame(width: 20)
                    ForEach(viewModel.columns, id: \.self) { col in
                        let seatId = "\(row)\(col)"
                        Rectangle()
                            .fill(viewModel.seatColor(seatId))
                            .frame(width: 26, height: 26)
                            .cornerRadius(4)
                            .onTapGesture {
                                viewModel.toggleSeat(seatId)
                            }
                    }
                }
            }
        }
    }

    var legend: some View {
        HStack(spacing: 16) {
            legendItem(color: .black, label: "Available")
            legendItem(color: .gray, label: "Unavailable")
            legendItem(color: .blue, label: "Selected")
        }
        .padding(.vertical, 10)
    }

    func legendItem(color: Color, label: String) -> some View {
        HStack(spacing: 6) {
            Rectangle()
                .fill(color)
                .frame(width: 20, height: 20)
                .cornerRadius(4)
            Text(label)
                .foregroundColor(.black)
                .font(.caption)
        }
    }
}
