import SwiftUI

struct WishlistView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var favoritesManager: FavoritesManager
    @Environment(\.dismiss) var dismiss
    
    var favoriteMovies: [Movie] {
        homeViewModel.movies.filter { favoritesManager.isFavorite(movieId: $0.id) }
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
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
                    
                    Spacer()
                    
                    Text("Wishlist")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Invisible spacer for balance
                    Color.clear.frame(width: 40, height: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)
                .padding(.bottom, 20)
                
                if favoriteMovies.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        Image(systemName: "heart.slash")
                            .font(.system(size: 80))
                            .foregroundColor(.white.opacity(0.3))
                        
                        Text("Your wishlist is empty")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Text("Mark movies as favorites to see them here")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.6))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(favoriteMovies) { movie in
                                WishlistMovieCard(movie: movie)
                            }
                        }
                        .padding(20)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct WishlistMovieCard: View {
    let movie: Movie
    @EnvironmentObject var favoritesManager: FavoritesManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Poster
            AsyncImage(url: URL(string: movie.posterUrl)) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(ProgressView().tint(.white))
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.white.opacity(0.5))
                        )
                @unknown default:
                    EmptyView()
                }
            }
            .frame(height: 240)
            .cornerRadius(16)
            .overlay(
                Button {
                    favoritesManager.toggleFavorite(movieId: movie.id)
                } label: {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .padding(8)
                        .background(Color.black.opacity(0.6))
                        .clipShape(Circle())
                }
                .padding(8),
                alignment: .topTrailing
            )
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 12))
                    
                    Text(String(format: "%.1f", movie.rating ?? 0.0))
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Spacer()
                    
                    Text(movie.duration ?? "")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
        }
    }
}
