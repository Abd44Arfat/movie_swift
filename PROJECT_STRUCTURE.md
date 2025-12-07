# 📂 Project Structure Overview

## Complete MVVM Architecture

```
movie_swiftui/
│
├── 📱 App Entry Point
│   ├── movie_swiftuiApp.swift          # App entry point
│   └── ContentView.swift                # Root view (shows MainTabView)
│
├── 🎨 Views/ (UI Layer - What user sees)
│   ├── Home/
│   │   ├── HomeView.swift               # Main home screen (uses HomeViewModel)
│   │   ├── HeaderCarouselView.swift     # Auto-scrolling movie carousel
│   │   ├── PopularMoviesSection.swift   # Horizontal movie list
│   │   ├── MovieCardView.swift          # Individual movie card
│   │   ├── SearchBarView.swift          # Search input
│   │   └── CategoryFilterView.swift     # Category chips
│   │
│   ├── Booking/
│   │   └── MovieBookingView.swift       # Movie booking screen
│   │
│   ├── Auth/
│   │   ├── LoginView.swift              # Login screen
│   │   └── SignUpView.swift             # Sign up screen
│   │
│   ├── MainTabView.swift                # Bottom tab navigation
│   ├── ProfileView.swift                # User profile
│   ├── SearchView.swift                 # Search screen
│   └── CategoriesView.swift             # Categories screen
│
├── 🧠 ViewModels/ (Business Logic Layer)
│   └── HomeViewModel.swift              # Manages movie data fetching & state
│
├── 📦 Models/ (Data Layer)
│   └── Movie.swift                      # Movie data structure
│
├── 🌐 Services/ (Network Layer)
│   └── NetworkService.swift             # Generic networking with Combine
│
├── 🛠️ Utilities/ (Helpers)
│   ├── APIError.swift                   # Custom error types
│   └── Constants.swift                  # API URLs and config
│
└── 📚 Documentation
    ├── MVVM_ARCHITECTURE_GUIDE.md       # Deep dive into MVVM concepts
    ├── SETUP_GUIDE.md                   # Quick setup instructions
    └── PROJECT_STRUCTURE.md             # This file
```

---

## 🔄 Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                         USER TAPS APP                        │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│  HomeView.swift                                              │
│  - Creates @StateObject var viewModel = HomeViewModel()     │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│  HomeViewModel.swift                                         │
│  - init() calls fetchMovies()                                │
│  - @Published var movies: [Movie] = []                       │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│  NetworkService.swift                                        │
│  - func fetch<T: Decodable>(url: URL)                        │
│  - Returns AnyPublisher<T, APIError>                         │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│  BACKEND API                                                 │
│  GET http://localhost:3000/api/movies                        │
│  Returns: [{"_id": "...", "title": "...", ...}]              │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│  Codable (Automatic JSON Parsing)                            │
│  - Maps "_id" → id                                           │
│  - Creates [Movie] array                                     │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│  HomeViewModel.swift                                         │
│  - Receives [Movie] in .sink(receiveValue:)                  │
│  - Updates: self.movies = movies                             │
│  - @Published triggers view update                           │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│  HomeView.swift                                              │
│  - SwiftUI detects @Published change                         │
│  - Automatically re-renders                                  │
│  - Passes movies to HeaderCarouselView & PopularMoviesSection│
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│  AsyncImage                                                  │
│  - Loads images from movie.posterUrl                         │
│  - Shows loading/success/failure states                      │
└─────────────────────────────────────────────────────────────┘
```

---

## 🎯 Key Files Explained

### 1. **Movie.swift** (Model)
**Purpose:** Defines the shape of movie data  
**Key Concepts:**
- `Codable`: Auto JSON parsing
- `Identifiable`: Unique ID for SwiftUI lists
- `CodingKeys`: Maps backend JSON keys to Swift properties

**Example:**
```swift
struct Movie: Identifiable, Codable {
    let id: String       // Maps from "_id"
    let title: String
    let posterUrl: String
    let genre: [String]
}
```

---

### 2. **NetworkService.swift** (Service)
**Purpose:** Handles all network requests  
**Key Concepts:**
- **Generics**: Works with any `Decodable` type
- **Combine**: Reactive programming for async operations
- **Singleton**: One instance for the whole app

**Example:**
```swift
func fetch<T: Decodable>(url: URL) -> AnyPublisher<T, APIError>
```

---

### 3. **HomeViewModel.swift** (ViewModel)
**Purpose:** Manages business logic and state  
**Key Concepts:**
- `ObservableObject`: Can be observed by SwiftUI
- `@Published`: Auto-notifies views of changes
- **Dependency Injection**: Accepts NetworkService for testing

**Example:**
```swift
class HomeViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
}
```

---

### 4. **HomeView.swift** (View)
**Purpose:** Displays the UI  
**Key Concepts:**
- `@StateObject`: Owns the ViewModel
- Reactive UI: Automatically updates when ViewModel changes
- State management: Loading, error, success states

**Example:**
```swift
struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        if viewModel.isLoading {
            ProgressView()
        } else {
            // Show movies
        }
    }
}
```

---

## 🔑 Key iOS Concepts Used

### 1. **Property Wrappers**
| Wrapper | Purpose | When to Use |
|---------|---------|-------------|
| `@State` | Local view state | Simple values (Int, String, Bool) |
| `@StateObject` | Create & own ObservableObject | First time creating ViewModel |
| `@ObservedObject` | Observe existing ObservableObject | Passed from parent |
| `@Published` | Auto-notify observers | In ObservableObject classes |

### 2. **Combine Framework**
- **Publisher**: Emits values over time (like a stream)
- **Subscriber**: Receives values (`.sink`)
- **Operators**: Transform values (`.map`, `.decode`, `.receive(on:)`)

### 3. **Codable**
- Automatic JSON ↔ Swift conversion
- No manual parsing needed
- Use `CodingKeys` for custom mapping

### 4. **AsyncImage**
- SwiftUI component for loading images from URLs
- Handles loading, success, and error states
- Built-in caching

---

## 📝 Naming Conventions

### Files
- **Views**: `HomeView.swift`, `MovieCardView.swift`
- **ViewModels**: `HomeViewModel.swift`
- **Models**: `Movie.swift`, `User.swift`
- **Services**: `NetworkService.swift`, `AuthService.swift`

### Variables
- **Properties**: `camelCase` (e.g., `movieTitle`)
- **Constants**: `camelCase` (e.g., `baseURL`)
- **Classes/Structs**: `PascalCase` (e.g., `HomeViewModel`)

---

## 🚀 How to Extend

### Add a New Feature (e.g., User Profile)

1. **Create Model**
   ```swift
   // Models/User.swift
   struct User: Codable {
       let id: String
       let name: String
       let email: String
   }
   ```

2. **Create ViewModel**
   ```swift
   // ViewModels/ProfileViewModel.swift
   class ProfileViewModel: ObservableObject {
       @Published var user: User?
       
       func fetchUser() {
           // Use NetworkService
       }
   }
   ```

3. **Create View**
   ```swift
   // Views/ProfileView.swift
   struct ProfileView: View {
       @StateObject var viewModel = ProfileViewModel()
       
       var body: some View {
           // UI code
       }
   }
   ```

---

## 🎓 Learning Path

1. ✅ **Start Here**: Read `MVVM_ARCHITECTURE_GUIDE.md`
2. ✅ **Setup**: Follow `SETUP_GUIDE.md`
3. ✅ **Understand Structure**: Read this file
4. ✅ **Experiment**: Modify existing code
5. ✅ **Extend**: Add new features

---

## 📚 Recommended Resources

### Apple Documentation
- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
- [Combine Framework](https://developer.apple.com/documentation/combine)
- [Codable](https://developer.apple.com/documentation/swift/codable)

### MVVM Pattern
- [MVVM in SwiftUI](https://www.hackingwithswift.com/books/ios-swiftui/introducing-mvvm-into-your-swiftui-project)

---

**Happy Learning! 🎉**
