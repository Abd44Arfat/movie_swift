import Foundation

struct Booking: Codable, Identifiable {
    let id: String
    let movieId: String
    let movieDetails: Movie?
    let date: String
    let time: String
    let seats: [String]
    let totalPrice: Double
    let location: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case movie
        case date
        case time
        case seats
        case totalPrice
        case location
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        date = try container.decode(String.self, forKey: .date)
        time = try container.decode(String.self, forKey: .time)
        seats = try container.decode([String].self, forKey: .seats)
        totalPrice = try container.decode(Double.self, forKey: .totalPrice)
        location = try container.decode(String.self, forKey: .location)
        
        // Handle movie field - can be either String (ID) or Movie object
        if let movieObject = try? container.decode(Movie.self, forKey: .movie) {
            movieDetails = movieObject
            movieId = movieObject.id
        } else if let movieIdString = try? container.decode(String.self, forKey: .movie) {
            movieId = movieIdString
            movieDetails = nil
        } else {
            throw DecodingError.typeMismatch(
                String.self,
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Movie field must be either a String or Movie object"
                )
            )
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(movieId, forKey: .movie)
        try container.encode(date, forKey: .date)
        try container.encode(time, forKey: .time)
        try container.encode(seats, forKey: .seats)
        try container.encode(totalPrice, forKey: .totalPrice)
        try container.encode(location, forKey: .location)
    }
}

struct CreateBookingRequest: Codable {
    let movieId: String
    let date: String
    let time: String
    let seats: [String]
    let totalPrice: Double
    let location: String
}
