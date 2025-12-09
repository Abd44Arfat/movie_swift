# Contributing to Movie Booking App

Thank you for your interest in contributing to the Movie Booking iOS app! This document provides guidelines and instructions for contributing.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Project Structure](#project-structure)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Testing](#testing)
- [Documentation](#documentation)

## Code of Conduct

This project adheres to a code of conduct that all contributors are expected to follow. Please be respectful and constructive in all interactions.

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/yourusername/movie_swiftui.git`
3. Create a feature branch: `git checkout -b feature/your-feature-name`
4. Make your changes
5. Test thoroughly
6. Commit your changes
7. Push to your fork
8. Submit a pull request

## Development Setup

### Prerequisites

- Xcode 15.0 or later
- iOS 15.0 or later
- macOS Monterey or later
- Running backend API instance

### Setup Steps

1. Open `movie_swiftui.xcodeproj` in Xcode
2. Configure the API base URL in `Utilities/Constants.swift`
3. Build and run the project (⌘R)

## Project Structure

```
movie_swiftui/
├── Models/              # Data models
├── Views/               # SwiftUI views
│   ├── Auth/           # Authentication views
│   ├── Home/           # Home screen components
│   ├── Booking/        # Booking flow views
│   ├── Wishlist/       # Favorites
│   └── Components/     # Reusable components
├── ViewModels/         # Business logic
├── Services/           # API and data services
└── Utilities/          # Helper classes
```

## Coding Standards

### Swift Style Guide

Follow the [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/).

### Key Principles

1. **MVVM Architecture**: Maintain separation between Views, ViewModels, and Models
2. **Protocol-Oriented**: Use protocols for abstraction and testability
3. **Reactive Programming**: Use Combine for data flow
4. **Type Safety**: Leverage Swift's type system
5. **Clean Code**: Write self-documenting code with clear naming

### Naming Conventions

- **Types**: Use PascalCase (e.g., `MovieViewModel`, `NetworkService`)
- **Variables/Functions**: Use camelCase (e.g., `fetchMovies`, `isLoading`)
- **Constants**: Use camelCase (e.g., `baseURL`, `apiKey`)
- **Protocols**: Use descriptive names ending with "Protocol" or describing capability (e.g., `NetworkServiceProtocol`, `Identifiable`)

### Code Organization

```swift
// MARK: - Properties
// Group related properties

// MARK: - Initialization
// Initializers

// MARK: - Public Methods
// Public interface

// MARK: - Private Methods
// Private implementation

// MARK: - Helper Methods
// Utility functions
```

### SwiftUI Best Practices

1. **Extract Subviews**: Keep view bodies concise by extracting complex views
2. **Use @State Properly**: Only for view-local state
3. **Use @StateObject**: For view model lifecycle management
4. **Use @EnvironmentObject**: For shared state across views
5. **Avoid Force Unwrapping**: Use optional binding or provide defaults

### Example

```swift
import SwiftUI

struct MovieCardView: View {
    let movie: Movie
    @EnvironmentObject var favoritesManager: FavoritesManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            posterImage
            movieInfo
        }
        .background(cardBackground)
    }
    
    private var posterImage: some View {
        AsyncImage(url: URL(string: movie.posterUrl)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            ProgressView()
        }
        .frame(height: 200)
        .clipped()
    }
    
    private var movieInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(movie.title)
                .font(.headline)
                .foregroundColor(.white)
            
            if let rating = movie.rating {
                Text("⭐ \(String(format: "%.1f", rating))")
                    .font(.caption)
                    .foregroundColor(.yellow)
            }
        }
        .padding(.horizontal, 12)
        .padding(.bottom, 12)
    }
    
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(.ultraThinMaterial)
            .shadow(radius: 8)
    }
}
```

## Commit Guidelines

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code style changes (formatting, etc.)
- **refactor**: Code refactoring
- **test**: Adding or updating tests
- **chore**: Maintenance tasks

### Examples

```
feat(booking): add seat selection functionality

Implemented interactive seat map with real-time availability checking.
Users can now select multiple seats and see visual feedback.

Closes #123
```

```
fix(auth): resolve token expiration handling

Fixed issue where expired tokens weren't properly refreshed,
causing authentication failures.

Fixes #456
```

## Pull Request Process

1. **Update Documentation**: Ensure README and other docs reflect your changes
2. **Add Tests**: Include unit tests for new functionality
3. **Update CHANGELOG**: Add your changes to the Unreleased section
4. **Code Review**: Request review from maintainers
5. **Address Feedback**: Make requested changes promptly
6. **Squash Commits**: Clean up commit history before merging

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
How has this been tested?

## Screenshots (if applicable)
Add screenshots for UI changes

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] No new warnings generated
- [ ] Tests added/updated
- [ ] All tests passing
```

## Testing

### Unit Tests

Write unit tests for:
- ViewModels
- Services
- Utilities
- Data models

### UI Tests

Add UI tests for:
- Critical user flows
- Authentication
- Booking process
- Navigation

### Manual Testing

Test on:
- iOS Simulator
- Physical devices
- Different screen sizes
- Different iOS versions

## Documentation

### Code Documentation

Use Swift documentation comments for public APIs:

```swift
/// Fetches all available movies from the backend
/// - Returns: A publisher that emits an array of movies or an error
func fetchMovies() -> AnyPublisher<[Movie], APIError> {
    // Implementation
}
```

### README Updates

Update the README when:
- Adding new features
- Changing setup process
- Updating dependencies
- Modifying architecture

### Architecture Documentation

Update architecture guides when:
- Introducing new patterns
- Changing data flow
- Adding new layers
- Modifying dependencies

## Questions?

If you have questions or need help:
1. Check existing documentation
2. Search existing issues
3. Open a new issue with the "question" label

## Recognition

Contributors will be recognized in:
- README acknowledgments
- Release notes
- Project documentation

Thank you for contributing! 🎉
