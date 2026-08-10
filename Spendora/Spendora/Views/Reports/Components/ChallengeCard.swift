//
//  ChallengeCard.swift
//  Spendora
//

import SwiftUI

// MARK: - Challenge Model

struct Challenge: Identifiable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let isCompleted: Bool
    let color: Color
}

// MARK: - ChallengeCard (Spendora 60-30-10 System)

/**
 `ChallengeCard` displays an individual gamified financial milestone with 3D elevation and semantic success indicators.
 */
struct ChallengeCard: View {

    // MARK: - Properties

    let challenge: Challenge

    // MARK: - Body

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(
                        challenge.isCompleted
                            ? LinearGradient(colors: [challenge.color, challenge.color.opacity(0.75)], startPoint: .topLeading, endPoint: .bottomTrailing)
                            : LinearGradient(colors: [Color.secondary.opacity(0.18), Color.secondary.opacity(0.08)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .frame(width: 48, height: 48)
                    .shadow(color: challenge.isCompleted ? challenge.color.opacity(0.35) : .clear, radius: 6, y: 3)
                
                Image(systemName: challenge.icon)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(challenge.isCompleted ? .white : .textTertiary)
            }
            
            Text(challenge.title)
                .font(AppStyles.Typography.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
                .lineLimit(1)
            
            Text(challenge.description)
                .font(AppStyles.Typography.caption)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
            
            if challenge.isCompleted {
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 11, weight: .bold))
                    Text("Completed")
                        .font(AppStyles.Typography.micro)
                }
                .foregroundColor(.brandPrimary)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(Color.brandPrimary.opacity(0.15))
                .cornerRadius(AppStyles.Radius.chip)
            }
        }
        .padding(AppStyles.Spacing.cardPadding)
        .frame(height: 155)
        .frame(maxWidth: .infinity)
        .spendora3DCard(cornerRadius: AppStyles.Radius.card)
        .opacity(challenge.isCompleted ? 1.0 : 0.65)
    }
}
