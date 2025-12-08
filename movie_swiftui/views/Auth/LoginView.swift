import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var isLoading = false
    @State private var showSignUp = false
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            // Subtle glow effect at top
            VStack {
                RadialGradient(
                    colors: [
                        Color.green.opacity(0.3),
                        Color.blue.opacity(0.2),
                        Color.clear
                    ],
                    center: .top,
                    startRadius: 0,
                    endRadius: 400
                )
                .frame(height: 300)
                .ignoresSafeArea()
                
                Spacer()
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 32) {
                    // Logo/Title Section
                    VStack(spacing: 16) {
                        Text("Welcome Back")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.top, 60)
                        
                        Text("Sign in to continue your movie journey")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.bottom, 20)
                    
                    // Glassmorphism Container
                    VStack(spacing: 24) {
                        // Email Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                            
                            HStack(spacing: 12) {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(.white.opacity(0.6))
                                
                                TextField("", text: $email)
                                    .placeholder(when: email.isEmpty) {
                                        Text("Enter your email")
                                            .foregroundColor(.white.opacity(0.4))
                                    }
                                    .foregroundColor(.white)
                                    .textInputAutocapitalization(.never)
                                    .keyboardType(.emailAddress)
                                    .autocorrectionDisabled()
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                            )
                        }
                        
                        // Password Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                            
                            HStack(spacing: 12) {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.white.opacity(0.6))
                                
                                if showPassword {
                                    TextField("", text: $password)
                                        .placeholder(when: password.isEmpty) {
                                            Text("Enter your password")
                                                .foregroundColor(.white.opacity(0.4))
                                        }
                                        .foregroundColor(.white)
                                } else {
                                    SecureField("", text: $password)
                                        .placeholder(when: password.isEmpty) {
                                            Text("Enter your password")
                                                .foregroundColor(.white.opacity(0.4))
                                        }
                                        .foregroundColor(.white)
                                }
                                
                                Button {
                                    showPassword.toggle()
                                } label: {
                                    Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(.white.opacity(0.6))
                                }
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                            )
                        }
                        
                        // Forgot Password
                        HStack {
                            Spacer()
                            Button {
                                // Forgot password action
                            } label: {
                                Text("Forgot Password?")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.green)
                            }
                        }
                        
                        // Login Button
                        Button {
                            authManager.login(email: email, password: password) { success in
                                if success {
                                    dismiss()
                                }
                            }
                        } label: {
                            ZStack {
                                if authManager.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Sign In")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.green)
                            .cornerRadius(28)
                            .shadow(color: .green.opacity(0.4), radius: 20, x: 0, y: 10)
                        }
                        .disabled(email.isEmpty || password.isEmpty || authManager.isLoading)
                        .opacity((email.isEmpty || password.isEmpty) ? 0.6 : 1.0)
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(.ultraThinMaterial)
                            .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
                    )
                    .padding(.horizontal, 20)
                    
                    // Social Login Buttons
                    VStack(spacing: 16) {
                        Text("Or continue with")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.6))
                        
                        HStack(spacing: 20) {
                            SocialLoginButton(icon: "apple.logo")
                            SocialLoginButton(icon: "g.circle.fill")
                            SocialLoginButton(icon: "f.circle.fill") // Added Facebook for balance
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    // Sign Up Link
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .foregroundColor(.white.opacity(0.7))
                        
                        Button {
                            showSignUp = true
                        } label: {
                            Text("Sign Up")
                                .fontWeight(.semibold)
                                .foregroundColor(.green)
                        }
                    }
                    .font(.system(size: 15))
                    .padding(.top, 10)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showSignUp) {
            SignUpView()
        }
    }
}

struct SocialLoginButton: View {
    let icon: String
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
            }
        } label: {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(.ultraThinMaterial)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                )
        }
        .scaleEffect(isPressed ? 0.9 : 1.0)
    }
}

// Helper extension for placeholder
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthManager.shared)
}
