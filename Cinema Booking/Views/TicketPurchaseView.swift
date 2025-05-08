//  TicketPurchaseView.swift
//  Cinema Booking
//
//  Updated for light mode on 3/5/2025.

import SwiftUI

struct TicketPurchaseView: View {
    @ObservedObject var viewModel: TicketPurchaseViewModel
    let showtime: TheatreShowtime

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    HStack(alignment: .top, spacing: 16) {
                        if let url = viewModel.movie.posterURL {
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
                            Text(viewModel.movie.title)
                                .font(.title3)
                                .bold()
                                .foregroundColor(.black)

                            Text(viewModel.movie.overview)
                                .foregroundColor(.gray)
                                .lineLimit(3)

                            Text("Release Date \(viewModel.movie.releaseDate)")
                                .foregroundColor(.gray)
                                .padding(.top)
                        }
                    }

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
                            ticketRow(ticket: ticket)
                                .background(Color(white: 0.97))
                                .overlay(
                                    Divider().background(Color.gray.opacity(0.3)),
                                    alignment: .bottom
                                )
                        }
                    }
                    .cornerRadius(12)
                }
                .padding()
            }

            VStack(spacing: 6) {
                HStack {
                    Text("Total \(String(format: "$%.2f", viewModel.totalCost))")
                        .foregroundColor(.black)
                        .bold()

                    Spacer()

                    Button(action: {
                        print("Seats: \(viewModel.seatIDs), Tickets: \(viewModel.ticketCounts)")
                        bookings.append(BookingModel(movie: viewModel.movie, ticket: viewModel, showtime: showtime))
                    }) {
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
        .background(Color.white.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("CineQuick")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
        }
    }

    @ViewBuilder
    func ticketRow(ticket: TicketPurchaseViewModel.TicketOption) -> some View {
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
