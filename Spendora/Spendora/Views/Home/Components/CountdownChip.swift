//
//  CountdownChip.swift
//  Spendora
//

import SwiftUI

// MARK: - CountdownChip

/**
 `CountdownChip` renders a status badge on its own dedicated row below card details:
 - Red (#FF6B6B) if Due Today or Overdue
 - Gold/Amber (#FFD93D) if Due within 7 Days
 - Mint Green (#00D4AA) if Paid / Safe (> 7 Days)
 */
struct CountdownChip: View {
    let daysRemaining: Int
    
    private var isSafePaid: Bool {
        daysRemaining > 7
    }
    
    private var badgeColor: Color {
        if daysRemaining < 0 {
            return Color.brandDanger       // Overdue Red (#FF6B6B)
        } else if daysRemaining == 0 {
            return Color.brandDanger       // Due Today Red
        } else if daysRemaining <= 7 {
            return Color.brandWarning      // Soon Gold (#FFD93D)
        } else {
            return Color(hex: "#D4AF37")     // Safe Paid Signature Gold/Brass (#D4AF37)
        }
    }
    
    private var badgeText: String {
        if daysRemaining < 0 {
            return "Overdue (\(abs(daysRemaining))d)"
        } else if daysRemaining == 0 {
            return "Due Today"
        } else if daysRemaining == 1 {
            return "Due in 1 day"
        } else if daysRemaining <= 7 {
            return "Due in \(daysRemaining) days"
        } else {
            return "Paid • Next in \(daysRemaining)d"
        }
    }
    
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: isSafePaid ? "checkmark.circle.fill" : "clock.fill")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(badgeColor)
            
            Text(badgeText)
                .font(AppStyles.Typography.caption2)
                .foregroundColor(badgeColor)
                .lineLimit(1)
        }
        .padding(.horizontal, 9)
        .padding(.vertical, 4)
        .background(badgeColor.opacity(0.14))
        .cornerRadius(8)
    }
}
