//
//  MarkAsPaidButton.swift
//  Spendora
//

import SwiftUI
import SwiftData

// MARK: - MarkAsPaidButton (Apple Native Action Pill)

/**
 `MarkAsPaidButton` provides a one-tap subscription payment logger
 that advances the billing date, saves to SwiftData, and reschedules alerts.
 */
struct MarkAsPaidButton: View {

    // MARK: - Properties

    let subscription: Subscription
    @State private var isPaidThisCycle: Bool = false
    @Environment(\.modelContext) private var modelContext
    private let generator = UIImpactFeedbackGenerator(style: .medium)

    // MARK: - Body

    var body: some View {
        Button {
            generator.impactOccurred()
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                subscription.markAsPaid()
                try? modelContext.save()
                NotificationService.shared.schedule(for: subscription)
                isPaidThisCycle = true
            }
        } label: {
            HStack(spacing: 5) {
                Image(systemName: isPaidThisCycle ? "checkmark" : "arrow.clockwise")
                    .font(.system(size: 11, weight: .semibold))
                
                Text(isPaidThisCycle ? "Paid" : "Log Payment")
                    .font(.caption2.weight(.semibold))
            }
            .foregroundColor(isPaidThisCycle ? Color(.systemGreen) : SpendoraTheme.accentText)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                isPaidThisCycle
                    ? Color(.systemGreen).opacity(0.12)
                    : SpendoraTheme.accentTint
            )
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
