import SwiftUI

struct HeaderCarouselView: View {
    let movies: [Movie]  // Accept movies from parent
    var onPlayTrailer: ((Int) -> Void)? = nil
    
    var body: some View {
        HorizontalCarouselView(movies: movies, onPlayTrailer: onPlayTrailer)
    }
}

class CarouselViewModel: ObservableObject {
    @Published var currentIndex: Int = 0
    @Published var dragOffset: CGFloat = 0
    let movies: [Movie]  // Use actual Movie data
    
    init(movies: [Movie]) {
        self.movies = movies
        if !movies.isEmpty {
            autoScroll()
        }
    }
    
    func autoScroll() {
        Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { _ in
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                self.currentIndex = (self.currentIndex + 1) % self.movies.count
            }
        }
    }
}

struct HorizontalCarouselView: View {
    
    @StateObject var vm: CarouselViewModel
    @State private var buttonScale: CGFloat = 1.0
    var onPlayTrailer: ((Int) -> Void)? = nil
    
    init(movies: [Movie], onPlayTrailer: ((Int) -> Void)? = nil) {
        _vm = StateObject(wrappedValue: CarouselViewModel(movies: movies))
        self.onPlayTrailer = onPlayTrailer
    }
    
    var body: some View{
        GeometryReader { geo in
            if vm.movies.isEmpty {
                // Show placeholder when no movies
                ZStack {
                    Color.gray.opacity(0.2)
                    ProgressView()
                        .tint(.white)
                }
                .frame(height: 450)
            } else {
                TabView(selection: $vm.currentIndex) {
                    ForEach(vm.movies.indices, id: \.self) { index in
                        
                        ZStack {
                            // Load image from URL using AsyncImage
                            AsyncImage(url: URL(string: vm.movies[index].posterUrl)) { phase in
                                switch phase {
                                case .empty:
                                    // Loading state
                                    Color.gray.opacity(0.3)
                                        .overlay(ProgressView().tint(.white))
                                case .success(let image):
                                    // Successfully loaded image with blurred background fill
                                    ZStack {
                                        // Blurred background layer - fills entire width
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: geo.size.width, height: 450)
                                            .blur(radius: 100)
                                            .opacity(1)
                                            
                                        
                                        // Dark overlay to blend better
                                        Color.black.opacity(0.3)
                                        
                                        // Main sharp image centered
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(maxWidth: geo.size.width * 0.95, maxHeight: 450)
                                            .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 10)
                                    }
                                    .scaleEffect(vm.currentIndex == index ? 1.0 : 0.95)
                                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: vm.currentIndex)
                                case .failure:
                                    // Failed to load - show placeholder
                                    Color.gray.opacity(0.1)
                                        .overlay(
                                            Image(systemName: "photo")
                                                .font(.largeTitle)
                                                .foregroundColor(.white.opacity(0.9))
                                        )
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .frame(width: 450, height: 450)
                            
                            // Enhanced gradient overlay
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    .clear,
                                    .black.opacity(0.3),
                                    .black.opacity(0.4),
                                    .black.opacity(0.95)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            
                            // Content overlay
                            VStack(alignment: .leading, spacing: 16) {
                                Spacer()
                                
                                Text(vm.movies[index].title)
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 8)
                                    .transition(.opacity.combined(with: .scale))
                                    .animation(.spring(response: 0.5, dampingFraction: 0.7), value: vm.currentIndex)
                                
                                Button {
                                    onPlayTrailer?(vm.currentIndex)
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                        buttonScale = 0.95
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                            buttonScale = 1.0
                                        }
                                    }
                                } label: {
                                    HStack(spacing: 8) {
                                        Image(systemName: "play.fill")
                                            .font(.system(size: 14, weight: .bold))
                                        Text("Play Trailer")
                                            .font(.system(size: 15, weight: .semibold))
                                    }
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .background(
                                        Capsule()
                                            .fill(Color.white.opacity(0.25))
                                            .overlay(
                                                Capsule()
                                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                            )
                                            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                                    )
                                }
                                .scaleEffect(buttonScale)
                                .padding(.horizontal, 20)
                                .padding(.bottom, 20)
                            }
                            .padding(.horizontal, 24)
                            .padding(.bottom, 40)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
        }
        .frame(height: 450)
        .overlay(
            // Custom page indicators
            HStack(spacing: 8) {
                ForEach(vm.movies.indices, id: \.self) { index in
                    Capsule()
                        .fill(vm.currentIndex == index ? Color.white : Color.white.opacity(0.4))
                        .frame(width: vm.currentIndex == index ? 24 : 8, height: 8)
                        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: vm.currentIndex)
                }
            }
            .padding(.bottom, 16),
            alignment: .bottom
        )
    }
}

#Preview {
    HomeView()
}
