//
//  CountdownChip.swift
//

import SwiftUI

// MARK: - CountdownChip

/**
 `CountdownChip` renders a practical status pill badge on subscription cards:
 - Red (#FF3B30) if Due Today or Overdue
 - Amber (#FF9500) if Due within 7 Days
 - Apple Green (#34C759) with "Paid • Next in Xd" when paid & safe (> 7 days)
 */
struct CountdownChip: View {
    let daysRemaining: Int
    
    private var isSafePaid: Bool {
        daysRemaining > 7
    }
    
    private var badgeColor: Color {
        if daysRemaining < 0 {
            return Color(hex: "#FF3B30")   // Overdue Red
        } else if daysRemaining == 0 {
            return Color(hex: "#FF3B30")   // Due Today Red
        } else if daysRemaining <= 7 {
            return Color(hex: "#FF9500")   // Soon Amber
        } else {
            return Color(hex: "#34C759")   // Paid / Safe Green
        }
    }
    
    private var badgeText: String {
        if daysRemaining < 0 {
            return "Overdue (\(abs(daysRemaining))d)"
        } else if daysRemaining == 0 {
            return "Due Today"
        } else if daysRemaining == 1 {
            return "Due in 1 Day"
        } else if daysRemaining <= 7 {
            return "Due in \(daysRemaining) Days"
        } else {
            return "Paid • Next in \(daysRemaining)d"
        }
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: isSafePaid ? "checkmark.circle.fill" : "clock.fill")
                .font(.system(size: 9, weight: .bold))
                .foregroundColor(badgeColor)
            
            Text(badgeText)
                .font(.system(size: 10, weight: .bold, design: .rounded))
                .foregroundColor(badgeColor)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(badgeColor.opacity(0.14))
        .cornerRadius(10)
    }
}
