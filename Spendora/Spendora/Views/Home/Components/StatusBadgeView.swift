//
//  StatusBadgeView.swift
//  Spendora
//

import SwiftUI

// MARK: - StatusBadgeView (Apple Semantic Status Badge with Sage Teal)

struct StatusBadgeView: View {
    let daysUntil: Int
    var isCancelled: Bool = false

    var badgeColor: Color {
        if isCancelled {
            return Color(.secondaryLabel)
        } else if daysUntil < 0 {
            return Color(.systemRed)
        } else if daysUntil <= 3 {
            return Color(.systemOrange)
        } else if daysUntil <= 7 {
            return Color(hex: "F59E0B")
        } else {
            return SpendoraTheme.accent
        }
    }

    var badgeTextColor: Color {
        if isCancelled {
            return Color(.secondaryLabel)
        } else if daysUntil < 0 {
            return Color(.systemRed)
        } else if daysUntil <= 3 {
            return Color(.systemOrange)
        } else if daysUntil <= 7 {
            return Color(hex: "D97706")
        } else {
            return SpendoraTheme.accentText
        }
    }

    var badgeText: String {
        if isCancelled {
            return "Cancelled"
        } else if daysUntil < 0 {
            return "Overdue"
        } else if daysUntil == 0 {
            return "Due Today"
        } else {
            return "Next in \(daysUntil)d"
        }
    }

    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(badgeColor)
                .frame(width: 6, height: 6)
            
            Text(badgeText)
                .font(.caption.weight(.semibold))
                .foregroundColor(badgeTextColor)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(badgeColor.opacity(0.12))
        .clipShape(Capsule())
    }
}
