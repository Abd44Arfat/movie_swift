import SwiftUI

struct MovieSearchView: View {
    let movies: [Movie]
    @State private var searchText = ""
    @Environment(\.dismiss) var dismiss
    @State private var selectedMovie: Movie?
    @State private var showBooking = false
    
    var filteredMovies: [Movie] {
        if searchText.isEmpty {
            return movies
        } else {
            return movies.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Navigation Bar with Search
                HStack(spacing: 12) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white.opacity(0.5))
                        
                        TextField("Search movies...", text: $searchText)
                            .foregroundColor(.white)
                            .accentColor(.white)
                        
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
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(filteredMovies) { movie in
                            MovieCardView(
                                movie: movie,
                                onTap: {
                                    selectedMovie = movie
                                    showBooking = true
                                }
                            )
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showBooking) {
            if let movie = selectedMovie {
                MovieBookingView(
                    movies: movies,
                    initialMovieIndex: movies.firstIndex(where: { $0.id == movie.id }) ?? 0
                )
            }
        }
    }
}

#Preview {
    MovieSearchView(movies: [
        Movie(id: "1", title: "Inside Out 2", posterUrl: "home_image_trailer", genre: ["Animation"], description: "Desc", duration: "1h 36m", rating: 8.5, releaseDate: "2024-06-14",price: 100.00, showtimes: ["15:00"],)
    ])
}
