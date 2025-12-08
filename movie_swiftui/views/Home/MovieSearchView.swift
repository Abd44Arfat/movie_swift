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
                        
                        TextField("", text: $searchText)
                            .placeholder(when: searchText.isEmpty) {
                                Text("Search movies...")
                                    .foregroundColor(.white.opacity(0.3))
                            }
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
                                    print("🎬 Movie tapped in search:")
                                    print("   Title: \(movie.title)")
                                    print("   ID: \(movie.id)")
                                    print("   Movies array count: \(movies.count)")
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
                if let movieIndex = movies.firstIndex(where: { $0.id == movie.id }) {
                    MovieBookingView(
                        movies: movies,
                        initialMovieIndex: movieIndex
                    )
                } else {
                    // Debug: Movie not found in array
                    ZStack {
                        Color.black.ignoresSafeArea()
                        VStack(spacing: 16) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 50))
                                .foregroundColor(.red)
                            Text("Movie not found")
                                .foregroundColor(.white)
                                .font(.headline)
                            Text("Movie ID: \(movie.id)")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.caption)
                            Text("Total movies: \(movies.count)")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.caption)
                            Button("Close") {
                                showBooking = false
                            }
                            .foregroundColor(.blue)
                        }
                        .padding()
                    }
                    .onAppear {
                        print("🔍 DEBUG: Movie not found!")
                        print("   Selected movie ID: \(movie.id)")
                        print("   Selected movie title: \(movie.title)")
                        print("   Total movies in array: \(movies.count)")
                        print("   Movie IDs in array: \(movies.map { $0.id })")
                    }
                }
            } else {
                // selectedMovie is nil
                ZStack {
                    Color.black.ignoresSafeArea()
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.red)
                        Text("No movie selected")
                            .foregroundColor(.white)
                            .font(.headline)
                        Button("Close") {
                            showBooking = false
                        }
                        .foregroundColor(.blue)
                    }
                }
                .onAppear {
                    print("🔍 DEBUG: selectedMovie is nil!")
                }
            }
        }
    }
}

