import SwiftUI

struct PopularMoviesSection: View {
    let movies: [Movie]  // Accept movies from parent
    
    @State private var seeAllPressed = false
    var onMovieTap: ((Int) -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Popular Movies")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                
                Spacer()
                
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        seeAllPressed = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            seeAllPressed = false
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text("See All")
                            .foregroundColor(.white.opacity(0.7))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                .scaleEffect(seeAllPressed ? 0.9 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: seeAllPressed)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(movies.indices, id: \.self) { index in
                        MovieCardView(
                            movie: movies[index],
                            onTap: {
                                onMovieTap?(index)
                            }
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
    }
}
