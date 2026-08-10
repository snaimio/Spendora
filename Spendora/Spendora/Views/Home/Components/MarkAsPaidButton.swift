//
//  MarkAsPaidButton.swift
//  Spendora
//

import SwiftUI
import UIKit

// MARK: - MarkAsPaidButton

/**
 `MarkAsPaidButton` provides bill payment recording styled with Spendora Teal and Gold gradients.
 */
struct MarkAsPaidButton: View {
    @Bindable var subscription: Subscription
    @State private var isPaymentLogged = false
    
    private var formattedCost: String {
        CurrencyManager.shared.format(subscription.isOneTime ? subscription.cost : subscription.monthlyCost)
    }

    var body: some View {
        Group {
            if isPaymentLogged {
                Menu {
                    Button(role: .destructive) {
                        undoPayment()
                    } label: {
                        Label("Undo Payment (Revert Date)", systemImage: "arrow.uturn.backward.circle")
                    }
                    
                    Button {
                        recordPayment()
                    } label: {
                        Label("Log Next Cycle (\(formattedCost))", systemImage: "plus.circle")
                    }
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 13, weight: .bold))
                        
                        Text("Paid (\(formattedCost))")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 10, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(
                        LinearGradient(
                            colors: [Color(hex: "#00D4AA"), Color(hex: "#00B4D8")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                    .shadow(color: Color(hex: "#00D4AA").opacity(0.3), radius: 4, x: 0, y: 2)
                }
            } else {
                Button {
                    recordPayment()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "creditcard.fill")
                            .font(.system(size: 13, weight: .bold))
                        
                        Text("Log Payment (\(formattedCost))")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                    .foregroundColor(Color(hex: "#0F0F1A"))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(
                        LinearGradient(
                            colors: [Color(hex: "#FFD93D"), Color(hex: "#FF8A5C")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                    .shadow(color: Color(hex: "#FFD93D").opacity(0.3), radius: 4, x: 0, y: 2)
                }
                .buttonStyle(.plain)
            }
        }
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
    
    private func undoPayment() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        // Revert billing date back by 1 cycle
        let calendar = Calendar.current
        if subscription.isYearly {
            if let prevDate = calendar.date(byAdding: .year, value: -1, to: subscription.nextBillingDate) {
                subscription.nextBillingDate = prevDate
            }
        } else {
            if let prevDate = calendar.date(byAdding: .month, value: -1, to: subscription.nextBillingDate) {
                subscription.nextBillingDate = prevDate
            }
        }
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
            isPaymentLogged = false
        }
    }
}
