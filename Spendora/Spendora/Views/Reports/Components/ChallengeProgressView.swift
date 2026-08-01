//
//  ChallengeProgressView.swift
//

import SwiftUI


// MARK: - ChallengeProgressView

/**
 `ChallengeProgressView` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for challengeprogressview handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `ChallengeProgressView` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct ChallengeProgressView: View {

    // MARK: - Properties

    let percentage: Int  // percentage property
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        VStack(spacing: 12) {
            Text("🏆 Challenges")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("\(percentage)% Complete")
                .font(.headline)
                .foregroundColor(.secondary)
            
            ProgressView(value: Double(percentage), total: 100)
                .progressViewStyle(.linear)
                .tint(.brandPrimary)
                .frame(height: 8)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5)
    }
}
