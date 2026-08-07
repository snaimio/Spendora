//
//  CountdownChip.swift
//  Spendora
//

import SwiftUI

// MARK: - CountdownChip

/**
 `CountdownChip` renders an adaptive status badge on its own dedicated row below card details:
 - High-contrast text colors in both Light & Dark modes to eliminate eye strain
 - Overdue / Due Today: Crimson Red (#DC2626 Light / #FF6B6B Dark)
 - Due in 1-7 Days: Deep Warm Amber (#C2410C Light / #F59E0B Dark)
 - Paid / Safe (> 7 Days): Rich Gold/Brass (#9A3412 Light / #D4AF37 Dark)
 */
struct CountdownChip: View {
    let daysRemaining: Int
    @Environment(\.colorScheme) private var colorScheme
    
    private var isSafePaid: Bool {
        daysRemaining > 7
    }
    
    private var badgeTextColor: Color {
        if daysRemaining <= 0 {
            // Overdue / Due Today Red
            return colorScheme == .dark ? Color(hex: "#FF6B6B") : Color(hex: "#DC2626")
        } else if daysRemaining <= 7 {
            // Due Soon Amber (High contrast dark amber in light mode)
            return colorScheme == .dark ? Color(hex: "#F59E0B") : Color(hex: "#C2410C")
        } else {
            // Safe Paid Signature Gold/Brass
            return colorScheme == .dark ? Color(hex: "#D4AF37") : Color(hex: "#B45309")
        }
    }
    
    private var badgeBgColor: Color {
        if daysRemaining <= 0 {
            return colorScheme == .dark ? Color(hex: "#FF6B6B").opacity(0.22) : Color(hex: "#FEE2E2")
        } else if daysRemaining <= 7 {
            return colorScheme == .dark ? Color(hex: "#F59E0B").opacity(0.22) : Color(hex: "#FFEDD5")
        } else {
            return colorScheme == .dark ? Color(hex: "#D4AF37").opacity(0.22) : Color(hex: "#FEF3C7")
        }
    }

    private var badgeBorderColor: Color {
        if daysRemaining <= 0 {
            return colorScheme == .dark ? Color(hex: "#FF6B6B").opacity(0.4) : Color(hex: "#FCA5A5")
        } else if daysRemaining <= 7 {
            return colorScheme == .dark ? Color(hex: "#F59E0B").opacity(0.4) : Color(hex: "#FDBA74")
        } else {
            return colorScheme == .dark ? Color(hex: "#D4AF37").opacity(0.4) : Color(hex: "#FDE68A")
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
