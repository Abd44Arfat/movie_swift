import SwiftUI

struct BookingSuccessView: View {
    let movieTitle: String
    let movieImage: String
    let selectedDate: String
    let selectedTime: String
    let selectedSeats: String
    let location: String
    let totalPrice: Double
    
    @Environment(\.dismiss) var dismiss
    @State private var showCheckmark = false
    @State private var showContent = false
    @State private var pulseAnimation = false
    
    var body: some View {
        ZStack {
            // Background
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.1))
                            )
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 20)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 32) {
                        // Success Animation
                        ZStack {
                            // Pulsing circles
                            Circle()
                                .stroke(Color.green.opacity(0.2), lineWidth: 2)
                                .frame(width: 140, height: 140)
                                .scaleEffect(pulseAnimation ? 1.2 : 1.0)
                                .opacity(pulseAnimation ? 0 : 1)
                            
                            Circle()
                                .stroke(Color.green.opacity(0.3), lineWidth: 2)
                                .frame(width: 120, height: 120)
                                .scaleEffect(pulseAnimation ? 1.15 : 1.0)
                                .opacity(pulseAnimation ? 0 : 1)
                            
                            // Main circle
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.green, Color.green.opacity(0.8)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 100, height: 100)
                                .shadow(color: .green.opacity(0.5), radius: 20, x: 0, y: 10)
                            
                            // Checkmark
                            if showCheckmark {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 50, weight: .bold))
                                    .foregroundColor(.white)
                                    .transition(.scale.combined(with: .opacity))
                            }
                        }
                        .padding(.top, 20)
                        .onAppear {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2)) {
                                showCheckmark = true
                            }
                            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: false)) {
                                pulseAnimation = true
                            }
                            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.4)) {
                                showContent = true
                            }
                        }
                        
                        if showContent {
                            VStack(spacing: 12) {
                                Text("Booking Successful!")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.white)
                                    .transition(.move(edge: .top).combined(with: .opacity))
                                
                                Text("Your reservation has been confirmed")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white.opacity(0.7))
                                    .transition(.move(edge: .top).combined(with: .opacity))
                            }
                            
                            // Movie Poster Card
                            VStack(spacing: 20) {
                                Image(movieImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 200, height: 280)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 10)
                                
                                Text(movieTitle)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .transition(.scale.combined(with: .opacity))
                            .padding(.top, 10)
                            
                            // Booking Details Card
                            VStack(spacing: 0) {
                                BookingDetailRow(
                                    icon: "calendar",
                                    label: "Date & Time",
                                    value: "\(selectedDate)\n\(selectedTime)"
                                )
                                
                                Divider()
                                    .background(Color.white.opacity(0.1))
                                    .padding(.horizontal, 20)
                                
                                BookingDetailRow(
                                    icon: "ticket.fill",
                                    label: "Seats",
                                    value: selectedSeats
                                )
                                
                                Divider()
                                    .background(Color.white.opacity(0.1))
                                    .padding(.horizontal, 20)
                                
                                BookingDetailRow(
                                    icon: "mappin.circle.fill",
                                    label: "Location",
                                    value: location
                                )
                                
                                Divider()
                                    .background(Color.white.opacity(0.1))
                                    .padding(.horizontal, 20)
                                
                                BookingDetailRow(
                                    icon: "dollarsign.circle.fill",
                                    label: "Total Amount",
                                    value: "$\(String(format: "%.2f", totalPrice))",
                                    isHighlighted: true
                                )
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(Color.white.opacity(0.05))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 24)
                                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                    )
                            )
                            .padding(.horizontal, 20)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            
                            // QR Code Placeholder
                            VStack(spacing: 16) {
                                Text("Your Ticket")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                // QR Code placeholder
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .frame(width: 200, height: 200)
                                    .overlay(
                                        VStack(spacing: 8) {
                                            Image(systemName: "qrcode")
                                                .font(.system(size: 80))
                                                .foregroundColor(.black)
                                            
                                            Text("Scan at cinema")
                                                .font(.system(size: 12, weight: .medium))
                                                .foregroundColor(.black.opacity(0.6))
                                        }
                                    )
                                    .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 8)
                                
                                Text("Show this QR code at the entrance")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            .padding(.top, 10)
                            .transition(.scale.combined(with: .opacity))
                            
                            // Action Buttons
                            VStack(spacing: 12) {
                                Button {
                                    // Download ticket action
                                } label: {
                                    HStack {
                                        Image(systemName: "arrow.down.circle.fill")
                                            .font(.system(size: 20))
                                        Text("Download Ticket")
                                            .font(.system(size: 18, weight: .semibold))
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 18)
                                    .background(
                                        RoundedRectangle(cornerRadius: 30)
                                            .fill(Color.green)
                                            .shadow(color: .green.opacity(0.4), radius: 20, x: 0, y: 10)
                                    )
                                }
                                
                                Button {
                                    dismiss()
                                } label: {
                                    Text("Back to Home")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.white.opacity(0.8))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 30)
                                                .fill(Color.white.opacity(0.1))
                                        )
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            .padding(.bottom, 40)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct BookingDetailRow: View {
    let icon: String
    let label: String
    let value: String
    var isHighlighted: Bool = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(isHighlighted ? .green : .white.opacity(0.7))
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(isHighlighted ? Color.green.opacity(0.2) : Color.white.opacity(0.05))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.6))
                
                Text(value)
                    .font(.system(size: 16, weight: isHighlighted ? .bold : .medium))
                    .foregroundColor(isHighlighted ? .green : .white)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(20)
    }
}

#Preview {
    BookingSuccessView(
        movieTitle: "Inside Out 2",
        movieImage: "home_image_trailer",
        selectedDate: "Friday, 23th June 2024",
        selectedTime: "8:30 PM",
        selectedSeats: "G9, G10",
        location: "Miami, Aventura 24",
        totalPrice: 23.00
    )
}
