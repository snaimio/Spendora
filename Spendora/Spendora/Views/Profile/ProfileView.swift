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
                    ProfileHeaderCardView()
                    
                    // MARK: - Privacy Guarantee Card
                    PrivacyGuaranteeCardView()
                    
                    // MARK: - Sign In Options (If Guest)
                    if profileManager.profile.isGuest {
                        ProfileSignInOptionsCard(
                            onApple: { showingAppleSheet = true },
                            onGoogle: { showingGoogleSheet = true },
                            onEmail: { showingEmailSheet = true }
                        )
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
