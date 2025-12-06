import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                Text("Search")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 60)
                
                Spacer()
                
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 60))
                    .foregroundColor(.white.opacity(0.3))
                
                Text("Search for movies")
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.5))
                    .padding(.top, 20)
                
                Spacer()
            }
        }
    }
}

#Preview {
    SearchView()
}
