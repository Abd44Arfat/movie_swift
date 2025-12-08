import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var searchText = ""
    @State private var selectedMovieIndex = 0
    @State private var showBooking = false
    
    var filteredMovies: [Movie] {
        if searchText.isEmpty {
            return viewModel.movies
        } else {
            return viewModel.movies.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Search Header
                VStack(spacing: 16) {
                    Text("Search")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white.opacity(0.5))
                        
                        TextField("Search movies...", text: $searchText)
                            .foregroundColor(.white)
                            .accentColor(.white)
                            .placeholder(when: searchText.isEmpty) {
                                Text("Search movies...")
                                    .foregroundColor(.white.opacity(0.3))
                            }
                        
                        if !searchText.isEmpty {
                            Button {
                                searchText = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.white.opacity(0.5))
                            }
                        }
                    }
                    .padding(12)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(20)
                }
                .padding()
                .padding(.top, 10)
                
                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(1.5)
                    Spacer()
                } else if filteredMovies.isEmpty {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: searchText.isEmpty ? "magnifyingglass" : "film.stack")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.3))
                        
                        Text(searchText.isEmpty ? "Search for movies" : "No movies found")
                            .font(.system(size: 18))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    Spacer()
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(filteredMovies.indices, id: \.self) { index in
                                let movie = filteredMovies[index]
                                MovieCardView(
                                    movie: movie,
                                    onTap: {
                                        // Find the index in the full movies array
                                        if let movieIndex = viewModel.movies.firstIndex(where: { $0.id == movie.id }) {
                                            selectedMovieIndex = movieIndex
                                            showBooking = true
                                        }
                                    }
                                )
                            }
                        }
                        .padding()
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showBooking) {
            if selectedMovieIndex < viewModel.movies.count {
                MovieBookingView(
                    movies: viewModel.movies,
                    initialMovieIndex: selectedMovieIndex
                )
            }
        }
    }
}

#Preview {
    SearchView()
}
