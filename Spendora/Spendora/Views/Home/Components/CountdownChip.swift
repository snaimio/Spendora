//
//  CountdownChip.swift
//  Spendora
//

import SwiftUI

// MARK: - CountdownChip (Apple System Badge)

/**
 `CountdownChip` renders an Apple HIG status badge with system colors:
 - Safe Paid (> 7 Days): Apple Green (#34C759)
 - Due Soon (1-7 Days): Apple Orange (#FF9500)
 - Overdue / Due Today: Apple Red (#FF3B30)
 - Cancelled / Paused: Apple Gray (#8E8E93)
 */
struct CountdownChip: View {
    let daysRemaining: Int
    var isCancelled: Bool = false
    @Environment(\.colorScheme) private var colorScheme
    
    private var isSafePaid: Bool {
        daysRemaining > 7 && !isCancelled
    }
    
    private var badgeColor: Color {
        if isCancelled {
            return Color.textSecondary
        } else if daysRemaining <= 0 {
            return Color.brandDanger
        } else if daysRemaining <= 7 {
            return Color.brandWarning
        } else {
            return Color.brandSuccess
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
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(badgeColor)
            
            Text(badgeText)
                .font(AppStyles.Typography.micro)
                .foregroundColor(badgeColor)
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 3.5)
        .background(badgeColor.opacity(colorScheme == .dark ? 0.16 : 0.10))
        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
    }
}
