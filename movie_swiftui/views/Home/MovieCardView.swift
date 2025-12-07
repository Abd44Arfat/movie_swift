import SwiftUI

struct MovieCardView: View {
    let movie: Movie  // Accept full Movie object
    var onTap: (() -> Void)? = nil
    @State private var isPressed = false
    
    var body: some View {
        // Use AsyncImage to load from URL
        AsyncImage(url: URL(string: movie.posterUrl)) { phase in
            switch phase {
            case .empty:
                // Loading state
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 150, height: 220)
                    .overlay(ProgressView().tint(.white))
            case .success(let image):
                // Successfully loaded image
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            case .failure:
                // Failed to load - show placeholder
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 150, height: 220)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.white.opacity(0.5))
                    )
            @unknown default:
                EmptyView()
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .shadow(
            color: .black.opacity(0.4),
            radius: isPressed ? 8 : 15,
            x: 0,
            y: isPressed ? 4 : 8
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .onTapGesture {
            onTap?()
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
            }
        }
    }
}
