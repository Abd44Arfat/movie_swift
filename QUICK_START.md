# Quick Start Guide

Get up and running with the Movie Booking iOS app in 5 minutes!

## Prerequisites Checklist

- [ ] Xcode 15.0+ installed
- [ ] macOS Monterey or later
- [ ] Backend API running (see [Backend Setup](#backend-setup))
- [ ] iOS Simulator or physical device

## 5-Minute Setup

### Step 1: Clone the Repository (30 seconds)

```bash
git clone https://github.com/yourusername/movie_swiftui.git
cd movie_swiftui
```

### Step 2: Configure API URL (1 minute)

Open `movie_swiftui/Utilities/Constants.swift` and update the base URL:

**For iOS Simulator:**
```swift
static let baseURL = "http://localhost:3000"
```

**For Physical Device:**
```swift
static let baseURL = "http://YOUR_MAC_IP:3000"
```

To find your Mac's IP:
```bash
ipconfig getifaddr en0
```

### Step 3: Open in Xcode (30 seconds)

```bash
open movie_swiftui.xcodeproj
```

### Step 4: Build and Run (3 minutes)

1. Select your target device/simulator
2. Press `⌘R` or click the Play button
3. Wait for the build to complete
4. The app will launch automatically

## Backend Setup

You need a running backend API. Clone and run the backend:

```bash
git clone https://github.com/yourusername/movie-booking-backend.git
cd movie-booking-backend
npm install
npm run dev
```

The backend should be running on `http://localhost:3000`.

## First Run

### Create an Account

1. Launch the app
2. Tap "Sign Up"
3. Enter your details:
   - Full Name
   - Email
   - Password
   - Confirm Password
4. Accept Terms & Conditions
5. Tap "Create Account"

### Browse Movies

1. The home screen shows featured movies in a carousel
2. Scroll down to see popular movies
3. Use the search bar to find specific movies
4. Filter by category (Action, Comedy, Drama, etc.)

### Book a Movie

1. Tap on any movie card
2. Select a date
3. Choose a showtime
4. Pick your seats on the interactive seat map
5. Review booking details
6. Tap "Confirm Booking"
7. View your booking confirmation

### View Your Bookings

1. Tap the "Bookings" tab at the bottom
2. See all your past and upcoming bookings
3. Each booking shows:
   - Movie poster
   - Date and time
   - Selected seats
   - Total price

## Troubleshooting

### Build Errors

**Error: "Cannot find module"**
- Clean build folder: `⌘⇧K`
- Rebuild: `⌘B`

**Error: "Signing requires a development team"**
- Select your Apple ID in Xcode > Preferences > Accounts
- Or use automatic signing

### Runtime Errors

**Error: "Network request failed"**
- Verify backend is running
- Check API base URL in Constants.swift
- Ensure Mac and device are on same WiFi

**Error: "Failed to load images"**
- Check image URLs in backend
- Verify uploads directory exists
- Ensure proper URL formatting

**Error: "Authentication failed"**
- Clear app data and try again
- Check backend authentication endpoint
- Verify token storage

### Connection Issues

**Simulator can't connect to localhost:**
- Use `http://localhost:3000` for simulator
- Backend must be running on your Mac

**Physical device can't connect:**
- Use your Mac's IP address instead of localhost
- Both devices must be on same WiFi network
- Check firewall settings

## Next Steps

### Explore Features

- ✅ Add movies to wishlist
- ✅ Search for specific movies
- ✅ Filter by genre
- ✅ View booking history
- ✅ Manage your profile

### Customize

1. **Change Theme Colors**: Edit color values in view files
2. **Add New Categories**: Update CategoryFilterView
3. **Modify Seat Layout**: Update SeatSelectionView
4. **Add Features**: Follow MVVM architecture

### Learn More

- 📖 [README](README.md) - Full documentation
- 🏗️ [Architecture Guide](MVVM_ARCHITECTURE_GUIDE.md) - MVVM patterns
- 🔧 [Setup Guide](SETUP_GUIDE.md) - Detailed setup
- 📡 [API Documentation](API_DOCUMENTATION.md) - API reference
- 🤝 [Contributing](CONTRIBUTING.md) - Contribution guidelines

## Common Tasks

### Reset App Data

```bash
# Delete app from simulator/device
# Or clear UserDefaults in code:
UserDefaults.standard.removeObject(forKey: "auth_token")
```

### Update Dependencies

This project uses native SwiftUI and Combine - no external dependencies!

### Run on Physical Device

1. Connect your iPhone via USB
2. Trust the computer on your iPhone
3. Select your device in Xcode
4. Update Constants.swift with your Mac's IP
5. Build and run

## Support

Need help? Check these resources:

1. **Documentation**: Read the full [README](README.md)
2. **Issues**: Search [existing issues](https://github.com/yourusername/movie_swiftui/issues)
3. **Questions**: Open a new issue with the "question" label

## What's Next?

Now that you're up and running:

1. ⭐ Star the repository
2. 🍴 Fork it for your own projects
3. 🐛 Report bugs or suggest features
4. 🤝 Contribute improvements

Happy coding! 🎬🍿
