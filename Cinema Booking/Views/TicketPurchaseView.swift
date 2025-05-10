//  TicketPurchaseView.swift
//  Cinema Booking
//
//  Updated for light mode on 3/5/2025.

import SwiftUI

struct TicketPurchaseView: View {
    @ObservedObject var viewModel: TicketPurchaseViewModel
    let showtime: TheatreShowtime
    @State private var showingSuccessView = false
    @Environment(\.presentationMode) var presentationMode
    @State private var navigateToHome = false
    @EnvironmentObject var navigationHelper: NavigationHelper

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    MovieInfoSection(movie: viewModel.movie)
                    ShowtimeInfoSection(showtime: showtime)
                    TicketSelectionSection(viewModel: viewModel)
                }
                .padding()
            }

            TotalSection(
                viewModel: viewModel,
                onProceed: {
                    let booking = BookingModel(
                        movie: viewModel.movie,
                        ticket: viewModel,
                        showtime: showtime
                    )
                    bookings.append(booking)
                    showingSuccessView = true
                }
            )
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
        .fullScreenCover(isPresented: $showingSuccessView) {
            CheckoutSuccessView()
                .environmentObject(navigationHelper)
        }
        .background(
            NavigationLink(destination: HomeView(), isActive: $navigateToHome) {
                HomeView()
            }
            .hidden()
        )
        .onChange(of: navigateToHome) { oldValue, newValue in
            if newValue {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct MovieInfoSection: View {
    let movie: Movie

    var body: some View {
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
                    .font(.title3)
                    .bold()
                    .foregroundColor(.black)

                Text(movie.overview)
                    .foregroundColor(.gray)
                    .lineLimit(3)

                Text("Release Date \(movie.releaseDate)")
                    .foregroundColor(.gray)
                    .padding(.top)
            }
        }
    }
}

struct ShowtimeInfoSection: View {
    let showtime: TheatreShowtime

    var body: some View {
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
            .background(Color(white: 0.95))
        }
        .cornerRadius(12)
    }
}

struct TicketSelectionSection: View {
    @ObservedObject var viewModel: TicketPurchaseViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Select Tickets")
                    .foregroundColor(.black)
                    .font(.headline)
                Spacer()
                Text("\(viewModel.totalTickets) / \(viewModel.seatIDs.count) tickets selected")
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }

            VStack(spacing: 0) {
                ForEach(viewModel.allTickets) { ticket in
                    TicketRowView(ticket: ticket, viewModel: viewModel)
                        .background(Color(white: 0.97))
                        .overlay(
                            Divider().background(Color.gray.opacity(0.3)),
                            alignment: .bottom
                        )
                }
            }
            .cornerRadius(12)
        }
    }
}

struct TicketRowView: View {
    let ticket: TicketPurchaseViewModel.TicketOption
    @ObservedObject var viewModel: TicketPurchaseViewModel

    var body: some View {
        HStack {
            Text(ticket.label)
                .foregroundColor(.black)
                .font(.subheadline)
                .lineLimit(2)
                .multilineTextAlignment(.leading)

            Spacer()

            Text("$\(String(format: "%.2f", ticket.price))")
                .foregroundColor(.black)

            let count = viewModel.ticketCounts[ticket.id] ?? 0
            if count > 0 {
                HStack(spacing: 8) {
                    Button {
                        viewModel.decrement(ticket: ticket)
                    } label: {
                        Image(systemName: "minus.circle")
                            .foregroundColor(.blue)
                    }

                    Text("\(count)")
                        .foregroundColor(.black)
                        .frame(minWidth: 20)

                    Button {
                        viewModel.increment(ticket: ticket)
                    } label: {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.blue)
                    }
                }
                .padding(.leading, 8)
            } else {
                Button {
                    viewModel.increment(ticket: ticket)
                } label: {
                    Text("ADD")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(6)
                }
                .padding(.leading, 8)
            }
        }
        .padding()
    }
}

struct TotalSection: View {
    @ObservedObject var viewModel: TicketPurchaseViewModel
    var onProceed: () -> Void

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text("Total \(String(format: "$%.2f", viewModel.totalCost))")
                    .foregroundColor(.black)
                    .bold()

                Spacer()

                Button(action: onProceed) {
                    Text("PROCEED")
                        .padding(.vertical, 10)
                        .padding(.horizontal, 24)
                        .background(viewModel.totalTickets == viewModel.seatIDs.count ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(viewModel.totalTickets != viewModel.seatIDs.count)
            }

            Text("inc. Booking Fees $\(String(format: "%.2f", viewModel.bookingFee))")
                .foregroundColor(.gray)
                .font(.caption)
        }
        .padding()
        .background(Color.white)
    }
}
