//
//  ChallengeCard.swift
//

/**
 * Main/Core Functions & Purpose:
 * Challenge model definition and ChallengeCard view component displaying savings challenge progress and completion badge.
 */

import SwiftUI


// MARK: - Challenge

/**
 `Challenge` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for challenge handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `Challenge` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct Challenge: Identifiable {

    // MARK: - Properties

    let id: String  // id property
    let title: String  // title property
    let description: String  // description property
    let icon: String  // icon property
    let isCompleted: Bool  // isCompleted property
    let color: Color  // color property
}


// MARK: - ChallengeCard

/**
 `ChallengeCard` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for challengecard handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `ChallengeCard` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct ChallengeCard: View {

    // MARK: - Properties

    let challenge: Challenge  // challenge property
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(challenge.isCompleted ? challenge.color : Color.gray.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: challenge.icon)
                    .font(.title2)
                    .foregroundColor(challenge.isCompleted ? .white : .gray)
            }
            
            Text(challenge.title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            Text(challenge.description)
                .font(.caption2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            if challenge.isCompleted {
                Label("Done", systemImage: "checkmark.circle.fill")
                    .font(.caption2)
                    .foregroundColor(.green)
            }
        }
        .padding()
        .frame(height: 140)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 5)
        .opacity(challenge.isCompleted ? 1 : 0.6)
    }
}
