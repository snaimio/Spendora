/**
 * Main/Core Functions & Purpose:
 * Challenge model definition and ChallengeCard view component displaying savings challenge progress and completion badge.
 */

import SwiftUI

struct Challenge: Identifiable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let isCompleted: Bool
    let color: Color
}

struct ChallengeCard: View {
    let challenge: Challenge
    
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
