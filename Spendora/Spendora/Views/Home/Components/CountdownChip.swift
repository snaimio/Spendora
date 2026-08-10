//
//  CountdownChip.swift
//  Spendora
//

import SwiftUI

// MARK: - CountdownChip (Luxury Status Badge)

/**
 `CountdownChip` renders a refined dark-mode status pill container:
 - Paid / Safe (> 7 Days): Dark Emerald container with Subtle Green (#30D158)
 - Due Soon (1-7 Days): Warm Rose-Gold container (#C6A473)
 - Overdue / Due Today: System Red (#FF453A)
 - Cancelled / Paused: Muted Slate (#8E8E93)
 */
struct CountdownChip: View {
    let daysRemaining: Int
    var isCancelled: Bool = false
    
    private var isSafePaid: Bool {
        daysRemaining > 7 && !isCancelled
    }
    
    private var badgeTextColor: Color {
        if isCancelled {
            return Color(hex: "#8E8E93")
        } else if daysRemaining <= 0 {
            return Color(hex: "#FF453A")
        } else if daysRemaining <= 7 {
            return Color(hex: "#C6A473")
        } else {
            return Color(hex: "#30D158")
        }
    }
    
    private var badgeBgColor: Color {
        if isCancelled {
            return Color(hex: "#8E8E93").opacity(0.14)
        } else if daysRemaining <= 0 {
            return Color(hex: "#FF453A").opacity(0.14)
        } else if daysRemaining <= 7 {
            return Color(hex: "#C6A473").opacity(0.14)
        } else {
            return Color(hex: "#30D158").opacity(0.14)
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
        HStack(spacing: 5) {
            Image(systemName: badgeIcon)
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(badgeTextColor)
            
            Text(badgeText)
                .font(AppStyles.Typography.micro)
                .foregroundColor(badgeTextColor)
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(badgeBgColor)
        .clipShape(Capsule())
    }
}
