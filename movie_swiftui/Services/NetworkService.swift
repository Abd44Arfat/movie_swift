import Foundation
import Combine

protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(url: URL) -> AnyPublisher<T, APIError>
    func sendRequest<T: Decodable, U: Encodable>(url: URL, method: String, body: U?) -> AnyPublisher<T, APIError>
}

class NetworkService: NetworkServiceProtocol {
    
    static let shared = NetworkService()
    private var cancellables = Set<AnyCancellable>()
    
    private init() {}
    
    func fetch<T: Decodable>(url: URL) -> AnyPublisher<T, APIError> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> Data in
                if let httpResponse = response as? HTTPURLResponse {
                    print("GET \(url.absoluteString) - Status: \(httpResponse.statusCode)")
                    if !(200...299).contains(httpResponse.statusCode) {
                        if let responseString = String(data: data, encoding: .utf8) {
                            print("Response Body: \(responseString)")
                        }
                        throw APIError.requestFailed
                    }
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> APIError in
                print("Decoding error: \(error)")
                if error is DecodingError {
                    return .decodingFailed
                } else if let apiError = error as? APIError {
                    return apiError
                } else {
                    return .unknown
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func sendRequest<T: Decodable, U: Encodable>(url: URL, method: String, body: U?) -> AnyPublisher<T, APIError> {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            do {
                let jsonData = try JSONEncoder().encode(body)
                request.httpBody = jsonData
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("Request Body: \(jsonString)")
                }
            } catch {
                return Fail(error: APIError.unknown).eraseToAnyPublisher()
            }
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { (data, response) -> Data in
                if let httpResponse = response as? HTTPURLResponse {
                    print("\(method) \(url.absoluteString) - Status: \(httpResponse.statusCode)")
                    if !(200...299).contains(httpResponse.statusCode) {
                        if let responseString = String(data: data, encoding: .utf8) {
                            print("Response Body: \(responseString)")
                        }
                        throw APIError.requestFailed
                    }
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> APIError in
                print("Decoding error: \(error)")
                if error is DecodingError {
                    return .decodingFailed
                } else if let apiError = error as? APIError {
                    return apiError
                } else {
                    return .unknown
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
