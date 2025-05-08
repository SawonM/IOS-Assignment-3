//
//  TicketPurchaseViewModel.swift
//  Cinema Booking
//
//  Created by Soorya Narayanan Sanand on 3/5/2025.
//

import SwiftUI

class TicketPurchaseViewModel: ObservableObject {
    struct TicketOption: Identifiable {
        let id = UUID()
        let label: String
        let price: Double
    }

    let seatIDs: [String]
    let bookingFee = 3.40
    let movie: Movie

    @Published var ticketCounts: [UUID: Int] = [:]

    var allTickets: [TicketOption] = [
        TicketOption(label: "Adult Ticket", price: 24.75),
        TicketOption(label: "Child Ticket", price: 18.00),
        TicketOption(label: "Concession Ticket", price: 20.70),
        TicketOption(label: "Student Ticket", price: 20.70),
        TicketOption(label: "Senior Ticket", price: 18.00),
        TicketOption(label: "Voucher", price: 0.00)
    ]

    var totalTickets: Int {
        ticketCounts.values.reduce(0, +)
    }

    var totalCost: Double {
        let subtotal = ticketCounts.reduce(0.0) { acc, entry in
            guard let ticket = allTickets.first(where: { $0.id == entry.key }) else { return acc }
            return acc + Double(entry.value) * ticket.price
        }
        return subtotal + (totalTickets > 0 ? bookingFee : 0)
    }

    init(movie: Movie, seatIDs: [String]) {
        self.movie = movie
        self.seatIDs = seatIDs
    }

    func increment(ticket: TicketOption) {
        guard totalTickets < seatIDs.count else { return }
        ticketCounts[ticket.id, default: 0] += 1
    }

    func decrement(ticket: TicketOption) {
        if let count = ticketCounts[ticket.id], count > 0 {
            ticketCounts[ticket.id] = count - 1
        }
    }
}

