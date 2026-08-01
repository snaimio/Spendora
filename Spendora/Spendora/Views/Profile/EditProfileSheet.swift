//
//  EditProfileSheet.swift
//

/**
 * Main/Core Functions & Purpose:
 * EditProfileSheet form sheet allowing users to modify their existing display name or email address.
 * Updates the UserProfileManager singleton and persists changes locally.
 */

import SwiftUI


// MARK: - EditProfileSheet

/**
 `EditProfileSheet` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for editprofilesheet handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `EditProfileSheet` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct EditProfileSheet: View {

    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var profileManager = UserProfileManager.shared
    
    @State private var displayName = ""
    @State private var email = ""
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
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
