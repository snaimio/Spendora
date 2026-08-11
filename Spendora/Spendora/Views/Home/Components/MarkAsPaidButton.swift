//
//  MarkAsPaidButton.swift
//  Spendora
//

import SwiftUI
import SwiftData

// MARK: - MarkAsPaidButton (Apple Native Action Pill with Undo)

/**
 `MarkAsPaidButton` provides a 1-tap subscription payment logger and undoer
 with interactive scale feedback, clear button affordance, and instant date updates.
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
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(.systemGreen))
                    
                    Text("Paid")
                        .font(.caption2.weight(.semibold))
                        .foregroundColor(Color(.systemGreen))
                    
                    Text("· Undo")
                        .font(.caption2.weight(.medium))
                        .foregroundColor(Color(.secondaryLabel))
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color(.systemGreen).opacity(0.12))
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(Color(.systemGreen).opacity(0.25), lineWidth: 0.8)
                )
            }
            .buttonStyle(PressablePillStyle())
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
                        .font(.system(size: 11, weight: .semibold))
                    
                    Text("Record Payment")
                        .font(.caption2.weight(.semibold))
                }
                .foregroundColor(SpendoraTheme.accentText)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(SpendoraTheme.accentTint)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(SpendoraTheme.accent.opacity(0.25), lineWidth: 0.8)
                )
            }
            .buttonStyle(PressablePillStyle())
        }
    }
}

// MARK: - PressablePillStyle (Apple Responsive Feedback)

private struct PressablePillStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.93 : 1.0)
            .opacity(configuration.isPressed ? 0.85 : 1.0)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}
