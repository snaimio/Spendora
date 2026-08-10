//
//  CountdownChip.swift
//  Spendora
//

import SwiftUI

// MARK: - CountdownChip (60-30-10 Semantic Status Badge)

struct CountdownChip: View {
    let daysRemaining: Int
    var isCancelled: Bool = false
    
    private var badgeColor: Color {
        if isCancelled {
            return SpendoraTheme.Colors.cancelled
        } else if daysRemaining <= 0 {
            return SpendoraTheme.Colors.danger    // Vivid Red #FF4757
        } else if daysRemaining <= 7 {
            return SpendoraTheme.Colors.warning   // Warm Orange #FFB347
        } else {
            return SpendoraTheme.Colors.success   // Mint #00C9A7
        }
    }
    
    private var badgeIcon: String {
        if isCancelled {
            return "pause.circle.fill"
        } else if daysRemaining < 0 {
            return "exclamationmark.circle.fill"
        } else if daysRemaining == 0 {
            return "flame.fill"
        } else if daysRemaining <= 7 {
            return "clock.fill"
        } else {
            return "checkmark.circle.fill"
        }
    }
    
    private var badgeText: String {
        if isCancelled {
            return "Cancelled"
        } else if daysRemaining < 0 {
            return "Overdue (\(abs(daysRemaining))d)"
        } else if daysRemaining == 0 {
            return "Due Today"
        } else if daysRemaining == 1 {
            return "Due tomorrow"
        } else if daysRemaining <= 7 {
            return "Due in \(daysRemaining) days"
        } else {
            return "Paid • Next in \(daysRemaining)d"
        }
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: badgeIcon)
                .font(.system(size: 9, weight: .semibold))
                .foregroundColor(badgeColor)
            
            Text(badgeText)
                .font(SpendoraTheme.Typography.label)
                .foregroundColor(badgeColor)
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
        }
        .padding(.horizontal, 7)
        .padding(.vertical, 3.5)
        .background(badgeColor.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: SpendoraTheme.Radius.badge, style: .continuous))
    }
}
