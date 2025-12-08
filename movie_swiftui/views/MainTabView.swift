import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        ZStack {
            if authManager.isAuthenticated {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Content based on selected tab
                    Group {
                        switch selectedTab {
                        case 0:
                            HomeView()
                        case 1:
                            SearchView()
                      
                        case 2:
                            ProfileView()
                        default:
                            HomeView()
                        }
                    }
                    
                    // Custom Tab Bar
                    EnhancedTabBar(selectedTab: $selectedTab)
                }
            } else {
                LoginView()
            }
        }
    }
}

struct EnhancedTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            TabBarButton(
                icon: "house.fill",
                label: "Home",
                isSelected: selectedTab == 0,
                index: 0,
                selectedTab: $selectedTab
            )
            
            TabBarButton(
                icon: "magnifyingglass",
                label: "Search",
                isSelected: selectedTab == 1,
                index: 1,
                selectedTab: $selectedTab
            )
            
       
            
            TabBarButton(
                icon: "person.fill",
                label: "Profile",
                isSelected: selectedTab == 2,
                index: 2,
                selectedTab: $selectedTab
            )
        }
        .padding(.vertical, 12)
        .padding(.bottom, 8) // Extra padding for safe area
        .background(
            Rectangle()
                .fill(Color.black.opacity(0.95))
                .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: -5)
                .ignoresSafeArea()
        )
    }
}

struct TabBarButton: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let index: Int
    @Binding var selectedTab: Int
    @State private var isPressed = false
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = index
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isPressed = false
                }
            }
        } label: {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 22, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? .green : .white.opacity(0.6))
                    .scaleEffect(isPressed ? 0.85 : (isSelected ? 1.1 : 1.0))
                
                Text(label)
                    .font(.system(size: 10, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? .green : .white.opacity(0.6))
                
               
            }
            .frame(maxWidth: .infinity)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        }
    }
}

#Preview {
    MainTabView()
}
