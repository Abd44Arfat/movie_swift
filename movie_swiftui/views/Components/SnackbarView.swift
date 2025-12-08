import SwiftUI

struct SnackbarView: View {
    @Binding var isShowing: Bool
    let message: String
    let type: SnackbarType
    
    var body: some View {
        VStack {
            Spacer()
            
            if isShowing {
                HStack(spacing: 16) {
                    Image(systemName: type == .success ? "checkmark.circle.fill" : (type == .error ? "exclamationmark.circle.fill" : "info.circle.fill"))
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                    
                    Text(message)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Button {
                        withAnimation {
                            isShowing = false
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(type == .success ? Color.green : (type == .error ? Color.red : Color.blue))
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            isShowing = false
                        }
                    }
                }
            }
        }
        .animation(.spring(), value: isShowing)
        .zIndex(100)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        SnackbarView(isShowing: .constant(true), message: "Operation successful!", type: .success)
    }
}
