import SwiftUI

struct ProfileView: View {
    @State private var showWishlist = false
    @State private var showBookings = false
    @State private var showSettings = false
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var profileImage: Image?
    
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Profile Image
                Button {
                    showImagePicker = true
                } label: {
                    ZStack(alignment: .bottomTrailing) {
                        if let profileImage = profileImage {
                            profileImage
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .fill(Color.white.opacity(0.1))
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.white.opacity(0.5))
                                )
                        }
                        
                        // Edit button
                        Circle()
                            .fill(Color.green)
                            .frame(width: 32, height: 32)
                            .overlay(
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                            )
                            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                    }
                }
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
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .onChange(of: selectedImage) { oldValue, newValue in
            if let newValue = newValue {
                profileImage = Image(uiImage: newValue)
            }
        }
    }
}

// Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage {
                parent.selectedImage = image
            } else if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
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
