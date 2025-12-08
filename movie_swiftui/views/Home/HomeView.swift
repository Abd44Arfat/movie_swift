
import Foundation


import SwiftUI

struct HomeView: View {
    // MVVM: Use ViewModel from Environment
    @EnvironmentObject var viewModel: HomeViewModel
    
    @State private var scrollOffset: CGFloat = 0
    @State private var showSearch = false
    @State private var showBooking = false
    @State private var selectedMovieIndex = 0
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            // Show different states based on ViewModel
            if viewModel.isLoading {
                // Loading state
                VStack(spacing: 16) {
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(1.5)
                    Text("Loading Movies...")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.headline)
                }
            } else if let error = viewModel.errorMessage {
                // Error state
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 50))
                        .foregroundColor(.red)
                    Text("Error")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    Text(error)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Button {
                        viewModel.fetchMovies()
                    } label: {
                        Text("Retry")
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(
                                Capsule()
                                    .fill(Color.blue)
                            )
                    }
                }
            } else {
                // Success state - show movies
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        // Header Slider - pass movies from ViewModel
                        HeaderCarouselView(
                            movies: viewModel.movies,
                            onPlayTrailer: { movieIndex in
                                selectedMovieIndex = movieIndex
                                showBooking = true
                            }
                        )
                        
                        VStack(spacing: 16) {
                            // Search Bar
                            Button {
                                showSearch = true
                            } label: {
                                SearchBarView()
                                    .allowsHitTesting(false) // Disable interaction with the inner text field
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 16)
                            
                            // Categories
                            CategoryFilterView()
                                .padding(.horizontal, 20)
                                .padding(.top, 8)
                            
                            // Popular Movies - pass movies from ViewModel
                            PopularMoviesSection(
                                movies: viewModel.movies,
                                onMovieTap: { movieIndex in
                                    selectedMovieIndex = movieIndex
                                    showBooking = true
                                }
                            )
                                .padding(.top, 8)
                                .padding(.bottom, 100) // Space for tab bar
                        }
                    }
                }
                .coordinateSpace(name: "scroll")
            }
        }
        .fullScreenCover(isPresented: $showSearch) {
            MovieSearchView(movies: viewModel.movies)
        }
        .fullScreenCover(isPresented: $showBooking) {
            if selectedMovieIndex < viewModel.movies.count {
                let selectedMovie = viewModel.movies[selectedMovieIndex]
                MovieBookingView(
                    movies: viewModel.movies,
                    initialMovieIndex: selectedMovieIndex
                )
            }
        }
    }
}

#Preview {
    HomeView()
}
