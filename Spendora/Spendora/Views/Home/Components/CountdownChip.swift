//
//  CountdownChip.swift
//  Spendora
//

import SwiftUI

// MARK: - CountdownChip

/**
 `CountdownChip` renders an adaptive status badge with Spendora Teal brand system colors:
 - Success / Safe (> 7 Days): Spendora Teal (#00D4AA)
 - Warning / Due Soon (1-7 Days): Gold Warning (#FFD93D)
 - Danger / Overdue / Due Today: Coral Red (#FF6B6B)
 - Cancelled / Inactive: Coral Red (#FF6B6B)
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
            return colorScheme == .dark ? Color(hex: "#FF6B6B") : Color(hex: "#DC2626")
        } else if daysRemaining <= 0 {
            // Overdue / Due Today Red
            return colorScheme == .dark ? Color(hex: "#FF6B6B") : Color(hex: "#DC2626")
        } else if daysRemaining <= 7 {
            // Due Soon Gold
            return colorScheme == .dark ? Color(hex: "#FFD93D") : Color(hex: "#B45309")
        } else {
            // Safe Paid Spendora Teal
            return colorScheme == .dark ? Color(hex: "#00D4AA") : Color(hex: "#059669")
        }
    }
    
    private var badgeBgColor: Color {
        if isCancelled {
            return colorScheme == .dark ? Color(hex: "#FF6B6B").opacity(0.18) : Color(hex: "#FEE2E2")
        } else if daysRemaining <= 0 {
            return colorScheme == .dark ? Color(hex: "#FF6B6B").opacity(0.22) : Color(hex: "#FEE2E2")
        } else if daysRemaining <= 7 {
            return colorScheme == .dark ? Color(hex: "#FFD93D").opacity(0.22) : Color(hex: "#FEF3C7")
        } else {
            return colorScheme == .dark ? Color(hex: "#00D4AA").opacity(0.18) : Color(hex: "#D1FAE5")
        }
    }

    private var badgeBorderColor: Color {
        if isCancelled {
            return colorScheme == .dark ? Color(hex: "#FF6B6B").opacity(0.35) : Color(hex: "#FCA5A5")
        } else if daysRemaining <= 0 {
            return colorScheme == .dark ? Color(hex: "#FF6B6B").opacity(0.4) : Color(hex: "#FCA5A5")
        } else if daysRemaining <= 7 {
            return colorScheme == .dark ? Color(hex: "#FFD93D").opacity(0.4) : Color(hex: "#FDE68A")
        } else {
            return colorScheme == .dark ? Color(hex: "#00D4AA").opacity(0.35) : Color(hex: "#A7F3D0")
        }
    }
    
    private var badgeText: String {
        if isCancelled {
            return "Cancelled • Inactive"
        } else if daysRemaining < 0 {
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
            Image(systemName: isCancelled ? "xmark.circle.fill" : (isSafePaid ? "checkmark.circle.fill" : "clock.fill"))
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(badgeTextColor)
            
            Text(badgeText)
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundColor(badgeTextColor)
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
        }
        .padding(.horizontal, 9)
        .padding(.vertical, 4)
        .background(badgeBgColor)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(badgeBorderColor, lineWidth: 1)
        )
    }
}
