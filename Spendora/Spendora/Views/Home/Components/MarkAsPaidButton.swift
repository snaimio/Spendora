//
//  MarkAsPaidButton.swift
//  Spendora
//

import SwiftUI

// MARK: - MarkAsPaidButton (Apple Style Action Pill)

/**
 `MarkAsPaidButton` provides a one-tap subscription payment logger
 with Apple-level system feedback and clean styling.
 */
struct MarkAsPaidButton: View {

    // MARK: - Properties

    let subscription: Subscription
    @State private var isPaidThisCycle: Bool = false
    @Environment(\.colorScheme) private var colorScheme
    private let generator = UIImpactFeedbackGenerator(style: .medium)

    // MARK: - Body

    var body: some View {
        Button {
            generator.impactOccurred()
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                subscription.markAsPaid()
                isPaidThisCycle = true
            }
        } label: {
            HStack(spacing: 5) {
                Image(systemName: isPaidThisCycle ? "checkmark" : "arrow.clockwise")
                    .font(.system(size: 11, weight: .semibold))
                
                Text(isPaidThisCycle ? "Paid" : "Log Payment")
                    .font(AppStyles.Typography.micro)
            }
            .foregroundColor(isPaidThisCycle ? .brandSuccess : .brandPrimary)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                (isPaidThisCycle ? Color.brandSuccess : Color.brandPrimary)
                    .opacity(colorScheme == .dark ? 0.16 : 0.10)
            )
            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}
