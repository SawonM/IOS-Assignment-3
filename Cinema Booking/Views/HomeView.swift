import SwiftUI


struct HomeView: View {
    private let userNameKey = "userName"
    @State private var navigateToMovies = false
    @State private var recommendedMovies: [Movie] = []
    @State private var userName: String = UserDefaults.standard.string(forKey: "userName") ?? "Citizen"
    
        var body: some View {
            NavigationView{
                VStack {
                    Text("CineQuick")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.bottom, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                    
                    Text("Welcome, \(userName)")
                        .font(.title2)
                        .foregroundColor(.black)
                        .padding(.bottom, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                    
                    Button(action: {
                        navigateToMovies = true
                    }) {
                        Text("Browse Movies")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 12)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 30)
                    .padding(.horizontal, 20)
                    .background(
                        NavigationLink(destination: MoviePickerView().navigationBarBackButtonHidden(true), isActive: $navigateToMovies) {
                            EmptyView()
                        }
                    )
                    
                    Text("Recommended")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .padding(.leading, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            ForEach(recommendedMovies.prefix(3)) { movie in
                                NavigationLink(destination: TimingSelectionView(movie: movie)) {
                                    RecommendedMovieCard(movie: movie)
                                }
                                .padding(.horizontal, 20)
                                .padding(.bottom, 10)
                            }
                        }
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .onAppear {
                    TMDBService.fetchPopularMovies { fetchedMovies in
                        let shuffledMovies = fetchedMovies.shuffled()
                        recommendedMovies = Array(shuffledMovies.prefix(3))
                    }
                    loadUserName()
                }
            }
            
        }
        
        struct RecommendedMovieCard: View {
            let movie: Movie
            
            var body: some View {
                HStack {
                    if let posterURL = movie.posterURL {
                        AsyncImage(url: posterURL) { phase in
                            switch phase {
                            case .empty:
                                Color.gray
                                    .frame(width: 50, height: 75)
                                    .cornerRadius(4)
                            case .success(let image):
                                image
                                    .resizable()
                                    .frame(width: 50, height: 75)
                                    .cornerRadius(4)
                            case .failure:
                                Color.red
                                    .frame(width: 50, height: 75)
                                    .cornerRadius(4)
                            @unknown default:
                                Color.gray
                                    .frame(width: 50, height: 75)
                                    .cornerRadius(4)
                            }
                        }
                    } else {
                        Color.gray
                            .frame(width: 50, height: 75)
                            .cornerRadius(4)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(movie.title)
                            .font(.headline)
                            .foregroundColor(.black)
                        Text(movie.releaseDate)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding(.vertical, 4)
            }
        }
        
        private func loadUserName() {
            userName = UserDefaults.standard.string(forKey: userNameKey) ?? "Citizen"
        }
    }
