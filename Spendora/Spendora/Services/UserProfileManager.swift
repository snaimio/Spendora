import Foundation
import SwiftUI
import Combine

/**
 UserProfileManager singleton class managing user profile state and authentication flows.
 Implements ObservableObject so SwiftUI views update automatically when the active profile changes.
 All user credentials and preferences are saved strictly to local UserDefaults to maintain offline privacy.
*/
class UserProfileManager: ObservableObject {
    /// Shared singleton instance for app-wide profile management
    static let shared = UserProfileManager()
    
    /// Active user profile. Triggers saveProfile() automatically whenever modified.
    @Published var profile: UserProfile {
        didSet {
            saveProfile()
        }
    }
    
    /// Key used for storing JSON encoded UserProfile in UserDefaults
    private let userDefaultsKey = "spendora_user_profile_data"
    
    /// Private initializer that restores saved user profile from UserDefaults or defaults to Guest Mode
    private init() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode(UserProfile.self, from: savedData) {
            self.profile = decoded
        } else {
            self.profile = .defaultGuest
        }
    }
    
    /// Serializes the active UserProfile object into JSON data and persists it locally
    private func saveProfile() {
        if let encoded = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    /// Signs in the user using a custom name and email address
    func signInWithEmail(displayName: String, email: String) {
        let cleanName = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        self.profile = UserProfile(
            displayName: cleanName.isEmpty ? "Spendora Member" : cleanName,
            email: cleanEmail.isEmpty ? "user@spendora.local" : cleanEmail,
            provider: .email,
            isGuest: false,
            joinedDate: Date(),
            avatarColorHex: "#4ECDC4"
        )
    }
    
    /// Sets active user profile credentials after authenticating via Apple ID
    func signInWithApple(displayName: String? = nil, email: String? = nil) {
        let name = displayName ?? "Apple Member"
        let mail = email ?? "user@privaterelay.appleid.com"
        
        self.profile = UserProfile(
            displayName: name,
            email: mail,
            provider: .apple,
            isGuest: false,
            joinedDate: Date(),
            avatarColorHex: "#FF6B6B"
        )
    }
    
    /// Sets active user profile credentials after selecting a Google Account
    func signInWithGoogle(displayName: String? = nil, email: String? = nil) {
        let name = displayName ?? "Google Member"
        let mail = email ?? "user@gmail.com"
        
        self.profile = UserProfile(
            displayName: name,
            email: mail,
            provider: .google,
            isGuest: false,
            joinedDate: Date(),
            avatarColorHex: "#4285F4"
        )
    }
    
    /// Updates display name and email address for the logged-in profile
    func updateProfile(displayName: String, email: String) {
        profile.displayName = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        profile.email = email.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Signs out the active user and restores the default Guest Mode profile
    func signOutToGuest() {
        self.profile = .defaultGuest
    }
}
