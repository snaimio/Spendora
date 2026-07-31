//
//  EmailSignInSheet.swift
//  Spendora
//
//  Capstone 2026 - Mobile Application Development
//  Author: Sheikh Naim
//

/**
 * Main/Core Functions & Purpose:
 * EmailSignInSheet form modal allowing users to sign in or set up a profile with a custom full name and email address.
 * Validates inputs and updates UserProfileManager locally on device.
 */

import SwiftUI

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
