import SwiftUI

struct ProfileView: View {
    @State private var showWishlist = false
    @State private var showBookings = false
    @State private var showSettings = false // Placeholder for settings
    
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Profile Image
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 100, height: 100)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white.opacity(0.5))
                    )
                    .padding(.top, 80)
                
                Text(authManager.currentUser?.name ?? "User Profile")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                VStack(spacing: 16) {
                    ProfileMenuItem(icon: "ticket.fill", title: "My Bookings") {
                        showBookings = true
                    }
                    
                    ProfileMenuItem(icon: "heart.fill", title: "Favorites") {
                        showWishlist = true
                    }
                    
                    ProfileMenuItem(icon: "gearshape.fill", title: "Settings") {
                        showSettings = true
                    }
                    
                    ProfileMenuItem(icon: "info.circle.fill", title: "About")
                    
                    ProfileMenuItem(icon: "rectangle.portrait.and.arrow.right", title: "Logout") {
                        AuthManager.shared.logout()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Spacer()
            }
        }
        .fullScreenCover(isPresented: $showWishlist) {
            WishlistView()
        }
        .fullScreenCover(isPresented: $showBookings) {
            MyBookingsView()
        }
    }
}

struct ProfileMenuItem: View {
    let icon: String
    let title: String
    var action: (() -> Void)? = nil
    @State private var isPressed = false
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
                action?()
            }
        } label: {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.green)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(Color.green.opacity(0.2))
                    )
                
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.05))
            )
        }
        .scaleEffect(isPressed ? 0.98 : 1.0)
    }
}

#Preview {
    ProfileView()
}
