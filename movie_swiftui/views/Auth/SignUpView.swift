import SwiftUI

struct SignUpView: View {
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    @State private var isLoading = false
    @State private var agreedToTerms = false
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
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                            )
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 32) {
                        // Logo/Title Section
                        VStack(spacing: 16) {
                            Text("Create Account")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.top, 40)
                            
                            Text("Sign up to get started")
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.bottom, 10)
                        
                        // Glassmorphism Container
                        VStack(spacing: 20) {
                            // Full Name Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Full Name")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white.opacity(0.8))
                                
                                HStack(spacing: 12) {
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.white.opacity(0.6))
                                        .frame(width: 20)
                                    
                                    TextField("", text: $fullName)
                                        .placeholder(when: fullName.isEmpty) {
                                            Text("Enter your full name")
                                                .foregroundColor(.white.opacity(0.4))
                                        }
                                        .foregroundColor(.white)
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
                            
                            // Email Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Email")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white.opacity(0.8))
                                
                                HStack(spacing: 12) {
                                    Image(systemName: "envelope.fill")
                                        .foregroundColor(.white.opacity(0.6))
                                        .frame(width: 20)
                                    
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
                                        .frame(width: 20)
                                    
                                    if showPassword {
                                        TextField("", text: $password)
                                            .placeholder(when: password.isEmpty) {
                                                Text("Create a password")
                                                    .foregroundColor(.white.opacity(0.4))
                                            }
                                            .foregroundColor(.white)
                                    } else {
                                        SecureField("", text: $password)
                                            .placeholder(when: password.isEmpty) {
                                                Text("Create a password")
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
                            
                            // Confirm Password Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Confirm Password")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white.opacity(0.8))
                                
                                HStack(spacing: 12) {
                                    Image(systemName: "lock.fill")
                                        .foregroundColor(.white.opacity(0.6))
                                        .frame(width: 20)
                                    
                                    if showConfirmPassword {
                                        TextField("", text: $confirmPassword)
                                            .placeholder(when: confirmPassword.isEmpty) {
                                                Text("Confirm your password")
                                                    .foregroundColor(.white.opacity(0.4))
                                            }
                                            .foregroundColor(.white)
                                    } else {
                                        SecureField("", text: $confirmPassword)
                                            .placeholder(when: confirmPassword.isEmpty) {
                                                Text("Confirm your password")
                                                    .foregroundColor(.white.opacity(0.4))
                                            }
                                            .foregroundColor(.white)
                                    }
                                    
                                    Button {
                                        showConfirmPassword.toggle()
                                    } label: {
                                        Image(systemName: showConfirmPassword ? "eye.slash.fill" : "eye.fill")
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
                        }
                        .padding(24)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(.ultraThinMaterial)
                                .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
                        )
                        .padding(.horizontal, 20)
                        
                        // Terms and Conditions
                        Button {
                            withAnimation {
                                agreedToTerms.toggle()
                            }
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: agreedToTerms ? "checkmark.square.fill" : "square")
                                    .font(.system(size: 22))
                                    .foregroundColor(agreedToTerms ? .green : .white.opacity(0.3))
                                
                                Text("I agree to the Terms & Conditions")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.8))
                                
                                Spacer()
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        // Sign Up Button
                        Button {
                            authManager.register(name: fullName, email: email, password: password) { success in
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
                                    Text("Create Account")
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
                        .disabled(!isFormValid || authManager.isLoading)
                        .opacity(isFormValid ? 1.0 : 0.6)
                        .padding(.horizontal, 24)
                        .padding(.top, 10)
                        
                        // Sign In Link
                        HStack(spacing: 4) {
                            Text("Already have an account?")
                                .foregroundColor(.white.opacity(0.7))
                            
                            Button {
                                dismiss()
                            } label: {
                                Text("Sign In")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.green)
                            }
                        }
                        .font(.system(size: 15))
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    var isFormValid: Bool {
        !fullName.isEmpty &&
        !email.isEmpty &&
        !password.isEmpty &&
        password == confirmPassword &&
        agreedToTerms
    }
}

#Preview {
    SignUpView()
}
