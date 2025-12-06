# Quick Component Reference

## 🎬 Movie Booking Flow Components

### 1. Date Selection Components

#### DateButton
```swift
DateButton(
    day: "Tu",           // Day abbreviation
    date: 11,            // Date number
    isSelected: true,    // Selection state
    action: { }          // Tap handler
)
```

**Features:**
- Rounded rectangle container
- Day + date display
- Selected state highlighting
- Scale animation (1.05x when selected)
- Background opacity changes

---

### 2. Time Selection Components

#### TimeButton
```swift
TimeButton(
    time: "8:30 PM",     // Time string
    isSelected: true,    // Selection state
    action: { }          // Tap handler
)
```

**Features:**
- Capsule-shaped button
- Selected state highlighting
- Scale animation
- Opacity changes

---

### 3. Seat Selection Components

#### Seat Model
```swift
struct Seat: Identifiable {
    let id = UUID()
    let row: String      // "A" to "I"
    let number: Int      // 1 to 12
    var status: SeatStatus
}

enum SeatStatus {
    case available       // Blue
    case notAvailable    // Gray
    case selected        // Green
}
```

#### SeatView
```swift
SeatView(
    seat: Seat(...),     // Seat data
    onTap: { }           // Selection handler
)
```

**Features:**
- 24×24 rounded square
- Color-coded by status
- Seat number display
- Scale animation on selection
- Disabled for unavailable seats

#### LegendItem
```swift
LegendItem(
    color: .blue,
    label: "Available"
)
```

#### SummaryRow
```swift
SummaryRow(
    label: "Date",
    value: "Friday, 23th June 2024"
)
```

---

## 🏠 Home Screen Components

### HeaderCarouselView
**Auto-scrolling hero carousel**
- 4-second intervals
- Page indicators (capsule style)
- Play trailer button
- Gradient overlay
- Spring animations

### SearchBarView
**Interactive search input**
- Focus state animations
- Clear button (appears with text)
- Glassmorphism effect
- Border highlight on focus

### CategoryFilterView
**Horizontal category pills**
- Scrollable
- Selected state
- Glow effect on selection
- Scale animation

### MovieCardView
**Movie poster card**
- 150×220 size
- Rounded corners (16px)
- Press animation
- Shadow effects
- Tap callback

### PopularMoviesSection
**Movie grid section**
- Section header
- "See All" button
- Horizontal scroll
- Movie cards

---

## 📱 Tab Navigation

### MainTabView
**Root navigation container**
- 4 tabs with icons + labels
- State management
- Smooth transitions
- Active indicators

### TabBarButton
**Individual tab button**
- Icon + label
- Selected state (green)
- Scale animations
- Active dot indicator

---

## 🎨 Reusable Patterns

### Button Press Animation
```swift
@State private var isPressed = false

Button {
    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
        isPressed = true
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            isPressed = false
        }
    }
} label: {
    // Content
}
.scaleEffect(isPressed ? 0.95 : 1.0)
```

### Glassmorphism Background
```swift
.background(
    RoundedRectangle(cornerRadius: 25)
        .fill(Color.white.opacity(0.1))
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
)
```

### Shadow Effect
```swift
.shadow(
    color: .black.opacity(0.4),
    radius: 15,
    x: 0,
    y: 8
)
```

### Spring Animation
```swift
.animation(
    .spring(response: 0.3, dampingFraction: 0.7),
    value: stateVariable
)
```

---

## 📐 Layout Patterns

### Full-Width Button
```swift
Button { } label: {
    Text("Continue")
        .font(.system(size: 18, weight: .semibold))
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.blue)
        )
}
.padding(.horizontal, 20)
```

### Section Header
```swift
HStack {
    Text("Section Title")
        .font(.title2)
        .bold()
        .foregroundColor(.white)
    
    Spacer()
    
    Button { } label: {
        HStack {
            Text("See All")
            Image(systemName: "chevron.right")
        }
        .foregroundColor(.white.opacity(0.7))
    }
}
.padding(.horizontal, 20)
```

### Horizontal Scroll Grid
```swift
ScrollView(.horizontal, showsIndicators: false) {
    HStack(spacing: 16) {
        ForEach(items) { item in
            ItemView(item: item)
        }
    }
    .padding(.horizontal, 20)
}
```

---

## 🔧 State Management

### Navigation State
```swift
@State private var showBooking = false

// Trigger
.fullScreenCover(isPresented: $showBooking) {
    MovieBookingView(...)
}
```

### Selection State
```swift
@State private var selectedIndex = 0

// Update
withAnimation(.spring(...)) {
    selectedIndex = newIndex
}
```

### Focus State
```swift
@FocusState private var isFocused: Bool

TextField("Search...", text: $text)
    .focused($isFocused)
```

---

## 💡 Best Practices

1. **Always use spring animations** for natural feel
2. **Provide visual feedback** for all interactions
3. **Use proper spacing** (12-20px between elements)
4. **Maintain consistent corner radius** (16-30px)
5. **Add shadows** for depth (radius: 10-20, opacity: 0.2-0.4)
6. **Use opacity** for secondary text (0.5-0.7)
7. **Scale effects** for press states (0.95-1.1x)
8. **Combine transitions** (.scale + .opacity)

---

**Quick Reference for Clean, Animated SwiftUI Components**
