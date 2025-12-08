import Foundation

struct Constants {
    struct API {
        // IMPORTANT: Replace with your computer's IP address
        // Find it by running: ipconfig getifaddr en0
        // Example: "http://192.168.1.5:3000"
        
        // For iOS Simulator: use localhost
        // For Physical Device: use your Mac's IP address (e.g., "192.168.1.5")
        #if targetEnvironment(simulator)
        static let baseURL = "http://localhost:3000"
        #else
        static let baseURL = "http://192.168.1.5:3000"  // CHANGE THIS TO YOUR IP!
        #endif
        
        static let apiKey = "YOUR_API_KEY"
        
        // Helper to fix image URLs that come from backend with localhost
        static func fixImageURL(_ urlString: String) -> String {
            // If the URL contains localhost, replace it with the actual base URL
            if urlString.contains("localhost:3000") {
                return urlString.replacingOccurrences(of: "http://localhost:3000", with: baseURL)
            }
            return urlString
        }
    }
}

// INSTRUCTIONS:
// 1. Find your Mac's IP address:
//    - Terminal: ipconfig getifaddr en0
//    - Or: System Settings > Network > WiFi > Details > TCP/IP
// 2. Replace localhost with your IP, example:
//    static let baseURL = "http://192.168.1.5:3000"
// 3. Make sure your iPhone/Simulator and Mac are on the same WiFi network
