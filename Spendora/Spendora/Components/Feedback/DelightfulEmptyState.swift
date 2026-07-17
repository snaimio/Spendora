//
//  DelightfulEmptyState.swift
//  Spendora
//

import SwiftUI

struct DelightfulEmptyState: View {
    @State private var bounce = false
    @State private var rotate = false

    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(Color.brandPrimary.opacity(0.1))
                    .frame(width: 100, height: 100)
                    .scaleEffect(bounce ? 1.1 : 0.9)

                Image(systemName: "creditcard.and.123")
                    .font(.system(size: 44))
                    .foregroundStyle(Color.brandPrimary)
                    .rotationEffect(.degrees(rotate ? 10 : -10))
            }
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 1)
                        .repeatForever(autoreverses: true)
                ) {
                    bounce.toggle()
                }

                withAnimation(
                    .easeInOut(duration: 2)
                        .repeatForever(autoreverses: true)
                ) {
                    rotate.toggle()
                }
            }

            Text("No Subscriptions Yet")
                .font(.title2)
                .fontWeight(.bold)

            Text("Tap the + button to add your first subscription and start tracking")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}
