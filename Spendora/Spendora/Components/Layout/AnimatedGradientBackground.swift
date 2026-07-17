//
//  AnimatedGradientBackground.swift
//  Spendora
//

import SwiftUI

struct AnimatedGradientBackground: View {
    @State private var animate = false

    var body: some View {
        LinearGradient(
            colors: [
                Color.brandPrimary.opacity(animate ? 0.12 : 0.05),
                Color.brandSecondary.opacity(animate ? 0.05 : 0.12)
            ],
            startPoint: animate ? .topLeading : .bottomTrailing,
            endPoint: animate ? .bottomTrailing : .topLeading
        )
        .ignoresSafeArea()
        .animation(
            .easeInOut(duration: 5)
                .repeatForever(autoreverses: true),
            value: animate
        )
        .onAppear {
            animate = true
        }
    }
}
