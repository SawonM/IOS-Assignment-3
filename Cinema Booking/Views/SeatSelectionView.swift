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
                VStack(alignment: .leading, spacing: 20) {
                    header
                    showtimeInfo
                    Text("Choose your seats")
                        .foregroundColor(.white)
                        .font(.headline)

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
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }

                    Spacer()
                }
                .padding()
            }
            .background(Color.black.ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("CineQuick")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
        }

        var header: some View {
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
                    Text(movie.overview)
                        .foregroundColor(.gray)
                        .lineLimit(3)
                    Text("Release Date \(movie.releaseDate)")
                        .foregroundColor(.gray)
                }
            }
        }

        var showtimeInfo: some View {
            HStack(spacing: 0) {
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 6)

                VStack(alignment: .leading, spacing: 2) {
                    Text(showtime.time)
                        .foregroundColor(.white)
                    Text("Location: \(showtime.location)")
                        .foregroundColor(.gray)
                        .font(.caption)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(red: 0.15, green: 0.15, blue: 0.15))
            }
            .cornerRadius(12)
        }

        var seatGrid: some View {
            VStack(spacing: 10) {
                ForEach(viewModel.rows, id: \.self) { row in
                    HStack(spacing: 10) {
                        Text(row)
                            .foregroundColor(.white)
                            .frame(width: 20)
                        ForEach(viewModel.columns, id: \.self) { col in
                            let seatId = "\(row)\(col)"
                            Rectangle()
                                .fill(viewModel.seatColor(seatId))
                                .frame(width: 28, height: 28)
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
                legendItem(color: .white, label: "Available")
                legendItem(color: .gray, label: "Unavailable")
                legendItem(color: .red, label: "Selected")
            }
            .padding(.top)
        }

        func legendItem(color: Color, label: String) -> some View {
            HStack(spacing: 6) {
                Rectangle()
                    .fill(color)
                    .frame(width: 20, height: 20)
                    .cornerRadius(4)
                Text(label)
                    .foregroundColor(.white)
                    .font(.caption)
            }
        }
    }
