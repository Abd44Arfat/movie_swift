import Foundation

struct Booking: Codable, Identifiable {
    let id: String
    let movie: String // ID or Object? API says "Movie Object or ID". Response likely has object, request has ID.
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
}

struct CreateBookingRequest: Codable {
    let movieId: String
    let date: String
    let time: String
    let seats: [String]
    let totalPrice: Double
    let location: String
}
