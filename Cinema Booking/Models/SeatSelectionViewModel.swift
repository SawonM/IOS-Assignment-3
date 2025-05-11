//
//  SeatSelectionViewModel.swift
//  Cinema Booking
//
//  Created by Soorya Narayanan Sanand on 3/5/2025.
//

import SwiftUI

class SeatSelectionViewModel: ObservableObject {
    let rows = ["A", "B", "C", "D", "E", "F"]
    let columns = Array(1...10)
    let unavailableSeats: Set<String> = ["F4", "F5", "F6", "E2", "E3", "D5"]

    @Published var selectedSeats: Set<String> = []

    func isUnavailable(_ seatId: String) -> Bool {
        unavailableSeats.contains(seatId)
    }

    func seatColor(_ seatId: String) -> Color {
        if selectedSeats.contains(seatId) {
            return .blue
        } else if unavailableSeats.contains(seatId) {
            return .gray
        } else {
            return .black
        }
    }

    func toggleSeat(_ seatId: String) {
        guard !isUnavailable(seatId) else { return }

        if selectedSeats.contains(seatId) {
            selectedSeats.remove(seatId)
        } else {
            selectedSeats.insert(seatId)
        }
    }
}
