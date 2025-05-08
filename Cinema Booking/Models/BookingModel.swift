//
//  Booking.swift
//  Cinema Booking
//
//  Created by max on 7/5/2025.
//

import Foundation
import SwiftUI

var bookings: [BookingModel] = []

struct BookingModel: Identifiable
{
    let id = UUID()
    let movie: Movie
    let ticket: TicketPurchaseViewModel
    let showtime: TheatreShowtime
}
