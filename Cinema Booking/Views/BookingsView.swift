//
//  BookingsView.swift
//  Cinema Booking
//
//  Created by max on 7/5/2025.
//

import SwiftUI
struct BookingsView: View {
    @State private var bookingsList: [BookingModel] = bookings

    var body: some View {
        NavigationView{
            VStack{
                ForEach(bookingsList) { booking in
                    HStack(spacing: 0) {
                        Rectangle()
                            .fill(Color.red)
                            .frame(width: 6, height: 80)
                        HStack{
                            Image(systemName: "ticket")
                            VStack(alignment: .leading, spacing: 2) {
                                Text("\(booking.movie.title)")
                                    .foregroundColor(.white)
                                    .font(.headline)
                                
                                Text("Location: \(booking.showtime.location)")
                                    .foregroundColor(.white)
                                    .font(.caption)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Time: \(booking.showtime.time)")
                                    .foregroundColor(.white)
                                    .font(.headline)
                                HStack{
                                    Text("Seats:")
                                        .foregroundColor(.white)
                                        .font(.caption)
                                    ForEach(booking.ticket.seatIDs, id: \.self){ seat in
                                        Text(seat)
                                            .foregroundColor(.white)
                                            .font(.caption)
                                    }
                                }
                            }
                            Spacer()
                            Button(action: {
                                withAnimation {
                                    bookingsList.removeAll { $0.id == booking.id }
                                    bookings = bookingsList
                                }
                            }) {
                                Image(systemName: "xmark.circle")
                                    .foregroundColor(.red)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.gray)
                    }
                    .cornerRadius(12)
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Your bookings")
            .onAppear {
                bookingsList = bookings
            }
        }
    }
}
