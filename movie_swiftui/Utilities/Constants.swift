import Foundation

struct Constants {
    struct API {
        #if targetEnvironment(simulator)
        static let baseURL = "http://localhost:3000"
        #else
        static let baseURL = "http://192.168.1.5:3000"
        #endif
        
        static let apiKey = "YOUR_API_KEY"
        
        static func fixImageURL(_ urlString: String) -> String {
            if urlString.contains("localhost:3000") {
                return urlString.replacingOccurrences(of: "http://localhost:3000", with: baseURL)
            }
            return urlString
        }
    }
}
