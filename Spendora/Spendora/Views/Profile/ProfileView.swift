//
//  ProfileView.swift
//  Spendora
//
//  Capstone 2026 - Mobile Application Development
//  Author: Sheikh Naim
//

/**
 * Main/Core Functions & Purpose:
 * ProfileView screen displaying active user profile identity (Guest Mode vs Signed-In Account),
 * avatar initials, provider status badges (Apple, Google, Email), account management actions (Edit, Switch Account, Sign Out),
 * and 100% on-device privacy guarantee cards.
 */

import SwiftUI
import AuthenticationServices

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var profileManager = UserProfileManager.shared
    
    // Modal sheet presentation states
    @State private var showingEmailSheet = false
    @State private var showingAppleSheet = false
    @State private var showingGoogleSheet = false
    @State private var showingEditSheet = false
    @State private var showingSignOutAlert = false
    
    private let generator = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // MARK: - Header Profile Card
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(hex: profileManager.profile.avatarColorHex),
                                            Color(hex: profileManager.profile.avatarColorHex).opacity(0.6)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 80, height: 80)
                                .shadow(color: Color(hex: profileManager.profile.avatarColorHex).opacity(0.3), radius: 10, x: 0, y: 4)
                            
                            Text(profileManager.profile.initials)
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: 4) {
                            Text(profileManager.profile.displayName)
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundColor(.textPrimary)
                            
                            Text(profileManager.profile.email)
                                .font(.system(size: 14, design: .rounded))
                                .foregroundColor(.textSecondary)
                        }
                        
                        // Provider Badge
                        HStack(spacing: 6) {
                            Image(systemName: profileManager.profile.provider.icon)
                                .font(.caption2)
                            Text(profileManager.profile.isGuest ? "Guest Mode" : "\(profileManager.profile.provider.displayName) Account")
                                .font(.system(.caption, design: .rounded))
                                .fontWeight(.semibold)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(profileManager.profile.provider.badgeColor.opacity(0.15))
                        .foregroundColor(profileManager.profile.provider.badgeColor)
                        .cornerRadius(20)
                    }
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .background(Color.cardBackground)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 2)
                    
                    // MARK: - Privacy Guarantee Card
                    HStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(Color(hex: "#4ECDC4").opacity(0.15))
                                .frame(width: 44, height: 44)
                            Image(systemName: "lock.shield.fill")
                                .font(.title3)
                                .foregroundColor(Color(hex: "#4ECDC4"))
                        }
                        
                        VStack(alignment: .leading, spacing: 3) {
                            Text("100% On-Device Privacy")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(.textPrimary)
                            
                            Text("Your profile and subscription records stay strictly on your local iPhone. No external cloud servers.")
                                .font(.system(size: 12, design: .rounded))
                                .foregroundColor(.textSecondary)
                                .lineSpacing(2)
                        }
                    }
                    .padding(14)
                    .background(Color.cardBackground)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 2)
                    
                    // MARK: - Sign In Options (If Guest)
                    if profileManager.profile.isGuest {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Personalize Your Profile")
                                .font(.system(.subheadline, design: .rounded))
                                .fontWeight(.semibold)
                                .foregroundColor(.textSecondary)
                                .padding(.horizontal, 4)
                            
                            // Sign in with Apple Button
                            Button {
                                generator.impactOccurred()
                                showingAppleSheet = true
                            } label: {
                                HStack {
                                    Image(systemName: "apple.logo")
                                        .font(.title3)
                                    Text("Sign in with Apple")
                                        .font(.system(.body, design: .rounded))
                                        .fontWeight(.semibold)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.primary)
                                .cornerRadius(14)
                            }
                            
                            // Google Sign-In Button
                            Button {
                                generator.impactOccurred()
                                showingGoogleSheet = true
                            } label: {
                                HStack(spacing: 10) {
                                    Image(systemName: "g.circle.fill")
                                        .font(.title3)
                                        .foregroundColor(Color(hex: "#4285F4"))
                                    Text("Continue with Google")
                                        .font(.system(.body, design: .rounded))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.textPrimary)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.cardBackground)
                                .cornerRadius(14)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                                )
                            }
                            
                            // Email Sign-In Button
                            Button {
                                generator.impactOccurred()
                                showingEmailSheet = true
                            } label: {
                                HStack(spacing: 10) {
                                    Image(systemName: "envelope.fill")
                                        .font(.subheadline)
                                        .foregroundColor(.brandPrimary)
                                    Text("Sign in with Email")
                                        .font(.system(.body, design: .rounded))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.brandPrimary)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.brandPrimary.opacity(0.1))
                                .cornerRadius(14)
                            }
                        }
                    } else {
                        // MARK: - Account Actions (If Signed In)
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Account Management")
                                .font(.system(.subheadline, design: .rounded))
                                .fontWeight(.semibold)
                                .foregroundColor(.textSecondary)
                                .padding(.horizontal, 4)
                            
                            VStack(spacing: 8) {
                                // Edit Profile
                                Button {
                                    generator.impactOccurred()
                                    showingEditSheet = true
                                } label: {
                                    HStack {
                                        Image(systemName: "pencil")
                                            .foregroundColor(.brandPrimary)
                                        Text("Edit Profile Details")
                                            .font(.system(.body, design: .rounded))
                                            .foregroundColor(.textPrimary)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(14)
                                    .background(Color.cardBackground)
                                    .cornerRadius(14)
                                }
                                
                                // Switch Account
                                Button {
                                    generator.impactOccurred()
                                    showingEmailSheet = true
                                } label: {
                                    HStack {
                                        Image(systemName: "arrow.triangle.2.circlepath")
                                            .foregroundColor(.brandSecondary)
                                        Text("Switch to Different Account")
                                            .font(.system(.body, design: .rounded))
                                            .foregroundColor(.textPrimary)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(14)
                                    .background(Color.cardBackground)
                                    .cornerRadius(14)
                                }
                                
                                // Prominent Sign Out Button
                                Button {
                                    generator.impactOccurred()
                                    showingSignOutAlert = true
                                } label: {
                                    HStack {
                                        Image(systemName: "rectangle.portrait.and.arrow.right")
                                            .foregroundColor(.red)
                                        Text("Sign Out (\(profileManager.profile.provider.displayName))")
                                            .font(.system(.body, design: .rounded))
                                            .fontWeight(.semibold)
                                            .foregroundColor(.red)
                                        Spacer()
                                    }
                                    .padding(14)
                                    .background(Color.red.opacity(0.08))
                                    .cornerRadius(14)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(Color.red.opacity(0.2), lineWidth: 1)
                                    )
                                }
                            }
                        }
                    }
                    
                    // MARK: - Local Stats Footer
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Account Information")
                            .font(.system(.subheadline, design: .rounded))
                            .fontWeight(.semibold)
                            .foregroundColor(.textSecondary)
                            .padding(.horizontal, 4)
                        
                        VStack(spacing: 0) {
                            ProfileDetailRow(
                                icon: "calendar",
                                title: "Member Since",
                                value: profileManager.profile.joinedDate.formatted(date: .abbreviated, time: .omitted)
                            )
                            Divider()
                            ProfileDetailRow(
                                icon: "externaldrive.fill",
                                title: "Storage Enclave",
                                value: "SwiftData Local DB"
                            )
                        }
                        .background(Color.cardBackground)
                        .cornerRadius(16)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
            .background(Color.appBackground.ignoresSafeArea())
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.brandPrimary)
                }
            }
            .sheet(isPresented: $showingEmailSheet) {
                EmailSignInSheet()
            }
            .sheet(isPresented: $showingAppleSheet) {
                AppleSignInSheet()
            }
            .sheet(isPresented: $showingGoogleSheet) {
                GoogleSignInSheet()
            }
            .sheet(isPresented: $showingEditSheet) {
                EditProfileSheet()
            }
            .alert("Sign Out of Account?", isPresented: $showingSignOutAlert) {
                Button("Sign Out", role: .destructive) {
                    profileManager.signOutToGuest()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("You will be signed out of your \(profileManager.profile.provider.displayName) profile and returned to Guest Mode. All your subscription records remain safely stored on your iPhone.")
            }
        }
    }
}

// MARK: - Profile Detail Row Component
struct ProfileDetailRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.brandPrimary)
                .frame(width: 24)
            Text(title)
                .font(.system(.body, design: .rounded))
                .foregroundColor(.textPrimary)
            Spacer()
            Text(value)
                .font(.system(.body, design: .rounded))
                .foregroundColor(.textSecondary)
        }
        .padding(14)
    }
}

// MARK: - Email Sign In Sheet
struct EmailSignInSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var profileManager = UserProfileManager.shared
    
    @State private var displayName = ""
    @State private var email = ""
    
    var isValid: Bool {
        !displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Enter Details") {
                    TextField("Full Name", text: $displayName)
                        .textContentType(.name)
                        .autocorrectionDisabled()
                    
                    TextField("Email Address", text: $email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                }
                
                Section {
                    Button {
                        profileManager.signInWithEmail(displayName: displayName, email: email)
                        dismiss()
                    } label: {
                        Text("Sign In")
                            .frame(maxWidth: .infinity)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .disabled(!isValid)
                    .listRowBackground(
                        LinearGradient(
                            colors: [Color(hex: "#FF6B6B"), Color(hex: "#4ECDC4")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                } footer: {
                    Text("Your credentials are stored 100% locally on your device.")
                        .font(.system(.caption, design: .rounded))
                }
            }
            .navigationTitle("Sign in with Email")
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

// MARK: - Edit Profile Sheet
struct EditProfileSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var profileManager = UserProfileManager.shared
    
    @State private var displayName = ""
    @State private var email = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Update Profile") {
                    TextField("Display Name", text: $displayName)
                    TextField("Email Address", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                Section {
                    Button("Save Changes") {
                        profileManager.updateProfile(displayName: displayName, email: email)
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .fontWeight(.semibold)
                    .foregroundColor(.brandPrimary)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                displayName = profileManager.profile.displayName
                email = profileManager.profile.email
            }
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
