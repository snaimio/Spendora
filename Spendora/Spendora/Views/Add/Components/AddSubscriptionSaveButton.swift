//
//  AddSubscriptionSaveButton.swift
//  Spendora
//

import SwiftUI

struct AddSubscriptionSaveButton: View {
    let isValid: Bool
    let isSaving: Bool
    let action: () -> Void
    
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
                        .font(.system(.headline, design: .rounded))
                    Image(systemName: "arrow.right.circle.fill")
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: isValid ? [.brandPrimary, .brandSecondary] : [.gray, .gray.opacity(0.6)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .shadow(color: isValid ? .brandPrimary.opacity(0.3) : .clear, radius: 12, x: 0, y: 4)
        }
        .disabled(!isValid || isSaving)
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
}
