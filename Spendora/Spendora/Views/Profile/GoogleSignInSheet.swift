/**
 * Main/Core Functions & Purpose:
 * GoogleSignInSheet modal view rendering an authentic Google Account selection portal.
 * Features 1-tap quick account selection for preset student/developer emails as well as custom email input,
 * saving credentials directly into UserProfileManager while keeping user data 100% on-device.
 */

import SwiftUI

struct GoogleSignInSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var profileManager = UserProfileManager.shared
    
    // State variables for form inputs and quick selection
    @State private var displayName = ""
    @State private var email = ""
    @State private var selectedPresetIndex: Int? = nil
    
    private let presetAccounts = [
        (name: "Demo Account", email: "demo.user@gmail.com"),
        (name: "Personal Account", email: "user@gmail.com"),
        (name: "Work Account", email: "user@company.com")
    ]
    
    var isValid: Bool {
        !displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Google Header Branding
                    VStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(Color(hex: "#4285F4").opacity(0.12))
                                .frame(width: 70, height: 70)
                            
                            Image(systemName: "g.circle.fill")
                                .font(.system(size: 38, weight: .bold))
                                .foregroundColor(Color(hex: "#4285F4"))
                        }
                        
                        VStack(spacing: 4) {
                            Text("Sign in with Google")
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundColor(.textPrimary)
                            
                            Text("Choose a Google Account to personalize Spendora")
                                .font(.system(size: 13, design: .rounded))
                                .foregroundColor(.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.top, 10)
                    
                    // Quick Account Chooser
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Quick Select Google Account")
                            .font(.system(.caption, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.textSecondary)
                            .tracking(1.0)
                            .padding(.horizontal, 4)
                        
                        VStack(spacing: 8) {
                            ForEach(0..<presetAccounts.count, id: \.self) { index in
                                let account = presetAccounts[index]
                                Button {
                                    selectedPresetIndex = index
                                    displayName = account.name
                                    email = account.email
                                } label: {
                                    HStack(spacing: 12) {
                                        ZStack {
                                            Circle()
                                                .fill(Color(hex: "#4285F4"))
                                                .frame(width: 38, height: 38)
                                            Text(account.name.prefix(1).uppercased())
                                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                                .foregroundColor(.white)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(account.name)
                                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                                .foregroundColor(.textPrimary)
                                            Text(account.email)
                                                .font(.system(size: 12, design: .rounded))
                                                .foregroundColor(.textSecondary)
                                        }
                                        
                                        Spacer()
                                        
                                        if selectedPresetIndex == index {
                                            Image(systemName: "checkmark.circle.fill")
                                                .font(.title3)
                                                .foregroundColor(Color(hex: "#4285F4"))
                                        }
                                    }
                                    .padding(12)
                                    .background(selectedPresetIndex == index ? Color(hex: "#4285F4").opacity(0.08) : Color.cardBackground)
                                    .cornerRadius(14)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(selectedPresetIndex == index ? Color(hex: "#4285F4") : Color.secondary.opacity(0.15), lineWidth: selectedPresetIndex == index ? 2 : 1)
                                    )
                                }
                            }
                        }
                    }
                    
                    // Manual Account Details Form
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Or Enter Custom Google Details")
                            .font(.system(.caption, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.textSecondary)
                            .tracking(1.0)
                            .padding(.horizontal, 4)
                        
                        VStack(spacing: 12) {
                            TextField("Google Account Name", text: $displayName)
                                .font(.system(.body, design: .rounded))
                                .padding(12)
                                .background(Color.cardBackground)
                                .cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.secondary.opacity(0.2), lineWidth: 1))
                                .onChange(of: displayName) { _, _ in selectedPresetIndex = nil }
                            
                            TextField("Google Email Address", text: $email)
                                .font(.system(.body, design: .rounded))
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .padding(12)
                                .background(Color.cardBackground)
                                .cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.secondary.opacity(0.2), lineWidth: 1))
                                .onChange(of: email) { _, _ in selectedPresetIndex = nil }
                        }
                    }
                    
                    // Confirm Google Sign-In Button
                    Button {
                        profileManager.signInWithGoogle(displayName: displayName, email: email)
                        dismiss()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "g.circle.fill")
                                .font(.title3)
                            Text("Sign in with Google")
                                .font(.system(.body, design: .rounded))
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(
                            LinearGradient(
                                colors: [Color(hex: "#4285F4"), Color(hex: "#34A853")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(14)
                        .shadow(color: Color(hex: "#4285F4").opacity(0.3), radius: 8, x: 0, y: 3)
                    }
                    .disabled(!isValid)
                    .opacity(isValid ? 1.0 : 0.5)
                    .padding(.top, 10)
                }
                .padding(16)
            }
            .background(Color.appBackground.ignoresSafeArea())
            .navigationTitle("Google Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
