//
//  MarkAsPaidButton.swift
//  Spendora
//

import SwiftUI
import SwiftData

// MARK: - MarkAsPaidButton (Apple Native Action Pill with Undo)

/**
 `MarkAsPaidButton` provides a one-tap subscription payment logger and undoer
 that advances the billing date, saves to SwiftData, and reschedules alerts.
 */
struct MarkAsPaidButton: View {

    // MARK: - Properties

    let subscription: Subscription
    @Environment(\.modelContext) private var modelContext
    private let generator = UIImpactFeedbackGenerator(style: .medium)

    // MARK: - Body

    var body: some View {
        if subscription.canUndoPayment {
            // State: Payment recorded, allow Undo
            Button {
                generator.impactOccurred()
                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                    subscription.undoPayment()
                    try? modelContext.save()
                    NotificationService.shared.schedule(for: subscription)
                }
            } label: {
                HStack(spacing: 5) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(Color(.systemGreen))
                    
                    Text("Paid")
                        .font(.caption2.weight(.semibold))
                        .foregroundColor(Color(.systemGreen))
                    
                    Text("· Undo")
                        .font(.caption2.weight(.medium))
                        .foregroundColor(Color(.secondaryLabel))
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color(.systemGreen).opacity(0.12))
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(Color(.systemGreen).opacity(0.2), lineWidth: 0.5)
                )
            }
            .buttonStyle(.plain)
        } else {
            // State: Unpaid, allow Record Payment
            Button {
                generator.impactOccurred()
                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                    subscription.markAsPaid()
                    try? modelContext.save()
                    NotificationService.shared.schedule(for: subscription)
                }
            } label: {
                HStack(spacing: 5) {
                    Image(systemName: "creditcard.fill")
                        .font(.system(size: 10, weight: .semibold))
                    
                    Text("Record Payment")
                        .font(.caption2.weight(.semibold))
                }
                .foregroundColor(SpendoraTheme.accentText)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(SpendoraTheme.accentTint)
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
    }
}
