//
//  NextChargeCard.swift
//  Spendora
//
//  Created by Sheikh Naim on 2026-06-19.
//

import SwiftUI

struct NextChargeCard: View {
    let subscription: Subscription

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Next Charge")
                .font(.caption)
                .foregroundColor(.secondary)

            HStack {
                // Category Color Indicator
                Circle()
                    .fill(categoryColor)
                    .frame(width: 12, height: 12)

                Text(subscription.displayName)
                    .font(.headline)
                    .foregroundColor(.primary)

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(String(format: "$%.2f", subscription.monthlyCost))
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    Text(subscription.formattedNextBillingDate)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                )
        )
    }

    // MARK: - Category Color

    private var categoryColor: Color {
        switch subscription.category {
        case "Entertainment":
            return .categoryEntertainment

        case "Productivity":
            return .categoryProductivity

        case "Health & Fitness":
            return .categoryHealth

        case "Shopping":
            return .categoryShopping

        case "Food & Dining":
            return .categoryFood

        case "Education":
            return .categoryEducation

        default:
            return .categoryOther
        }
    }
}

// MARK: - Preview

#Preview {
    let sample = Subscription(
        name: "Netflix",
        cost: 15.99,
        isYearly: false,
        nextBillingDate: Date().addingTimeInterval(86400 * 5),
        category: SubscriptionCategory.entertainment.rawValue,
        colorHex: "#FF6B6B"
    )

    return NextChargeCard(subscription: sample)
        .padding()
        .background(Color(.systemGroupedBackground))
}
