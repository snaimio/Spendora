//
//  AppleSignInSheet.swift
//

/**
 * Main/Core Functions & Purpose:
 * AppleSignInSheet modal view handling Apple ID authentication flows.
 * Supports Apple ID Hide My Email private relay features (`@privaterelay.appleid.com`),
 * updating active user profile state while maintaining offline device privacy.
 */

import SwiftUI
import AuthenticationServices


// MARK: - AppleSignInSheet

/**
 `AppleSignInSheet` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for applesigninsheet handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `AppleSignInSheet` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct AppleSignInSheet: View {

    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var profileManager = UserProfileManager.shared
    
    // User profile state variables
    @State private var displayName = "Apple User"
    @State private var useHideMyEmail = true
    @State private var customEmail = "user@privaterelay.appleid.com"
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()
                
                // Apple ID Icon
                ZStack {
                    Circle()
                        .fill(Color.primary.opacity(0.1))
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "apple.logo")
                        .font(.system(size: 44, weight: .semibold))
                        .foregroundColor(.primary)
                }
                
                VStack(spacing: 6) {
                    Text("Sign in with Apple ID")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.textPrimary)
                    
                    Text("Use your Apple ID to sign in to Spendora with 100% on-device privacy.")
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                
                // Details Card
                VStack(spacing: 14) {
                    HStack {
                        Text("Name")
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(.textSecondary)
                        Spacer()
                        TextField("Full Name", text: $displayName)
                            .multilineTextAlignment(.trailing)
                            .font(.system(.body, design: .rounded))
                            .fontWeight(.semibold)
                    }
                    
                    Divider()
                    
                    Toggle(isOn: $useHideMyEmail) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Hide My Email")
                                .font(.system(.body, design: .rounded))
                                .fontWeight(.semibold)
                            Text("Forward to user@icloud.com")
                                .font(.system(.caption, design: .rounded))
                                .foregroundColor(.textSecondary)
                        }
                    }
                    
                    if !useHideMyEmail {
                        Divider()
                        HStack {
                            Text("Share Email")
                                .font(.system(.body, design: .rounded))
                                .foregroundColor(.textSecondary)
                            Spacer()
                            TextField("Email", text: $customEmail)
                                .multilineTextAlignment(.trailing)
                                .font(.system(.body, design: .rounded))
                        }
                    }
                }
                .padding(16)
                .background(Color.cardBackground)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
                .padding(.horizontal, 16)
                
                Spacer()
                
                // Confirm Button
                Button {
                    let finalEmail = useHideMyEmail ? "s.naim@privaterelay.appleid.com" : customEmail
                    profileManager.signInWithApple(displayName: displayName, email: finalEmail)
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "apple.logo")
                            .font(.title3)
                        Text("Continue with Apple ID")
                            .font(.system(.body, design: .rounded))
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color.primary)
                    .cornerRadius(14)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }
            .background(Color.appBackground.ignoresSafeArea())
            .navigationTitle("Apple ID")
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
