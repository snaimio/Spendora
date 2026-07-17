//
//  EmptyStateView.swift
//  Spendora
//
//  Created by Sheikh Naim on 2026-06-19.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "tray")
                .font(.system(size: 48))
                .foregroundColor(.secondary)

            Text("No subscriptions yet")
                .font(.headline)
                .foregroundColor(.primary)

            Text("Tap the + button to add your first subscription")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 60)
        .padding(.horizontal, 32)
    }
}

// MARK: - Preview

#Preview {
    EmptyStateView()
}
