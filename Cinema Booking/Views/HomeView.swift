import SwiftUI

struct HomeView: View {
    private let userNameKey = "userName"
    @State private var navigateToMovies = false
    @State private var upcomingMovies: [Movie] = []
    @State private var userName: String = UserDefaults.standard.string(forKey: "userName") ?? "Citizen"

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {

                    HStack(spacing: 16) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.blue)
                        VStack(alignment: .leading) {
                            Text("CineQuick")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.black)
                            Text("Welcome, \(userName)")
                                .font(.title3)
                                .foregroundColor(.black)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 32)

                    if !upcomingMovies.isEmpty {
                        Text("Upcoming Movies")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(upcomingMovies) { movie in
                                    VStack(alignment: .leading, spacing: 8) {
                                        if let url = movie.posterURL {
                                            AsyncImage(url: url) { image in
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 120, height: 180)
                                                    .cornerRadius(10)
                                            } placeholder: {
                                                Rectangle()
                                                    .fill(Color.gray.opacity(0.3))
                                                    .frame(width: 120, height: 180)
                                                    .cornerRadius(10)
                                            }
                                        }
                                        Text(movie.title)
                                            .font(.caption)
                                            .foregroundColor(.black)
                                            .lineLimit(2)
                                    }
                                    .frame(width: 120)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    

                    Text("Your Bookings")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.horizontal)

                    YourBookingsView()
                        .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Color.white)
            .onAppear {
                TMDBService.fetchUpcomingMovies { fetchedUpcoming in
                    self.upcomingMovies = Array(fetchedUpcoming.prefix(5))
                }
                loadUserName()
            }
        }
    }

    private func loadUserName() {
        userName = UserDefaults.standard.string(forKey: userNameKey) ?? "Citizen"
    }
}

struct YourBookingsView: View {
    @State private var bookingsList: [BookingModel] = bookings

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                if bookingsList.isEmpty {
                    VStack(alignment: .center, spacing: 16) {
                        Image(systemName: "ticket.slash")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray)

                        Text("No bookings yet")
                            .font(.title2)
                            .foregroundColor(.gray)

                        Text("Book your first movie and it will show up here.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.top, 10)
                } else {
                    ForEach(bookingsList) { booking in
                        HStack(alignment: .center, spacing: 12) {
                            Image(systemName: "ticket")
                                .foregroundColor(.black)
                                .rotationEffect(.degrees(90))
                                .font(.system(size: 20))
                                .padding(.top, 2)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(booking.movie.title)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)

                                Text("Location: \(booking.showtime.location)")
                                    .font(.caption)
                                    .foregroundColor(.black.opacity(0.85))
                            }

                            Spacer()

                            VStack(alignment: .trailing, spacing: 4) {
                                Text("Time: \(booking.showtime.time)")
                                    .font(.subheadline)
                                    .foregroundColor(.black)

                                HStack(spacing: 4) {
                                    Text("Seats:")
                                        .font(.caption)
                                        .foregroundColor(.black)
                                    ForEach(booking.ticket.seatIDs, id: \.self) { seat in
                                        Text(seat)
                                            .font(.caption)
                                            .foregroundColor(.black)
                                    }
                                }
                            }

                            Button(action: {
                                withAnimation {
                                    bookingsList.removeAll { $0.id == booking.id }
                                    bookings = bookingsList
                                }
                            }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.black)
                                    .padding(6)
                                    .background(Color.black.opacity(0.1))
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal)
                        .background(Color(UIColor.systemGroupedBackground))
                        .cornerRadius(16)
                        .padding(.leading, 6)
                    }
                }

                Spacer()
            }
            .padding(.top, 5)
            .onAppear {
                bookingsList = bookings
            }
        }
    }
}
