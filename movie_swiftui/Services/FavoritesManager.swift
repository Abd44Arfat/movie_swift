import Foundation
import SwiftUI

class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()
    
    @Published var favoriteMovieIds: Set<String> = []
    
    private let favoritesKey = "favorite_movie_ids"
    
    private init() {
        loadFavorites()
    }
    
    func toggleFavorite(movieId: String) {
        if favoriteMovieIds.contains(movieId) {
            favoriteMovieIds.remove(movieId)
        } else {
            favoriteMovieIds.insert(movieId)
        }
        saveFavorites()
    }
    
    func isFavorite(movieId: String) -> Bool {
        return favoriteMovieIds.contains(movieId)
    }
    
    private func saveFavorites() {
        let array = Array(favoriteMovieIds)
        UserDefaults.standard.set(array, forKey: favoritesKey)
    }
    
    private func loadFavorites() {
        if let array = UserDefaults.standard.stringArray(forKey: favoritesKey) {
            favoriteMovieIds = Set(array)
        }
    }
}
