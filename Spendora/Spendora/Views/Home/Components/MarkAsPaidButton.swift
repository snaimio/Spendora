//
//  MarkAsPaidButton.swift
//

import SwiftUI
import UIKit

// MARK: - MarkAsPaidButton

/**
 `MarkAsPaidButton` provides Subby's signature 1-tap "Mark as Paid" feature:
 - Advances the subscription's next billing date by 1 month (or 1 year if yearly)
 - Plays tactile haptic feedback
 - Shows visual checkmark confirmation animation
 */
struct MarkAsPaidButton: View {
    @Bindable var subscription: Subscription
    @State private var isPaidConfirmed = false
    
    var body: some View {
        Button {
            markAsPaid()
        } label: {
            HStack(spacing: 4) {
                Image(systemName: isPaidConfirmed ? "checkmark.circle.fill" : "creditcard.circle")
                    .font(.system(size: 13, weight: .bold))
                
                Text(isPaidConfirmed ? "Paid!" : "Mark Paid")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
            }
            .foregroundColor(isPaidConfirmed ? .white : Color(hex: "#00D4AA"))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                isPaidConfirmed
                    ? Color(hex: "#00D4AA")
                    : Color(hex: "#00D4AA").opacity(0.14)
            )
            .cornerRadius(12)
            .scaleEffect(isPaidConfirmed ? 1.05 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPaidConfirmed)
        }
        .buttonStyle(.plain)
    }
    
    private func markAsPaid() {
        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            isPaidConfirmed = true
        }
        
        // Advance billing date
        let calendar = Calendar.current
        if subscription.isYearly {
            if let nextDate = calendar.date(byAdding: .year, value: 1, to: subscription.nextBillingDate) {
                subscription.nextBillingDate = nextDate
            }
        } else {
            if let nextDate = calendar.date(byAdding: .month, value: 1, to: subscription.nextBillingDate) {
                subscription.nextBillingDate = nextDate
            }
        }
        
        // Reset confirmation visual after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            withAnimation {
                isPaidConfirmed = false
            }
        }
    }
}
