//
//  EditProfileSheet.swift
//  Spendora
//
//  Capstone 2026 - Mobile Application Development
//  Author: Sheikh Naim
//

/**
 * Main/Core Functions & Purpose:
 * EditProfileSheet form sheet allowing users to modify their existing display name or email address.
 * Updates the UserProfileManager singleton and persists changes locally.
 */

import SwiftUI

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
