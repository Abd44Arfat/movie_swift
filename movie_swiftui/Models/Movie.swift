import Foundation

struct Movie: Identifiable, Codable, Equatable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: String
    let title: String
    private let _posterUrl: String
    let genre: [String]
    let description: String?
    let duration: String?
    let rating: Double?
    let releaseDate: String?
    let price: Double?
    let showtimes: [String]?
    
    var posterUrl: String {
        Constants.API.fixImageURL(_posterUrl)
    }
    
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
