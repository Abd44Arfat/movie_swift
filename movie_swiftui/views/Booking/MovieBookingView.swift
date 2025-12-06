import SwiftUI

struct MovieData: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let duration: String
    let rating: String
}

struct MovieBookingView: View {
    let movieTitle: String
    let movieImage: String
    let duration: String
    let rating: String
    var initialMovieIndex: Int = 0
    
    @State private var selectedMovieIndex: Int = 0
    @State private var selectedDate: Int = 1
    @State private var selectedTime: String = "8:30 PM"
    @State private var showSeatSelection = false
    @Environment(\.dismiss) var dismiss
    
    let movies = [
        MovieData(title: "Inside Out 2", imageName: "home_image_trailer", duration: "1HR 36 MIN", rating: "PG"),
        MovieData(title: "Garfield", imageName: "garfield", duration: "1HR 40 MIN", rating: "PG"),
        MovieData(title: "Movie 3", imageName: "movie3", duration: "2HR 15 MIN", rating: "PG-13")
    ]
    
    let dates = [
        (day: "Mo", date: 10),
        (day: "Tu", date: 11),
        (day: "We", date: 12),
        (day: "Th", date: 13),
        (day: "Fr", date: 14),
        (day: "Sa", date: 15)
    ]
    
    let times = ["4:00 PM", "5:30 PM", "7:00 PM", "8:30 PM", "9:00 PM"]
    
    var currentMovie: MovieData {
        movies[selectedMovieIndex]
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with safe area respect
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 44, height: 44)
                            .overlay(
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                            )
                    }
                    
                    Spacer()
                   
                 
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 16)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Movie Info
                        VStack(spacing: 12) {
                            Text(currentMovie.title)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedMovieIndex)
                            
                            HStack(spacing: 8) {
                                Image(systemName: "clock")
                                    .font(.system(size: 14))
                                Text(currentMovie.duration)
                                Text("|")
                                Text(currentMovie.rating)
                            }
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.7))
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedMovieIndex)
                        }
                        
                        // Movie Carousel - 3 films showing
                        ScrollViewReader { proxy in
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach(movies.indices, id: \.self) { index in
                                        MoviePosterCard(
                                            movie: movies[index],
                                            isSelected: selectedMovieIndex == index,
                                            onTap: {
                                                withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                                                    selectedMovieIndex = index
                                                }
                                            }
                                        )
                                        .id(index)
                                    }
                                }
                                .padding(.horizontal, 60)
                            }
                            .onChange(of: selectedMovieIndex) { oldValue, newValue in
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                                    proxy.scrollTo(newValue, anchor: .center)
                                }
                            }
                            .onAppear {
                                proxy.scrollTo(selectedMovieIndex, anchor: .center)
                            }
                        }
                        .frame(height: 400)
                        
                        // Date Selection
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Select the date")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(dates.indices, id: \.self) { index in
                                        DateButton(
                                            day: dates[index].day,
                                            date: dates[index].date,
                                            isSelected: selectedDate == index,
                                            action: {
                                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                    selectedDate = index
                                                }
                                            }
                                        )
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        // Time Selection
                        VStack(alignment: .leading, spacing: 16) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(times, id: \.self) { time in
                                        TimeButton(
                                            time: time,
                                            isSelected: selectedTime == time,
                                            action: {
                                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                    selectedTime = time
                                                }
                                            }
                                        )
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        // Continue Button
                        Button {
                            showSeatSelection = true
                        } label: {
                            Text("Go to select seats")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(Color.blue)
                                        .shadow(color: .blue.opacity(0.4), radius: 20, x: 0, y: 10)
                                )
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            selectedMovieIndex = initialMovieIndex
        }
        .fullScreenCover(isPresented: $showSeatSelection) {
            SeatSelectionView(
                movieTitle: currentMovie.title,
                movieImage: currentMovie.imageName,
                duration: currentMovie.duration,
                rating: currentMovie.rating,
                selectedDate: "Friday, 23th June 2024",
                selectedTime: selectedTime,
                location: "Miami, Aventura 24"
            )
        }
    }
}

struct MoviePosterCard: View {
    let movie: MovieData
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Image(movie.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: isSelected ? 280 : 240, height: isSelected ? 380 : 340)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(isSelected ? Color.green : Color.clear, lineWidth: 3)
                )
                .shadow(
                    color: isSelected ? Color.green.opacity(0.4) : Color.black.opacity(0.5),
                    radius: isSelected ? 25 : 30,
                    x: 0,
                    y: 15
                )
                .scaleEffect(isSelected ? 1.0 : 0.9)
                .opacity(isSelected ? 1.0 : 0.6)
                .animation(.spring(response: 0.4, dampingFraction: 0.75), value: isSelected)
        }
    }
}

struct DateButton: View {
    let day: String
    let date: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(day)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(isSelected ? .white : .white.opacity(0.5))
                
                Text("\(date)")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(isSelected ? .white : .white.opacity(0.5))
            }
            .frame(width: 70, height: 80)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? Color.white.opacity(0.2) : Color.white.opacity(0.05))
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
        }
    }
}

struct TimeButton: View {
    let time: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(time)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(isSelected ? .white : .white.opacity(0.5))
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.white.opacity(0.2) : Color.white.opacity(0.05))
                )
                .scaleEffect(isSelected ? 1.05 : 1.0)
        }
    }
}

#Preview {
    MovieBookingView(
        movieTitle: "Inside Out 2",
        movieImage: "home_image_trailer",
        duration: "1HR 36 MIN",
        rating: "PG"
    )
}
