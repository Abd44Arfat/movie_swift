import Foundation
import Combine

class BookingViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var bookingSuccess = false
    
    @Published var bookedSeats: [String] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    func fetchBookedSeats(movieId: String, date: String, time: String) {
        isLoading = true
        errorMessage = nil
        
        var components = URLComponents(string: "http://localhost:3000/bookings/booked-seats")
        components?.queryItems = [
            URLQueryItem(name: "movieId", value: movieId),
            URLQueryItem(name: "date", value: date),
            URLQueryItem(name: "time", value: time)
        ]
        
        guard let url = components?.url else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        networkService.fetch(url: url)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching booked seats: \(error)")
                }
            } receiveValue: { [weak self] (seats: [String]) in
                self?.bookedSeats = seats
            }
            .store(in: &cancellables)
    }
    
    func createBooking(movieId: String, date: String, time: String, seats: [String], totalPrice: Double, location: String) {
        isLoading = true
        errorMessage = nil
        bookingSuccess = false
        
        let request = CreateBookingRequest(
            movieId: movieId,
            date: date,
            time: time,
            seats: seats,
            totalPrice: totalPrice,
            location: location
        )
        
        guard let url = URL(string: "http://localhost:3000/bookings") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        networkService.sendRequest(url: url, method: "POST", body: request)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] (booking: Booking) in
                self?.bookingSuccess = true
            }
            .store(in: &cancellables)
    }
}
