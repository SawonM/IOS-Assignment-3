import SwiftUI

struct MoviePickerView: View {
    @State private var movies: [Movie] = []
    @State private var filteredMovies: [Movie] = []
    @State private var filterName: String = ""

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search", text: $filterName)
                    .padding()
                    .frame(maxWidth: 360, maxHeight: 40)
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray, lineWidth: 2))
                    .onChange(of: filterName) {
                        filterList()
                    }
                    .cornerRadius(4)
                    .padding(.top, 10)
                    .padding(.bottom, 20)

                List(filteredMovies) { movie in
                    NavigationLink(destination: TimingSelectionView(movie: movie)) {
                        HStack {
                            if let url = movie.posterURL {
                                AsyncImage(url: url) { phase in
                                    if let image = phase.image {
                                        image.resizable()
                                    } else {
                                        Color.gray
                                    }
                                }
                                .frame(width: 50, height: 75)
                                .cornerRadius(4)
                            }

                            VStack(alignment: .leading) {
                                Text(movie.title).font(.headline)
                                Text(movie.releaseDate).font(.caption).foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .navigationTitle("Select a Movie")
                .onAppear {
                    TMDBService.fetchPopularMovies { fetchedMovies in
                        self.movies = fetchedMovies
                        self.filteredMovies = fetchedMovies
                    }
                }
            }
        }
    }


    func filterList() {
        if filterName.isEmpty {
            filteredMovies = movies
        } else {
            filteredMovies = movies.filter {
                $0.title.lowercased().contains(filterName.lowercased())
            }
        }
    }
}



#Preview {
    MoviePickerView()
}
