//
//  AddSubscriptionSaveButton.swift
//  Spendora
//

import SwiftUI

// MARK: - AddSubscriptionSaveButton

/**
 `AddSubscriptionSaveButton` renders the primary CTA save button styled with Spendora Teal gradient (#00D4AA → #00B4D8).
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
            HStack {
                if isSaving {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Add Subscription")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.system(size: 17, weight: .bold))
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                Group {
                    if isValid {
                        LinearGradient(
                            colors: [Color(hex: "#00D4AA"), Color(hex: "#00B4D8")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    } else {
                        LinearGradient(
                            colors: [Color.gray.opacity(0.4), Color.gray.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    }
                }
            )
            .cornerRadius(16)
            .shadow(color: isValid ? Color(hex: "#00D4AA").opacity(0.4) : .clear, radius: 14, x: 0, y: 6)
        }
        .disabled(!isValid || isSaving)
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }
}
