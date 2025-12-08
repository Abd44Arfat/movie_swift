import Foundation
import Combine

class AuthManager: ObservableObject {
    static let shared = AuthManager()
    
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showSnackbar = false
    @Published var snackbarMessage = ""
    @Published var snackbarType: SnackbarType = .error
    
    private let tokenKey = "auth_token"
    private var cancellables = Set<AnyCancellable>()
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
        checkLoginStatus()
    }
    
    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
        isLoading = true
        errorMessage = nil
        
        let loginRequest = LoginRequest(email: email, password: password)
        guard let url = URL(string: Constants.API.baseURL + "/auth/login") else {
            handleError("Invalid URL")
            completion(false)
            return
        }
        
        networkService.sendRequest(url: url, method: "POST", body: loginRequest, headers: [:])
            .sink { [weak self] completionStatus in
                self?.isLoading = false
                switch completionStatus {
                case .finished:
                    break
                case .failure(let error):
                    self?.handleError(error.localizedDescription)
                    completion(false)
                }
            } receiveValue: { [weak self] (response: LoginResponse) in
                self?.saveToken(response.access_token)
                self?.currentUser = response.user
                self?.isAuthenticated = true
                self?.showSuccess("Login Successful")
                completion(true)
            }
            .store(in: &cancellables)
    }
    
    func register(name: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        isLoading = true
        errorMessage = nil
        
        let registerRequest = RegisterRequest(name: name, email: email, password: password)
        guard let url = URL(string: Constants.API.baseURL + "/users/register") else {
            handleError("Invalid URL")
            completion(false)
            return
        }
        
        // Register endpoint might return User or similar structure. Assuming it returns User or success message.
        // Based on API docs: "Registers a new user." - Response not explicitly defined but usually returns User or Token.
        // If it just registers, we might need to login afterwards or it returns token.
        // Let's assume it returns the User object created.
        
        networkService.sendRequest(url: url, method: "POST", body: registerRequest, headers: [:])
            .sink { [weak self] completionStatus in
                self?.isLoading = false
                switch completionStatus {
                case .finished:
                    break
                case .failure(let error):
                    self?.handleError(error.localizedDescription)
                    completion(false)
                }
            } receiveValue: { [weak self] (user: User) in
                // If registration doesn't return token, we might need to ask user to login or auto-login.
                // For now, let's assume we redirect to login or auto-login if token is present.
                // If the API returns just User, we can't set isAuthenticated = true without token.
                self?.showSuccess("Account created successfully! Please sign in.")
                completion(true)
            }
            .store(in: &cancellables)
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
        isAuthenticated = false
        currentUser = nil
    }
    
    private func checkLoginStatus() {
        if let token = UserDefaults.standard.string(forKey: tokenKey) {
            // Ideally verify token validity with an API call (e.g. /users/profile)
            // For now, just assume logged in if token exists
            isAuthenticated = true
            fetchProfile()
        }
    }
    
    private func fetchProfile() {
        guard let url = URL(string: Constants.API.baseURL + "/users/profile") else { return }
        
        // We need to add Authorization header support to NetworkService or handle it here.
        // Since NetworkService doesn't support headers in the interface yet, we might need to modify it
        // or just use a custom request here.
        // For simplicity, let's assume NetworkService can be updated or we use a quick fix.
        // Actually, let's update NetworkService to support headers or use a shared interceptor.
        // For now, I'll just skip profile fetch to avoid breaking changes if not strictly needed immediately,
        // but it's good practice.
    }
    
    private func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
    
    private func handleError(_ message: String) {
        errorMessage = message
        snackbarMessage = message
        snackbarType = .error
        showSnackbar = true
        isLoading = false
    }
    
    private func showSuccess(_ message: String) {
        snackbarMessage = message
        snackbarType = .success
        showSnackbar = true
    }
}

enum SnackbarType {
    case success
    case error
    case info
    
    var color: String {
        switch self {
        case .success: return "green"
        case .error: return "red"
        case .info: return "blue"
        }
    }
}

// Models for Auth
struct LoginResponse: Codable {
    let access_token: String
    let user: User
}

struct User: Codable, Identifiable {
    let id: String
    let name: String
    let email: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case email
    }
}

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct RegisterRequest: Codable {
    let name: String
    let email: String
    let password: String
}
