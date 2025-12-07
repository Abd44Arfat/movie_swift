import SwiftUI

struct MovieBookingView: View {
    let movies: [Movie]
    var initialMovieIndex: Int = 0
    
    @State private var selectedMovieIndex: Int = 0
    @State private var selectedDate: Int = 0
    @State private var selectedTime: String = "8:30 PM"
    @State private var showSeatSelection = false
    @Environment(\.dismiss) var dismiss
    
    // Generate dates dynamically starting from today
    var dates: [(day: String, date: Int, fullDate: Date)] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var datesList: [(day: String, date: Int, fullDate: Date)] = []
        
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: today) {
                let formatter = DateFormatter()
                formatter.dateFormat = "EE"
                let day = formatter.string(from: date)
                let dayNumber = calendar.component(.day, from: date)
                datesList.append((day: day, date: dayNumber, fullDate: date))
            }
        }
        return datesList
    }
    
    let times = ["4:00 PM", "5:30 PM", "7:00 PM", "8:30 PM", "9:00 PM"]
    
    var currentMovie: Movie {
        if movies.indices.contains(selectedMovieIndex) {
            return movies[selectedMovieIndex]
        }
        return movies[0]
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
                                Text(currentMovie.duration ?? "N/A")
                                Text("|")
                                Text(String(format: "%.1f", currentMovie.rating ?? 0.0))
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
                                .padding(.horizontal, 20)
                                .padding(.vertical, 50)
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
                        .frame(height: 500)
                        
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
            if dates.indices.contains(selectedDate) {
                let date = dates[selectedDate].fullDate
                // Combine date and time (simplified for now, just using date)
                let isoDate = ISO8601DateFormatter().string(from: date)
                
                SeatSelectionView(
                    movieId: currentMovie.id,
                    movieTitle: currentMovie.title,
                    movieImage: currentMovie.posterUrl,
                    duration: currentMovie.duration ?? "N/A",
                    rating: String(format: "%.1f", currentMovie.rating ?? 0.0),
                    selectedDate: isoDate,
                    selectedTime: selectedTime,
                    location: "Miami, Aventura 24"
                )
            }
        }
    }
}

struct MoviePosterCard: View {
    let movie: Movie
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            AsyncImage(url: URL(string: movie.posterUrl)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: isSelected ? 320 : 260, height: isSelected ? 420 : 360)
                        .background(Color.gray.opacity(0.3))
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: isSelected ? 320 : 260, height: isSelected ? 420 : 360)
                        .clipped()
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: isSelected ? 320 : 260, height: isSelected ? 420 : 360)
                        .background(Color.gray.opacity(0.3))
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(isSelected ? Color.green : Color.clear, lineWidth: 3)
            )
            .shadow(
                color: isSelected ? Color.green.opacity(0.6) : Color.black.opacity(0.5),
                radius: isSelected ? 30 : 10,
                x: 0,
                y: isSelected ? 0 : 10
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
        movies: [
            Movie(id: "1", title: "Inside Out 2", posterUrl: "home_image_trailer", genre: ["Animation"], description: "Desc", duration: "1h 36m", rating: 8.5, releaseDate: "2024-06-14",price: 100
                 ,showtimes: ["15:00"]
                 )
        ]
    )
}
