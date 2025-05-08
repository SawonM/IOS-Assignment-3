//
//  ContentView.swift
//  Cinema Booking
//
//  Created by Soorya Narayanan Sanand on 3/5/2025.
//

import SwiftUI

struct ContentView: View {
    
    enum ActiveView {
        case home
        case movies
        case food
        case settings
        case bookings
    }
    @State private var activeView: ActiveView = .home
    
    var body: some View {
        VStack{
            switch activeView {
            case .home:
                HomeView()
            case .movies:
                MoviePickerView()
            case .food:
                FoodView()
            case .settings:
                SettingsView()
            case .bookings:
                BookingsView()
            }
            HStack{
                Group{
                    Button(action: {
                        activeView = .home
                    }) {
                        VStack{
                            Image(systemName: "house")
                            Text("Home")
                        }
                    }
                    Button(action: {
                        activeView = .bookings
                    }) {
                        VStack{
                            Image(systemName: "ticket")
                            Text("Bookings")
                        }
                    }
                    Button(action: {
                        activeView = .movies
                    }) {
                        VStack{
                            Image(systemName: "film")
                            Text("Movies")
                        }
                    }
                    Button(action: {
                        activeView = .food
                    }) {
                        VStack{
                            Image(systemName: "popcorn")
                            Text("Food")
                        }
                    }
                    Button(action: {
                        activeView = .settings
                    }) {
                        VStack{
                            Image(systemName: "gear")
                            Text("Settings")
                        }
                    }
                }
                .padding()
                .font(.system(size: 12))
                .foregroundColor(.black)
            }
        }
        .onAppear {
            TMDBService.fetchPopularMovies { fetchedMovies in
                movies = fetchedMovies
            }
        }
    }
}

#Preview {
    ContentView()
}
