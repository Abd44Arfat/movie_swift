import SwiftUI

struct HeaderCarouselView: View {
    var onPlayTrailer: ((Int) -> Void)? = nil
    
    var body: some View {
        HorizontalCarouselView(onPlayTrailer: onPlayTrailer)
    }
}

struct CarouselItem: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
}

class CarouselViewModel: ObservableObject {
    @Published var currentIndex: Int = 0
    @Published var dragOffset: CGFloat = 0
    
    let items: [CarouselItem] = [
        CarouselItem(imageName: "home_image_trailer", title: "Inside Out 2"),
        CarouselItem(imageName: "movie3", title: "Garfield"),
        CarouselItem(imageName: "movie3", title: "Movie 3")
    ]
    
    init() {
        autoScroll()
    }
    
    func autoScroll() {
        Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { _ in
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                self.currentIndex = (self.currentIndex + 1) % self.items.count
            }
        }
    }
}

struct HorizontalCarouselView: View {
    
    @StateObject var vm = CarouselViewModel()
    @State private var buttonScale: CGFloat = 1.0
    var onPlayTrailer: ((Int) -> Void)? = nil
    
    var body: some View{
        GeometryReader { geo in
            TabView(selection: $vm.currentIndex) {
                ForEach(vm.items.indices, id: \.self) { index in
                    
                    ZStack {
                        // Image with parallax effect - FULL WIDTH
                        Image(vm.items[index].imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width, height: 600)
                            .clipped()
                            .scaleEffect(vm.currentIndex == index ? 1.0 : 0.95)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: vm.currentIndex)
                        
                        // Enhanced gradient overlay
                        LinearGradient(
                            gradient: Gradient(colors: [
                                .clear,
                                .black.opacity(0.3),
                                .black.opacity(0.7),
                                .black.opacity(0.95)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        
                        // Content overlay
                        VStack(alignment: .leading, spacing: 16) {
                            Spacer()
                            
                            Text(vm.items[index].title)
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
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
        .frame(height: 600)
        .overlay(
            // Custom page indicators
            HStack(spacing: 8) {
                ForEach(vm.items.indices, id: \.self) { index in
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
