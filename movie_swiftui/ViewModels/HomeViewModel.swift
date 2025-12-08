import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    // @Published properties automatically notify the View when they change
    @Published var movies: [Movie] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>() // Memory management
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
        fetchMovies() // Fetch movies when ViewModel is created
    }
    
    // MARK: - Fetch Movies from Backend
    func fetchMovies(genre: String? = nil) {
        // Using Constants for base URL
        var components = URLComponents(string: Constants.API.baseURL + "/movies")
        
        if let genre = genre, genre != "All" {
            components?.queryItems = [URLQueryItem(name: "genre", value: genre)]
        }
        
        guard let url = components?.url else {
            self.errorMessage = "Invalid URL"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // The backend returns an array directly, not wrapped in a "results" object
        networkService.fetch(url: url)
            .sink(receiveCompletion: { [weak self] completion in
                DispatchQueue.main.async {
                    self?.isLoading = false
                }
                switch completion {
                case .finished:
                    print("✅ Movies fetch completed successfully")
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.errorMessage = error.localizedDescription
                    }
                    print("❌ Error fetching movies: \(error)")
                }
            }, receiveValue: { [weak self] (movies: [Movie]) in
                // Backend returns array directly, not wrapped
                DispatchQueue.main.async {
                    self?.movies = movies
                    print("✅ Successfully fetched \(movies.count) movies")
                }
            })
            .store(in: &cancellables)
    }
}
