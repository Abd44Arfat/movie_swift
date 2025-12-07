# 🚀 Quick Setup Guide - Connect to Your Backend

## ✅ What's Already Done

Your app is now configured to fetch movies from your backend! Here's what's set up:

### 1. **Backend Response Structure** ✅
Your backend returns:
```json
[
    {
        "_id": "6934505315df0089b1dc9e41",
        "title": "LUCA 2021",
        "posterUrl": "http://localhost:3000/uploads/movies/poster-1765036115841-892239007.jpg",
        "genre": []
    }
]
```

### 2. **Model Mapping** ✅
- `_id` → `id` (String)
- `title` → `title` (String)
- `posterUrl` → `posterUrl` (String) - Full URL, ready to use!
- `genre` → `genre` ([String])

### 3. **API Endpoint** ✅
- **URL**: `http://localhost:3000/api/movies`
- **Method**: GET
- **Response**: Array of movies (not wrapped in an object)

---

## 🔧 Configuration

### For iOS Simulator (Default - Already Set)
```swift
// In Constants.swift
static let baseURL = "http://localhost:3000"
```
✅ **This works if your backend is running on the same Mac**

### For Real iPhone/iPad Device
If testing on a physical device, update `Constants.swift`:

```swift
// Replace localhost with your Mac's IP address
static let baseURL = "http://192.168.1.XXX:3000"
```

**How to find your Mac's IP:**
1. Open **System Settings** → **Network**
2. Select your active connection (Wi-Fi or Ethernet)
3. Look for "IP Address" (e.g., `192.168.1.100`)

---

## 🎬 How It Works

### Data Flow:
```
1. HomeView loads
   ↓
2. HomeViewModel.init() is called
   ↓
3. fetchMovies() is triggered automatically
   ↓
4. NetworkService makes GET request to:
   http://localhost:3000/api/movies
   ↓
5. Backend returns JSON array
   ↓
6. Codable automatically converts JSON → [Movie]
   ↓
7. @Published var movies is updated
   ↓
8. SwiftUI automatically re-renders the view
   ↓
9. AsyncImage loads poster images from URLs
```

---

## 🧪 Testing

### 1. Start Your Backend
```bash
# Make sure your Node.js backend is running
npm start
# or
node server.js
```

### 2. Run the iOS App
- Press **⌘ + R** in Xcode
- Or click the ▶️ Play button

### 3. Check Console Output
Look for these messages in Xcode console:

**✅ Success:**
```
✅ Successfully fetched 2 movies
```

**❌ Error:**
```
❌ Error fetching movies: The request failed
```

---

## 🐛 Troubleshooting

### Problem: "Invalid URL" Error
**Solution:** Check `Constants.swift` - make sure the URL is correct

### Problem: "Request Failed" Error
**Possible Causes:**
1. Backend is not running
2. Wrong port number (should be 3000)
3. Wrong endpoint (should be `/api/movies`)

**Solution:**
- Test your backend in browser: `http://localhost:3000/api/movies`
- Should return JSON array

### Problem: Images Not Loading
**Possible Causes:**
1. `posterUrl` in backend response is incorrect
2. Image files don't exist on server

**Solution:**
- Check that `posterUrl` is a full, valid URL
- Test image URL in browser

### Problem: App Works in Simulator but Not on Real Device
**Cause:** Real devices can't access `localhost`

**Solution:**
1. Find your Mac's IP address (e.g., `192.168.1.100`)
2. Update `Constants.swift`:
   ```swift
   static let baseURL = "http://192.168.1.100:3000"
   ```
3. Make sure your iPhone and Mac are on the **same Wi-Fi network**

---

## 📱 What You'll See

### Loading State
- Spinner with "Loading Movies..."

### Success State
- **Header Carousel**: Auto-scrolling movie posters
- **Popular Movies**: Horizontal scrollable list

### Error State
- Error icon and message
- "Retry" button to try again

---

## 🔄 Adding More Data

If you want to add more fields (duration, rating, etc.), update your backend first, then:

### 1. Update the Model
```swift
// In Movie.swift
struct Movie: Identifiable, Codable {
    let id: String
    let title: String
    let posterUrl: String
    let genre: [String]
    let duration: String?    // ← Add new field
    let rating: String?      // ← Add new field
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case posterUrl
        case genre
        case duration        // ← Add mapping
        case rating          // ← Add mapping
    }
}
```

### 2. Update the UI
```swift
// In HomeView.swift
MovieBookingView(
    movieTitle: selectedMovie.title,
    movieImage: selectedMovie.posterUrl,
    duration: selectedMovie.duration ?? "N/A",  // ← Use real data
    rating: selectedMovie.rating ?? "N/A",      // ← Use real data
    initialMovieIndex: selectedMovieIndex
)
```

---

## 🎯 Next Steps

1. ✅ Make sure backend is running
2. ✅ Run the app and test
3. ✅ Check console for success/error messages
4. ✅ If on real device, update IP address in Constants.swift

**You're all set! 🎉**
