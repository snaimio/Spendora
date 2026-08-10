//
//  AddSubscriptionSaveButton.swift
//  Spendora
//

import SwiftUI

// MARK: - AddSubscriptionSaveButton (Apple Standard Primary Action)

/**
 `AddSubscriptionSaveButton` renders the primary CTA save button styled with Apple's native system blue styling.
 */
struct AddSubscriptionSaveButton: View {

    // MARK: - Properties

    let isValid: Bool
    let isSaving: Bool
    let action: () -> Void

    // MARK: - Body

    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 8) {
                if isSaving {
                    ProgressView()
                        .tint(.white)
                } else {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Save Subscription")
                        .font(AppStyles.Typography.headline)
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(
                isValid
                    ? Color.brandPrimary
                    : Color.secondary.opacity(0.3)
            )
            .clipShape(RoundedRectangle(cornerRadius: AppStyles.Radius.card, style: .continuous))
        }
        .disabled(!isValid || isSaving)
        .padding(.horizontal, AppStyles.Spacing.cardPadding)
        .padding(.top, 8)
    }
}
