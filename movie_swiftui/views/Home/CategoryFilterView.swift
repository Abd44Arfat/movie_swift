import SwiftUI
struct CategoryFilterView: View {
    
    let categories = ["All", "Action", "Adventure", "Horror"]
    @State private var selected = "All"
    
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories, id: \.self) { cat in
                    Text(cat)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(selected == cat ? .black : .white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(selected == cat ? Color.white : Color.white.opacity(0.1))
                                .shadow(
                                    color: selected == cat ? Color.white.opacity(0.3) : .clear,
                                    radius: 8,
                                    x: 0,
                                    y: 4
                                )
                        )
                        .scaleEffect(selected == cat ? 1.05 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selected)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selected = cat
                            }
                            viewModel.fetchMovies(genre: cat)
                        }
                }
            }
            .padding(.vertical)
        }
    }
}
