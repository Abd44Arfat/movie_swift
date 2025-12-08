import SwiftUI

struct MyBookingsView: View {
    @EnvironmentObject var bookingManager: BookingManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Text("My Bookings")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Color.clear.frame(width: 40, height: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)
                .padding(.bottom, 20)
                
                if bookingManager.isLoading {
                    VStack {
                        Spacer()
                        ProgressView()
                            .tint(.white)
                            .scaleEffect(1.5)
                        Spacer()
                    }
                } else if bookingManager.bookings.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        Image(systemName: "ticket")
                            .font(.system(size: 80))
                            .foregroundColor(.white.opacity(0.3))
                        
                        Text("No bookings yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Text("Book your favorite movies to see them here")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.6))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        Spacer()
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(bookingManager.bookings) { booking in
                                BookingCard(booking: booking)
                            }
                        }
                        .padding(20)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            bookingManager.fetchBookings()
        }
    }
}

struct BookingCard: View {
    let booking: Booking
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    // Helper to find movie details
    var movie: Movie? {
        // First check if we have the full movie details from the booking
        if let movieDetails = booking.movieDetails {
            print("📽️ Using movie details from booking: \(movieDetails.title)")
            return movieDetails
        }
        // Otherwise try to find it in homeViewModel by ID
        let foundMovie = homeViewModel.movies.first { $0.id == booking.movieId }
        if let foundMovie = foundMovie {
            print("📽️ Found movie in homeViewModel: \(foundMovie.title)")
        } else {
            print("⚠️ Movie not found. Booking movieId: \(booking.movieId), Available movies: \(homeViewModel.movies.map { $0.id })")
        }
        return foundMovie
    }
    
    // Format date to readable format
    var formattedDate: String {
        // Try ISO8601 format first
        let isoFormatter = ISO8601DateFormatter()
        if let date = isoFormatter.date(from: booking.date) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd, yyyy"
            return formatter.string(from: date)
        }
        
        // Try other common formats
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: booking.date) {
            dateFormatter.dateFormat = "MMM dd, yyyy"
            return dateFormatter.string(from: date)
        }
        
        // If all else fails, try to extract just the date part
        if booking.date.contains("T") {
            let components = booking.date.split(separator: "T")
            if let dateString = components.first {
                let parts = dateString.split(separator: "-")
                if parts.count == 3 {
                    return "\(parts[2]) \(parts[1]) \(parts[0])"
                }
            }
        }
        
        return booking.date
    }
    
    // Format time to readable format
    var formattedTime: String {
        // If time is already in readable format, return it
        if booking.time.contains("PM") || booking.time.contains("AM") {
            return booking.time
        }
        
        // Try to parse 24-hour format
        let components = booking.time.split(separator: ":")
        if components.count >= 2, let hour = Int(components[0]), let minute = Int(components[1]) {
            let period = hour >= 12 ? "PM" : "AM"
            let displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour)
            return String(format: "%d:%02d %@", displayHour, minute, period)
        }
        
        return booking.time
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Movie Poster
            ZStack {
                if let movie = movie {
                    let _ = print("🖼️ Loading image from: \(movie.posterUrl)")
                    AsyncImage(url: URL(string: movie.posterUrl)) { phase in
                        switch phase {
                        case .empty:
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .overlay(
                                    VStack {
                                        ProgressView()
                                            .tint(.white)
                                        Text("Loading...")
                                            .font(.caption2)
                                            .foregroundColor(.white)
                                    }
                                )
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 90, height: 130)
                                .clipped()
                        case .failure(let error):
                            let _ = print("❌ Image load failed: \(error)")
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .overlay(
                                    VStack(spacing: 4) {
                                        Image(systemName: "photo")
                                            .foregroundColor(.white.opacity(0.5))
                                        Text("Failed")
                                            .font(.caption2)
                                            .foregroundColor(.white.opacity(0.5))
                                    }
                                )
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            VStack(spacing: 4) {
                                Image(systemName: "film")
                                    .font(.largeTitle)
                                    .foregroundColor(.white.opacity(0.5))
                                Text("No Movie")
                                    .font(.caption2)
                                    .foregroundColor(.white.opacity(0.5))
                            }
                        )
                }
            }
            .frame(width: 90, height: 130)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(movie?.title ?? "Unknown Movie")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .foregroundColor(.green)
                        .font(.system(size: 13))
                    Text(formattedDate)
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .foregroundColor(.green)
                        .font(.system(size: 13))
                    Text(formattedTime)
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.8))
                }
                
    
                
                HStack(spacing: 4) {
                    Image(systemName: "ticket.fill")
                        .foregroundColor(.green)
                        .font(.system(size: 13))
                    Text("\(booking.seats.count) Seats: \(booking.seats.joined(separator: ", "))")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.6))
                        .lineLimit(1)
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "banknote.fill")
                        .foregroundColor(.green)
                        .font(.system(size: 13))
                    Text("\(String(format: "%.2f", booking.totalPrice)) EGP")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.green)
                }
            }
            
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}
