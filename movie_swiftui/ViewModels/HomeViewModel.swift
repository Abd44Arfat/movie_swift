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
    func fetchMovies() {
        // Using Constants for base URL
        // For iOS Simulator: "http://localhost:3000" works
        // For Real Device: Update Constants.API.baseURL to your computer's IP
        guard let url = URL(string: Constants.API.baseURL + "/movies") else {
            self.errorMessage = "Invalid URL"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // The backend returns an array directly, not wrapped in a "results" object
        networkService.fetch(url: url)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print("❌ Error fetching movies: \(error)")
                }
            }, receiveValue: { [weak self] (movies: [Movie]) in
                // Backend returns array directly, not wrapped
                self?.movies = movies
                print("✅ Successfully fetched \(movies.count) movies")
            })
            .store(in: &cancellables)
    }
}
