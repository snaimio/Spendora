//
//  CountdownChip.swift
//

import SwiftUI

// MARK: - CountdownChip

/**
 `CountdownChip` renders a viral urgency pill badge on subscription cards:
 - Red (#FF6B6B) if Due Today or Overdue
 - Amber (#FFD93D) if Due within 7 Days
 - Electric Teal (#00D4AA) if Due in > 30 Days
 */
struct CountdownChip: View {
    let daysRemaining: Int
    
    private var badgeColor: Color {
        if daysRemaining <= 0 {
            return Color(hex: "#FF6B6B")   // Urgent Red
        } else if daysRemaining <= 7 {
            return Color(hex: "#FFD93D")   // Soon Amber
        } else {
            return Color(hex: "#00D4AA")   // Safe Teal
        }
    }
    
    private var badgeText: String {
        if daysRemaining < 0 {
            return "Overdue (\(abs(daysRemaining))d)"
        } else if daysRemaining == 0 {
            return "Due Today"
        } else if daysRemaining == 1 {
            return "In 1 Day"
        } else {
            return "In \(daysRemaining) Days"
        }
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(badgeColor)
                .frame(width: 6, height: 6)
            
            Text(badgeText)
                .font(.system(size: 10, weight: .bold, design: .rounded))
                .foregroundColor(badgeColor)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(badgeColor.opacity(0.16))
        .cornerRadius(10)
    }
}
