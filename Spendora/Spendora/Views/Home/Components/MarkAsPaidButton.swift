//
//  MarkAsPaidButton.swift
//

import SwiftUI
import UIKit

// MARK: - MarkAsPaidButton

/**
 `MarkAsPaidButton` provides a practical billing payment recorder:
 - Displays "Paid for [Month/Year]" (e.g., "Paid for August" or "Paid for 2026") upon recording a payment
 - Advances the next billing date to the upcoming cycle
 - Plays tactile haptic feedback
 */
struct MarkAsPaidButton: View {
    @Bindable var subscription: Subscription
    @State private var isPaidForCurrentCycle = false
    @State private var paidCycleText = ""
    
    private var currentCycleLabel: String {
        let formatter = DateFormatter()
        if subscription.isYearly {
            formatter.dateFormat = "yyyy"
        } else {
            formatter.dateFormat = "MMMM"
        }
        return formatter.string(from: Date())
    }

    var body: some View {
        Button {
            recordPayment()
        } label: {
            HStack(spacing: 6) {
                Image(systemName: isPaidForCurrentCycle ? "checkmark.seal.fill" : "creditcard.circle.fill")
                    .font(.system(size: 13, weight: .bold))
                
                Text(isPaidForCurrentCycle ? "Paid for \(paidCycleText)" : "Mark Paid for \(currentCycleLabel)")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .lineLimit(1)
            }
            .foregroundColor(isPaidForCurrentCycle ? .white : .brandPrimary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                isPaidForCurrentCycle
                    ? Color.brandTertiary
                    : Color.brandPrimary.opacity(0.12)
            )
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
        .onAppear {
            checkIfAlreadyPaid()
        }
    }
    
    private func checkIfAlreadyPaid() {
        // If next billing date is in the future beyond current month/year, mark as paid for current cycle
        let calendar = Calendar.current
        let today = Date()
        if subscription.nextBillingDate > today && !calendar.isDate(subscription.nextBillingDate, equalTo: today, toGranularity: subscription.isYearly ? .year : .month) {
            isPaidForCurrentCycle = true
            paidCycleText = currentCycleLabel
        }
    }

    private func recordPayment() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        let cycleLabel = currentCycleLabel
        paidCycleText = cycleLabel
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            isPaidForCurrentCycle = true
        }
        
        // Advance billing date to next cycle
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
    }
}
