//
//  CountdownChip.swift
//  Spendora
//

import SwiftUI

// MARK: - CountdownChip (Fintech Status Badge Pill)

/**
 `CountdownChip` renders a refined 6pt capsule status pill:
 - Paid / Safe (> 7 Days): Emerald tint (12% opacity) with #10B981 / #34D399 text
 - Due Soon (1-7 Days): Amber tint (12% opacity) with #F59E0B / #FBBF24 text
 - Overdue / Due Today: Red tint (12% opacity) with #EF4444 / #F87171 text
 - Cancelled / Paused: Slate tint (12% opacity) with #64748B / #94A3B8 text
 */
struct CountdownChip: View {
    let daysRemaining: Int
    var isCancelled: Bool = false
    @Environment(\.colorScheme) private var colorScheme
    
    private var isSafePaid: Bool {
        daysRemaining > 7 && !isCancelled
    }
    
    private var badgeTextColor: Color {
        if isCancelled {
            return colorScheme == .dark ? Color(hex: "#94A3B8") : Color(hex: "#64748B")
        } else if daysRemaining <= 0 {
            return colorScheme == .dark ? Color(hex: "#F87171") : Color(hex: "#DC2626")
        } else if daysRemaining <= 7 {
            return colorScheme == .dark ? Color(hex: "#FBBF24") : Color(hex: "#D97706")
        } else {
            return colorScheme == .dark ? Color(hex: "#34D399") : Color(hex: "#059669")
        }
    }
    
    private var badgeBgColor: Color {
        if isCancelled {
            return Color(hex: "#64748B").opacity(0.12)
        } else if daysRemaining <= 0 {
            return Color(hex: "#EF4444").opacity(0.12)
        } else if daysRemaining <= 7 {
            return Color(hex: "#F59E0B").opacity(0.12)
        } else {
            return Color(hex: "#10B981").opacity(0.12)
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
                .foregroundColor(badgeTextColor)
            
            Text(badgeText)
                .font(AppStyles.Typography.label)
                .foregroundColor(badgeTextColor)
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 3)
        .background(badgeBgColor)
        .clipShape(RoundedRectangle(cornerRadius: AppStyles.Radius.small, style: .continuous))
    }
}
