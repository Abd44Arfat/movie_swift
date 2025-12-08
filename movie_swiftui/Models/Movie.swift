import Foundation

// MARK: - Movie Model
// This matches the backend response structure
struct Movie: Identifiable, Codable, Equatable {
    // Equatable conformance - compare by id
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.id == rhs.id
    }
    let id: String          // Backend uses "_id" as String
    let title: String       // Movie title
    private let _posterUrl: String   // Raw URL from backend
    let genre: [String]     // Array of genres
    let description: String? // Movie description
    let duration: String?    // Duration (e.g., "2h 30m")
    let rating: Double?      // Rating (e.g., 8.5)
    let releaseDate: String? // Release date in ISO format
    let price: Double?       // Ticket price
    let showtimes: [String]? // Available showtimes (e.g., ["10:00", "14:00"])
    
    // Computed property that fixes localhost URLs
    var posterUrl: String {
        Constants.API.fixImageURL(_posterUrl)
    }
    
    // CodingKeys maps the backend JSON keys to our Swift property names
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case _posterUrl = "posterUrl"
        case genre
        case description
        case duration
        case rating
        case releaseDate
        case price
        case showtimes
    }
}
