//
//  MarkAsPaidButton.swift
//  Spendora
//

import SwiftUI
import UIKit

// MARK: - MarkAsPaidButton

/**
 `MarkAsPaidButton` provides a practical, clear bill payment recorder:
 - Displays exact dollar cost action: "Log Payment ($24.99)" or "Log Payment ($19.99/mo)"
 - Displays confirmation state: "✓ Payment Logged ($24.99) • Next: Sep 25, 2027"
 - Advances the next billing date to the upcoming cycle
 - Plays tactile haptic feedback
 */
struct MarkAsPaidButton: View {
    @Bindable var subscription: Subscription
    @State private var isPaymentLogged = false
    
    private var formattedCost: String {
        CurrencyManager.shared.format(subscription.isOneTime ? subscription.cost : subscription.monthlyCost)
    }

    var body: some View {
        Button {
            recordPayment()
        } label: {
            HStack(spacing: 6) {
                Image(systemName: isPaymentLogged ? "checkmark.circle.fill" : "creditcard.fill")
                    .font(.system(size: 13, weight: .bold))
                
                Text(isPaymentLogged ? "✓ Paid (\(formattedCost))" : "Log Payment (\(formattedCost))")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .foregroundColor(isPaymentLogged ? .white : Color(hex: "#0F0F1A"))
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                isPaymentLogged
                    ? LinearGradient(
                        colors: [Color(hex: "#D4AF37"), Color(hex: "#B8860B")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    : LinearGradient(
                        colors: [Color(hex: "#FFD93D"), Color(hex: "#F59E0B")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
            )
            .cornerRadius(12)
            .shadow(color: Color(hex: "#F59E0B").opacity(0.3), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(.plain)
        .onAppear {
            checkIfAlreadyPaid()
        }
    }
    
    private func checkIfAlreadyPaid() {
        let calendar = Calendar.current
        let today = Date()
        if subscription.nextBillingDate > today && !calendar.isDate(subscription.nextBillingDate, equalTo: today, toGranularity: subscription.isYearly ? .year : .month) {
            isPaymentLogged = true
        }
    }

    private func recordPayment() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
            isPaymentLogged = true
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
