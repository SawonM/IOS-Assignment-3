//
//  TicketPurchaseView.swift
//  Cinema Booking
//
//  Created by Soorya Narayanan Sanand on 3/5/2025.
//

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
                                .foregroundColor(.white)

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

                    HStack {
                        Text("Select Tickets")
                            .foregroundColor(.white)
                            .font(.headline)
                        Spacer()
                        Text("\(viewModel.totalTickets) / \(viewModel.seatIDs.count) tickets selected")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }

                    VStack(spacing: 0) {
                        ForEach(viewModel.allTickets) { ticket in
                            ticketRow(ticket: ticket)
                                .background(Color(red: 0.1, green: 0.1, blue: 0.1))
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
                        .foregroundColor(.white)
                        .bold()

                    Spacer()

                    Button(action: {
                        print("Seats: \(viewModel.seatIDs), Tickets: \(viewModel.ticketCounts)")
                    }) {
                        Text("PROCEED")
                            .padding(.vertical, 10)
                            .padding(.horizontal, 24)
                            .background(viewModel.totalTickets == viewModel.seatIDs.count ? Color.red : Color.gray)
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
            .background(Color.black)
        }
        .background(Color.black.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("CineQuick")
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
    }

    @ViewBuilder
    func ticketRow(ticket: TicketPurchaseViewModel.TicketOption) -> some View {
        HStack {
            Text(ticket.label)
                .foregroundColor(.white)
                .font(.subheadline)
                .lineLimit(2)
                .multilineTextAlignment(.leading)

            Spacer()

            Text("$\(String(format: "%.2f", ticket.price))")
                .foregroundColor(.white)

            let count = viewModel.ticketCounts[ticket.id] ?? 0
            if count > 0 {
                HStack(spacing: 8) {
                    Button {
                        viewModel.decrement(ticket: ticket)
                    } label: {
                        Image(systemName: "minus.circle")
                            .foregroundColor(.red)
                    }

                    Text("\(count)")
                        .foregroundColor(.white)
                        .frame(minWidth: 20)

                    Button {
                        viewModel.increment(ticket: ticket)
                    } label: {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.red)
                    }
                }
                .padding(.leading, 8)
            } else {
                Button {
                    viewModel.increment(ticket: ticket)
                } label: {
                    Text("ADD")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.gray.opacity(0.4))
                        .cornerRadius(6)
                }
                .padding(.leading, 8)
            }
        }
        .padding()
    }
}
