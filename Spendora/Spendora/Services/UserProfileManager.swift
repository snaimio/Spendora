//
//  UserProfileManager.swift
//  Spendora
//

import Foundation
import SwiftUI
import Combine

class UserProfileManager: ObservableObject {
    static let shared = UserProfileManager()
    
    @Published var profile: UserProfile {
        didSet {
            saveProfile()
        }
    }
    
    private let userDefaultsKey = "spendora_user_profile_data"
    
    private init() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode(UserProfile.self, from: savedData) {
            self.profile = decoded
        } else {
            self.profile = .defaultGuest
        }
    }
    
    private func saveProfile() {
        if let encoded = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
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
    
    func updateProfile(displayName: String, email: String) {
        profile.displayName = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        profile.email = email.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func signOutToGuest() {
        self.profile = .defaultGuest
    }
}
