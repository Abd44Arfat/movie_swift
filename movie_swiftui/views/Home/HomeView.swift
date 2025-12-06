
import Foundation


import SwiftUI

struct HomeView: View {
    @State private var scrollOffset: CGFloat = 0
    @State private var showBooking = false
    @State private var selectedMovieTitle = "Inside Out 2"
    @State private var selectedMovieImage = "home_image_trailer"
    @State private var selectedMovieDuration = "1HR 36 MIN"
    @State private var selectedMovieRating = "PG"
    @State private var selectedMovieIndex = 0
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    // Header Slider
                    HeaderCarouselView(
                        onPlayTrailer: { movieIndex in
                            setSelectedMovie(index: movieIndex)
                            showBooking = true
                        }
                    )
                    
                    VStack(spacing: 16) {
                        // Search Bar
                        SearchBarView()
                            .padding(.horizontal, 20)
                            .padding(.top, 16)
                        
                        // Categories
                        CategoryFilterView()
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                        
                        // Popular Movies
                        PopularMoviesSection(
                            onMovieTap: { movieIndex in
                                setSelectedMovie(index: movieIndex)
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
        .fullScreenCover(isPresented: $showBooking) {
            MovieBookingView(
                movieTitle: selectedMovieTitle,
                movieImage: selectedMovieImage,
                duration: selectedMovieDuration,
                rating: selectedMovieRating,
                initialMovieIndex: selectedMovieIndex
            )
        }
    }
    
    func setSelectedMovie(index: Int) {
        selectedMovieIndex = index
        
        // Map index to movie data
        switch index {
        case 0:
            selectedMovieTitle = "Inside Out 2"
            selectedMovieImage = "home_image_trailer"
            selectedMovieDuration = "1HR 36 MIN"
            selectedMovieRating = "PG"
        case 1:
            selectedMovieTitle = "Garfield"
            selectedMovieImage = "garfield"
            selectedMovieDuration = "1HR 40 MIN"
            selectedMovieRating = "PG"
        case 2:
            selectedMovieTitle = "Movie 3"
            selectedMovieImage = "movie3"
            selectedMovieDuration = "2HR 15 MIN"
            selectedMovieRating = "PG-13"
        default:
            selectedMovieTitle = "Inside Out 2"
            selectedMovieImage = "home_image_trailer"
            selectedMovieDuration = "1HR 36 MIN"
            selectedMovieRating = "PG"
        }
    }
}

#Preview {
    HomeView()
}
