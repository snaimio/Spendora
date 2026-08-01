//
//  EmailSignInSheet.swift
//

/**
 * Main/Core Functions & Purpose:
 * EmailSignInSheet form modal allowing users to sign in or set up a profile with a custom full name and email address.
 * Validates inputs and updates UserProfileManager locally on device.
 */

import SwiftUI


// MARK: - EmailSignInSheet

/**
 `EmailSignInSheet` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for emailsigninsheet handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `EmailSignInSheet` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct EmailSignInSheet: View {

    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var profileManager = UserProfileManager.shared
    
    @State private var displayName = ""
    @State private var email = ""
    
    var isValid: Bool {  // isValid property
        !displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
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
