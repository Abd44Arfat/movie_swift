import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case requestFailed
    case decodingFailed
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid."
        case .requestFailed:
            return "The network request failed."
        case .decodingFailed:
            return "Failed to decode the response."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}
