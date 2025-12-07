import Foundation

// MARK: - Movie Model
// This matches the backend response structure
struct Movie: Identifiable, Codable {
    let id: String          // Backend uses "_id" as String
    let title: String       // Movie title
    let posterUrl: String   // Full URL to poster image
    let genre: [String]     // Array of genres
    let description: String? // Movie description
    let duration: String?    // Duration (e.g., "2h 30m")
    let rating: Double?      // Rating (e.g., 8.5)
    let releaseDate: String? // Release date in ISO format
    let price: Double?       // Ticket price
    let showtimes: [String]? // Available showtimes (e.g., ["10:00", "14:00"])
    
    // CodingKeys maps the backend JSON keys to our Swift property names
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case posterUrl
        case genre
        case description
        case duration
        case rating
        case releaseDate
        case price
        case showtimes
    }
}
