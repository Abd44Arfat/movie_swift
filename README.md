# 🎬 Movie Booking App - SwiftUI

A modern, feature-rich iOS movie booking application built with SwiftUI and following the MVVM architecture pattern. This app allows users to browse movies, book tickets, select seats, and manage their bookings with a beautiful, glassmorphic UI design.

![Platform](https://img.shields.io/badge/platform-iOS%2015.0%2B-blue)
![Swift](https://img.shields.io/badge/Swift-5.9-orange)
![SwiftUI](https://img.shields.io/badge/SwiftUI-3.0-green)
![Architecture](https://img.shields.io/badge/Architecture-MVVM-purple)

## ✨ Features

### 🎥 Movie Browsing
- **Dynamic Movie Carousel**: Swipeable header carousel showcasing featured movies
- **Popular Movies Grid**: Browse through a collection of popular movies
- **Search Functionality**: Search movies by title with real-time filtering
- **Category Filters**: Filter movies by genre (Action, Comedy, Drama, Horror, Sci-Fi)
- **Movie Details**: View detailed information including rating, duration, genre, and description

### 🎫 Booking System
- **Seat Selection**: Interactive seat map with visual seat status (available, selected, booked)
- **Date Selection**: Choose from available showtimes
- **Real-time Availability**: Check seat availability before booking
- **Booking Confirmation**: Instant booking confirmation with QR code
- **My Bookings**: View all your past and upcoming bookings

### 👤 User Management
- **Authentication**: Secure login and signup with JWT tokens
- **User Profile**: Manage your account information
- **Wishlist**: Save your favorite movies for later
- **Persistent Sessions**: Stay logged in across app launches

### 🎨 UI/UX
- **Glassmorphic Design**: Modern, premium UI with glass effects
- **Dark Theme**: Eye-friendly dark mode throughout the app
- **Smooth Animations**: Fluid transitions and micro-interactions
- **Responsive Layout**: Optimized for all iPhone screen sizes

## 🏗️ Architecture

This project follows the **MVVM (Model-View-ViewModel)** architecture pattern with clean separation of concerns:

```
movie_swiftui/
├── Models/              # Data models (Movie, Booking)
├── Views/               # SwiftUI views
│   ├── Auth/           # Login & SignUp views
│   ├── Home/           # Home screen components
│   ├── Booking/        # Booking flow views
│   ├── Wishlist/       # Favorites management
│   └── Components/     # Reusable UI components
├── ViewModels/         # Business logic layer
├── Services/           # API & data services
└── Utilities/          # Helper classes & constants
```

### Key Components

#### Models
- **Movie**: Represents movie data with all metadata
- **Booking**: Represents user booking information

#### ViewModels
- **HomeViewModel**: Manages movie data fetching and state
- **BookingViewModel**: Handles booking creation and validation

#### Services
- **NetworkService**: Generic network layer with Combine
- **AuthManager**: Authentication and session management
- **BookingManager**: Booking state management
- **FavoritesManager**: Wishlist functionality

## 🚀 Getting Started

### Prerequisites

- **Xcode**: 15.0 or later
- **iOS**: 15.0 or later
- **macOS**: Monterey or later
- **Backend API**: Running instance of the movie booking backend

### Backend Setup

This app requires a backend API. You can find the backend repository here:
[Movie Booking Backend](https://github.com/yourusername/movie-booking-backend)

The backend provides the following endpoints:
- `GET /movies` - Fetch all movies
- `POST /auth/login` - User authentication
- `POST /auth/register` - User registration
- `GET /bookings/available-seats` - Get available seats
- `POST /bookings` - Create a booking
- `GET /bookings/my-bookings` - Fetch user bookings

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/movie_swiftui.git
   cd movie_swiftui
   ```

2. **Configure API Base URL**
   
   Open `movie_swiftui/Utilities/Constants.swift` and update the base URL:
   
   ```swift
   // For iOS Simulator
   static let baseURL = "http://localhost:3000"
   
   // For Physical Device - use your Mac's IP address
   static let baseURL = "http://192.168.1.5:3000"
   ```
   
   To find your Mac's IP address:
   ```bash
   ipconfig getifaddr en0
   ```

3. **Open the project**
   ```bash
   open movie_swiftui.xcodeproj
   ```

4. **Build and Run**
   - Select your target device or simulator
   - Press `Cmd + R` to build and run

## 📱 Usage

### Authentication
1. Launch the app
2. Sign up with email and password or log in if you already have an account
3. The app will automatically save your session

### Browsing Movies
1. Browse featured movies in the header carousel
2. Scroll down to see popular movies
3. Use the search bar to find specific movies
4. Filter by category using the category chips

### Booking a Movie
1. Tap on any movie card
2. Select your preferred date and showtime
3. Choose your seats from the interactive seat map
4. Review your booking details
5. Confirm your booking
6. View your booking confirmation with QR code

### Managing Bookings
1. Navigate to "My Bookings" from the tab bar
2. View all your bookings with details
3. Each booking shows movie poster, date, time, seats, and total price

## 🛠️ Technical Details

### Technologies Used

- **SwiftUI**: Declarative UI framework
- **Combine**: Reactive programming for data flow
- **URLSession**: Network requests
- **Codable**: JSON serialization/deserialization
- **UserDefaults**: Local data persistence
- **AsyncImage**: Asynchronous image loading

### Design Patterns

- **MVVM**: Separation of UI and business logic
- **Singleton**: Shared managers (AuthManager, BookingManager, etc.)
- **Protocol-Oriented**: NetworkServiceProtocol for testability
- **Dependency Injection**: ViewModels receive services via initializers
- **Publisher-Subscriber**: Combine for reactive updates

### Network Layer

The app uses a generic network service that:
- Handles all HTTP methods (GET, POST, PUT, DELETE)
- Automatic JWT token injection
- Comprehensive error handling
- Type-safe responses with Codable
- Combine publishers for reactive programming

### State Management

- **@StateObject**: For view model lifecycle management
- **@EnvironmentObject**: For shared state across views
- **@Published**: For reactive property updates
- **@State**: For local view state

## 📂 Project Structure

```
movie_swiftui/
├── movie_swiftui/
│   ├── Assets.xcassets/          # App assets and images
│   ├── Models/
│   │   ├── Movie.swift           # Movie data model
│   │   └── Booking.swift         # Booking data model
│   ├── Views/
│   │   ├── Auth/
│   │   │   ├── LoginView.swift
│   │   │   └── SignUpView.swift
│   │   ├── Home/
│   │   │   ├── HomeView.swift
│   │   │   ├── HeaderCarouselView.swift
│   │   │   ├── PopularMoviesSection.swift
│   │   │   ├── MovieCardView.swift
│   │   │   ├── SearchBarView.swift
│   │   │   ├── CategoryFilterView.swift
│   │   │   └── MovieSearchView.swift
│   │   ├── Booking/
│   │   │   ├── MovieBookingView.swift
│   │   │   ├── SeatSelectionView.swift
│   │   │   ├── BookingSuccessView.swift
│   │   │   └── MyBookingsView.swift
│   │   ├── Wishlist/
│   │   │   └── WishlistView.swift
│   │   ├── Components/
│   │   │   └── SnackbarView.swift
│   │   ├── MainTabView.swift
│   │   ├── ProfileView.swift
│   │   ├── CategoriesView.swift
│   │   └── SearchView.swift
│   ├── ViewModels/
│   │   ├── HomeViewModel.swift
│   │   └── BookingViewModel.swift
│   ├── Services/
│   │   ├── NetworkService.swift
│   │   ├── AuthManager.swift
│   │   ├── BookingManager.swift
│   │   └── FavoritesManager.swift
│   ├── Utilities/
│   │   ├── Constants.swift
│   │   └── APIError.swift
│   ├── movie_swiftuiApp.swift    # App entry point
│   └── ContentView.swift         # Root view
├── MVVM_ARCHITECTURE_GUIDE.md    # Detailed architecture docs
├── PROJECT_STRUCTURE.md          # Project organization guide
├── COMPONENT_REFERENCE.md        # Component documentation
├── SETUP_GUIDE.md               # Setup instructions
└── README.md                    # This file
```

## 🔐 Security

- **JWT Authentication**: Secure token-based authentication
- **Automatic Token Management**: Tokens are automatically included in requests
- **Secure Storage**: Sensitive data stored in UserDefaults (consider Keychain for production)

## 🐛 Known Issues & Limitations

- Image URLs must be properly configured for physical devices
- Booking history is fetched on app launch (requires authentication)
- No offline mode currently implemented

## 🚧 Future Enhancements

- [ ] Implement Keychain for secure token storage
- [ ] Add payment gateway integration
- [ ] Implement push notifications for booking reminders
- [ ] Add movie trailers and reviews
- [ ] Implement social sharing features
- [ ] Add offline mode with CoreData
- [ ] Implement unit and UI tests
- [ ] Add accessibility features
- [ ] Support for multiple languages

## 📄 License

This project is available for educational and personal use.

## 👨‍💻 Author

**Abdelrahman Arfat**

## 🙏 Acknowledgments

- SwiftUI documentation and community
- MVVM architecture best practices
- Modern iOS design patterns

## 📞 Support

For issues, questions, or contributions, please open an issue on GitHub.

---

**Made with ❤️ using SwiftUI**
