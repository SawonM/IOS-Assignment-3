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
        case settings
        case bookings
    }
    
    @State private var activeView: ActiveView = .home
    @StateObject private var navigationHelper = NavigationHelper()
    
    var body: some View {
        VStack{
            switch activeView {
                case .home:
                    HomeView()
                case .movies:
                    MoviePickerView().environmentObject(navigationHelper)
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
            .onChange(of: navigationHelper.rootActive) { oldValue, newValue in
                if newValue {
                    activeView = .home
                    navigationHelper.rootActive = false
                }
            }
        }
        .onAppear {
            TMDBService.fetchPopularMovies { fetchedMovies in
                movies = fetchedMovies
            }
        }
    }
}

class NavigationHelper: ObservableObject {
    @Published var rootActive: Bool = false

    func returnToRoot() {
        rootActive = true
    }
}


#Preview {
    ContentView()
}
