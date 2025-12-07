import SwiftUI

struct Seat: Identifiable {
    let id = UUID()
    let row: String
    let number: Int
    var status: SeatStatus
}

enum SeatStatus {
    case available
    case notAvailable
    case selected
}

struct SeatSelectionView: View {
    let movieId: String
    let movieTitle: String
    let movieImage: String
    let duration: String
    let rating: String
    let selectedDate: String
    let selectedTime: String
    let location: String
    
    @StateObject private var viewModel = BookingViewModel()
    @State private var seats: [[Seat]] = []
    @State private var selectedSeats: [Seat] = []
    @State private var showSuccess = false
    @Environment(\.dismiss) var dismiss
    
    var totalPrice: Double {
        Double(selectedSeats.count) * 11.50
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
                
                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(1.5)
                    Spacer()
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 24) {
                            // Movie Info
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(movieTitle)
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    HStack(spacing: 8) {
                                        Image(systemName: "clock")
                                            .font(.system(size: 12))
                                        Text(duration)
                                        Text("|")
                                        Text(rating)
                                    }
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.7))
                                }
                                
                                Spacer()
                                
                                Text("\(availableSeatsCount) Seats Available")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            .padding(.horizontal, 20)
                            
                            // Cinema Screen
                            VStack(spacing: 30) {
                                // Seats Grid
                                VStack(spacing: 8) {
                                    ForEach(seats.indices, id: \.self) { rowIndex in
                                        HStack(spacing: 6) {
                                            ForEach(seats[rowIndex].indices, id: \.self) { seatIndex in
                                                SeatView(
                                                    seat: seats[rowIndex][seatIndex],
                                                    onTap: {
                                                        toggleSeat(row: rowIndex, seat: seatIndex)
                                                    }
                                                )
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                                
                                // Screen
                                VStack(spacing: 12) {
                                    RoundedRectangle(cornerRadius: 100)
                                        .fill(
                                            LinearGradient(
                                                colors: [Color.blue.opacity(0.3), Color.blue.opacity(0.1)],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        .frame(height: 4)
                                        .padding(.horizontal, 40)
                                }
                            }
                            
                            // Legend
                            HStack(spacing: 24) {
                                LegendItem(color: Color.gray.opacity(0.3), label: "Not Available")
                                LegendItem(color: Color.blue, label: "Available")
                                LegendItem(color: Color.green, label: "Selected")
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            
                            // Summary
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Summary")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                
                                VStack(spacing: 12) {
                                    SummaryRow(label: "Date", value: selectedDate)
                                    SummaryRow(label: "Seats Selected", value: selectedSeats.map { "\($0.row)\($0.number)" }.joined(separator: ", "))
                                    SummaryRow(label: "Location", value: location)
                                }
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white.opacity(0.05))
                            )
                            .padding(.horizontal, 20)
                            
                            // Continue Button
                            HStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("$\(String(format: "%.2f", totalPrice))")
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundColor(.white)
                                    Text("\(selectedSeats.count) Seats")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                
                                Spacer()
                                
                                Button {
                                    viewModel.createBooking(
                                        movieId: movieId,
                                        date: selectedDate, // Note: Should be ISO date, but using string for now as per current UI
                                        seats: selectedSeats.map { "\($0.row)\($0.number)" },
                                        totalPrice: totalPrice,
                                        location: location
                                    )
                                } label: {
                                    Text("Book Ticket")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                        .fixedSize(horizontal: true, vertical: false)
                                        .padding(.horizontal, 40)
                                        .padding(.vertical, 16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 30)
                                                .fill(Color.blue)
                                                .shadow(color: .blue.opacity(0.4), radius: 20, x: 0, y: 10)
                                        )
                                }
                                .disabled(selectedSeats.isEmpty)
                                .opacity(selectedSeats.isEmpty ? 0.5 : 1.0)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 10)
                            .padding(.bottom, 40)
                        }
                    }
                }
            }
            .alert(isPresented: Binding<Bool>(
                get: { viewModel.errorMessage != nil },
                set: { _ in viewModel.errorMessage = nil }
            )) {
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? "Unknown error"), dismissButton: .default(Text("OK")))
            }
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $viewModel.bookingSuccess) {
            BookingSuccessView(
                movieTitle: movieTitle,
                movieImage: movieImage,
                selectedDate: selectedDate,
                selectedTime: selectedTime,
                selectedSeats: selectedSeats.map { "\($0.row)\($0.number)" }.joined(separator: ", "),
                location: location,
                totalPrice: totalPrice
            )
        }
        .onAppear {
            setupSeats()
            viewModel.fetchBookedSeats(movieId: movieId, date: selectedDate)
        }
        .onReceive(viewModel.$bookedSeats) { bookedSeats in
            updateBookedSeats(bookedSeats: bookedSeats)
        }
    }
    
    var availableSeatsCount: Int {
        seats.flatMap { $0 }.filter { $0.status == .available }.count
    }
    
    func setupSeats() {
        // Create seat layout matching the reference
        let rows = ["I", "H", "G", "F", "E", "D", "C", "B", "A"]
        var allSeats: [[Seat]] = []
        
        for (rowIndex, row) in rows.enumerated() {
            var rowSeats: [Seat] = []
            
            for i in 1...12 {
                var status: SeatStatus = .available
                
                // Set some seats as not available (structural layout if needed)
                // For now, making all seats potentially available until fetched
                
                rowSeats.append(Seat(row: row, number: i, status: status))
            }
            
            allSeats.append(rowSeats)
        }
        
        seats = allSeats
    }
    
    func updateBookedSeats(bookedSeats: [String]) {
        for rowIndex in seats.indices {
            for seatIndex in seats[rowIndex].indices {
                let seat = seats[rowIndex][seatIndex]
                let seatId = "\(seat.row)\(seat.number)"
                
                if bookedSeats.contains(seatId) {
                    seats[rowIndex][seatIndex].status = .notAvailable
                    // If it was selected, deselect it
                    if let selectedIndex = selectedSeats.firstIndex(where: { $0.id == seat.id }) {
                        selectedSeats.remove(at: selectedIndex)
                    }
                } else {
                    // Reset to available if it's not booked and not selected
                    if seats[rowIndex][seatIndex].status == .notAvailable {
                        seats[rowIndex][seatIndex].status = .available
                    }
                }
            }
        }
    }
    
    func toggleSeat(row: Int, seat: Int) {
        guard seats[row][seat].status != .notAvailable else { return }
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            if seats[row][seat].status == .selected {
                seats[row][seat].status = .available
                selectedSeats.removeAll { $0.id == seats[row][seat].id }
            } else {
                seats[row][seat].status = .selected
                selectedSeats.append(seats[row][seat])
            }
        }
    }
}

struct SeatView: View {
    let seat: Seat
    let onTap: () -> Void
    
    var seatColor: Color {
        switch seat.status {
        case .available:
            return .blue
        case .notAvailable:
            return Color.gray.opacity(0.3)
        case .selected:
            return .green
        }
    }
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(seatColor)
                    .frame(width: 24, height: 24)
                
                if seat.status != .notAvailable {
                    Text("\(seat.number)")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(.white)
                }
            }
        }
        .disabled(seat.status == .notAvailable)
        .scaleEffect(seat.status == .selected ? 1.1 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: seat.status)
    }
}

struct LegendItem: View {
    let color: Color
    let label: String
    
    var body: some View {
        HStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 4)
                .fill(color)
                .frame(width: 20, height: 20)
            
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.7))
        }
    }
}

struct SummaryRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.7))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    SeatSelectionView(
        movieId: "123",
        movieTitle: "Inside Out 2",
        movieImage: "home_image_trailer",
        duration: "1 HR 36 MIN",
        rating: "PG",
        selectedDate: "Friday, 23th June 2024",
        selectedTime: "8:30 PM",
        location: "Miami, Aventura 24"
    )
}
