# 🎬 MVVM Architecture Guide - Movie App

## 📚 Table of Contents
1. [What is MVVM?](#what-is-mvvm)
2. [Project Structure](#project-structure)
3. [Deep Dive: Line-by-Line Explanation](#deep-dive)
4. [How to Connect to Your Backend](#backend-connection)
5. [Key iOS Concepts Used](#key-concepts)

---

## What is MVVM?

**MVVM** stands for **Model-View-ViewModel**. It's a design pattern that separates your code into three layers:

```
┌─────────────┐
│    VIEW     │  ← What the user sees (SwiftUI)
└──────┬──────┘
       │ observes
       ▼
┌─────────────┐
│ VIEW MODEL  │  ← The "Brain" (Business Logic)
└──────┬──────┘
       │ uses
       ▼
┌─────────────┐
│    MODEL    │  ← The Data Structure
└─────────────┘
```

### Why MVVM?
- **Separation of Concerns**: UI code is separate from business logic
- **Testability**: You can test ViewModels without needing the UI
- **Reusability**: ViewModels can be reused across different views
- **Maintainability**: Easier to find and fix bugs

---

## Project Structure

```
movie_swiftui/
├── Models/              ← Data structures (what your data looks like)
│   └── Movie.swift
│
├── ViewModels/          ← Business logic (fetching, processing data)
│   └── HomeViewModel.swift
│
├── Views/               ← UI components (what user sees)
│   └── Home/
│       ├── HomeView.swift
│       ├── HeaderCarouselView.swift
│       ├── PopularMoviesSection.swift
│       └── MovieCardView.swift
│
├── Services/            ← Networking layer (talks to backend)
│   └── NetworkService.swift
│
└── Utilities/           ← Helper files
    ├── APIError.swift
    └── Constants.swift
```

---

## Deep Dive: Line-by-Line Explanation

### 1️⃣ **Movie.swift** (The Model)

```swift
struct Movie: Identifiable, Codable {
```

**What is `struct`?**
- A **value type** in Swift (like a blueprint for data)
- Lightweight and fast
- Automatically thread-safe

**What is `Identifiable`?**
- A protocol that requires an `id` property
- Tells SwiftUI: "Each movie is unique"
- Allows SwiftUI to efficiently update lists

**What is `Codable`?**
- A combination of `Encodable` + `Decodable`
- Allows automatic conversion between Swift objects and JSON
- No manual parsing needed!

```swift
let id: String          // Backend uses "_id" as String
let title: String       // Movie title
let posterUrl: String   // Relative path to poster image
let genre: [String]     // Array of genres
```

**Why `let` instead of `var`?**
- `let` = constant (cannot be changed after creation)
- `var` = variable (can be changed)
- For data models, we use `let` because the data from the backend shouldn't change

```swift
enum CodingKeys: String, CodingKey {
    case id = "_id"           // Backend sends "_id", we use "id"
    case title                // Same name, no mapping needed
    case posterUrl            // Same name, no mapping needed
    case genre                // Same name, no mapping needed
}
```

**What is `CodingKeys`?**
- Maps JSON keys to Swift property names
- Example: Backend sends `"_id"`, but we want to use `id` in our code
- If names match exactly, you don't need to specify them (but it's good practice)

```swift
var fullPosterURL: String {
    return "http://YOUR_BACKEND_URL:PORT/\(posterUrl)"
}
```

**What is a computed property?**
- A property that calculates its value when accessed
- Not stored in memory, calculated on-the-fly
- `\(posterUrl)` is **string interpolation** (inserting a variable into a string)

---

### 2️⃣ **NetworkService.swift** (The Network Layer)

```swift
protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(url: URL) -> AnyPublisher<T, APIError>
}
```

**What is a `protocol`?**
- A blueprint that defines requirements
- Like a contract: "Any class that conforms to this must have these methods"
- Used for **dependency injection** and **testing**

**What is `<T: Decodable>` (Generics)?**
- `T` is a placeholder for any type
- `T: Decodable` means "T can be any type, as long as it can be decoded from JSON"
- This makes the function reusable for different data types

**What is `AnyPublisher<T, APIError>`?**
- Part of **Combine** framework
- A publisher that will eventually emit either:
  - **Success**: Data of type `T`
  - **Failure**: An error of type `APIError`

```swift
static let shared = NetworkService()
private init() {}
```

**What is the Singleton Pattern?**
- `static let shared` creates ONE instance for the entire app
- `private init()` prevents creating new instances
- Why? To avoid creating multiple network managers (waste of resources)

```swift
return URLSession.shared.dataTaskPublisher(for: url)
```

**What is `URLSession`?**
- Apple's built-in networking API
- `dataTaskPublisher` returns a Combine publisher
- Sends an HTTP request to the URL

```swift
.tryMap { (data, response) -> Data in
    guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
        throw APIError.requestFailed
    }
    return data
}
```

**What is `tryMap`?**
- Transforms the data
- Can throw errors (that's why it's "try")
- `guard` checks if the response is valid (status code 200-299 means success)

**What are HTTP status codes?**
- 200-299: Success ✅
- 400-499: Client error (e.g., 404 Not Found) ❌
- 500-599: Server error ❌

```swift
.decode(type: T.self, decoder: JSONDecoder())
```

**What is `decode`?**
- Converts raw JSON data into a Swift object
- `T.self` means "the type we specified in the generic"
- `JSONDecoder()` is Apple's built-in JSON parser

```swift
.receive(on: DispatchQueue.main)
```

**What is `DispatchQueue.main`?**
- iOS has multiple threads (like parallel lanes on a highway)
- **Main thread**: Where all UI updates happen
- **Background threads**: Where heavy work (like networking) happens
- This line switches from background → main thread

```swift
.eraseToAnyPublisher()
```

**What is `eraseToAnyPublisher`?**
- Hides the complex type and returns a simple `AnyPublisher`
- Makes the code cleaner and easier to work with

---

### 3️⃣ **HomeViewModel.swift** (The Brain)

```swift
class HomeViewModel: ObservableObject {
```

**Why `class` instead of `struct`?**
- ViewModels are **reference types** (classes)
- They need to be shared and modified
- `ObservableObject` is a protocol that allows SwiftUI to watch for changes

```swift
@Published var movies: [Movie] = []
@Published var isLoading: Bool = false
@Published var errorMessage: String?
```

**What is `@Published`?**
- A **property wrapper** that automatically notifies SwiftUI when the value changes
- When `movies` changes, SwiftUI re-renders the view
- This is the "magic" of reactive programming!

```swift
private var cancellables = Set<AnyCancellable>()
```

**What is `cancellables`?**
- Stores active network requests
- Without this, Swift would cancel the request immediately (to save memory)
- Think of it as "keeping the request alive"

```swift
init(networkService: NetworkServiceProtocol = NetworkService.shared) {
    self.networkService = networkService
    fetchMovies()
}
```

**What is dependency injection?**
- Instead of hardcoding `NetworkService.shared`, we pass it as a parameter
- Default value: `NetworkService.shared`
- Why? For testing! We can inject a fake network service

```swift
networkService.fetch(url: url)
    .sink(receiveCompletion: { [weak self] completion in
        // Handle completion
    }, receiveValue: { [weak self] (movies: [Movie]) in
        // Handle data
    })
    .store(in: &cancellables)
```

**What is `sink`?**
- Subscribes to the publisher (starts the network request)
- `receiveCompletion`: Called when request finishes (success or error)
- `receiveValue`: Called when we receive data

**What is `[weak self]`?**
- Prevents **memory leaks** (retain cycles)
- Without it, the closure would keep the ViewModel alive forever
- `weak` means "if the ViewModel is destroyed, don't keep it alive"

---

### 4️⃣ **HomeView.swift** (The UI)

```swift
@StateObject private var viewModel = HomeViewModel()
```

**What is `@StateObject`?**
- Creates and owns a ViewModel
- SwiftUI keeps it alive for the view's lifetime
- Only use `@StateObject` for the "owner" of the object

**What's the difference between `@State`, `@StateObject`, and `@ObservedObject`?**
- `@State`: For simple values (Int, String, Bool)
- `@StateObject`: For creating and owning an ObservableObject
- `@ObservedObject`: For observing an ObservableObject created elsewhere

```swift
if viewModel.isLoading {
    // Show loading spinner
} else if let error = viewModel.errorMessage {
    // Show error
} else {
    // Show movies
}
```

**What is `if let`?**
- **Optional binding**
- `errorMessage` is optional (`String?`)
- `if let error = viewModel.errorMessage` unwraps it safely

---

### 5️⃣ **AsyncImage** (Loading Images from URLs)

```swift
AsyncImage(url: URL(string: movie.fullPosterURL)) { phase in
    switch phase {
    case .empty:
        // Loading...
    case .success(let image):
        // Image loaded!
    case .failure:
        // Failed to load
    }
}
```

**What is `AsyncImage`?**
- SwiftUI's built-in component for loading images from URLs
- Automatically handles:
  - Loading state
  - Caching
  - Error handling

**What is `phase`?**
- An enum representing the current state
- `.empty`: Still loading
- `.success(let image)`: Image loaded successfully
- `.failure`: Failed to load

---

## Backend Connection

### Step 1: Update the Base URL

In `Movie.swift`, replace `YOUR_BACKEND_URL:PORT`:

```swift
var fullPosterURL: String {
    return "http://192.168.1.100:3000/\(posterUrl)"
    // Example: "http://192.168.1.100:3000/uploads/movies/poster-123.jpg"
}
```

### Step 2: Update the API Endpoint

In `HomeViewModel.swift`, replace the URL:

```swift
guard let url = URL(string: "http://192.168.1.100:3000/api/movies") else {
    self.errorMessage = "Invalid URL"
    return
}
```

### Step 3: Test the Connection

1. Make sure your backend is running
2. Run the iOS app
3. Check the console for:
   - ✅ `Successfully fetched X movies`
   - ❌ `Error fetching movies: ...`

---

## Key iOS Concepts Used

### 1. **Combine Framework**
- Apple's reactive programming framework
- Handles asynchronous events (networking, user input, timers)
- Key components:
  - **Publisher**: Emits values over time
  - **Subscriber**: Receives values
  - **Operators**: Transform values (map, filter, etc.)

### 2. **Codable**
- Automatic JSON encoding/decoding
- No need for manual parsing
- Just define your struct and Swift does the rest

### 3. **Property Wrappers**
- `@Published`: Auto-notifies observers
- `@StateObject`: Owns an ObservableObject
- `@State`: Manages local state

### 4. **Protocols**
- Define requirements for types
- Enable polymorphism and dependency injection
- Make code testable

### 5. **Generics**
- Write reusable code for different types
- `func fetch<T>` works for any decodable type

### 6. **Memory Management**
- `[weak self]`: Prevents retain cycles
- `Set<AnyCancellable>`: Keeps subscriptions alive

---

## 🎯 Summary

**Data Flow:**
1. **View** loads → creates **ViewModel**
2. **ViewModel** calls **NetworkService**
3. **NetworkService** fetches data from backend
4. Data is decoded into **Movie** objects
5. **ViewModel** updates `@Published` properties
6. **View** automatically re-renders with new data

**Key Takeaways:**
- **Model**: Data structure (what)
- **View**: UI (how it looks)
- **ViewModel**: Logic (how it works)
- **Combine**: Handles async operations
- **Codable**: Handles JSON parsing

---

## 📖 Next Steps

1. Add more properties to `Movie` (duration, rating, etc.)
2. Implement search functionality
3. Add pagination for large lists
4. Implement caching to reduce network calls
5. Add unit tests for ViewModels

---

**Happy Coding! 🚀**
