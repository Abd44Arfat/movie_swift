import Foundation
import Combine

class BookingManager: ObservableObject {
    static let shared = BookingManager()
    
    @Published var bookings: [Booking] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let networkService: NetworkServiceProtocol
    
    private init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
        fetchBookings()
    }
    
    func fetchBookings() {
        guard let url = URL(string: Constants.API.baseURL + "/bookings/my-bookings") else { return }
        
        isLoading = true
        
        networkService.sendRequest(url: url, method: "GET", body: nil as String?, headers: [:])
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print("Error fetching bookings: \(error)")
                }
            } receiveValue: { [weak self] (bookings: [Booking]) in
                self?.bookings = bookings
            }
            .store(in: &cancellables)
    }
    
    func addBooking(_ booking: Booking) {
        bookings.append(booking)
    }
}
