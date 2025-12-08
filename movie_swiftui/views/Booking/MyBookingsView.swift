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
            return movieDetails
        }
        // Otherwise try to find it in homeViewModel by ID
        return homeViewModel.movies.first { $0.id == booking.movieId }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Movie Poster
            if let movie = movie {
                AsyncImage(url: URL(string: movie.posterUrl)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    default:
                        Rectangle().fill(Color.gray.opacity(0.3))
                    }
                }
                .frame(width: 80, height: 120)
                .cornerRadius(12)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 80, height: 120)
                    .cornerRadius(12)
                    .overlay(Image(systemName: "film").foregroundColor(.white))
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(movie?.title ?? "Unknown Movie")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.green)
                        .font(.system(size: 14))
                    Text(booking.date)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.green)
                        .font(.system(size: 14))
                    Text(booking.time)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.green)
                        .font(.system(size: 14))
                    Text(booking.location)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Text("\(booking.seats.count) Seats: \(booking.seats.joined(separator: ", "))")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.6))
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
