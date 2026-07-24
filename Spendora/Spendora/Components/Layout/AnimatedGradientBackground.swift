//
//  AnimatedGradientBackground.swift
//  Spendora
//

import SwiftUI

struct AnimatedGradientBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            // Primary animated gradient
            LinearGradient(
                colors: [
                    Color.brandPrimary.opacity(animate ? 0.12 : 0.05),
                    Color.brandSecondary.opacity(animate ? 0.05 : 0.12),
                    Color.brandAccent.opacity(animate ? 0.03 : 0.06)
                ],
                startPoint: animate ? .topLeading : .bottomTrailing,
                endPoint: animate ? .bottomTrailing : .topLeading
            )
            .ignoresSafeArea()
            .animation(
                .easeInOut(duration: 6)
                    .repeatForever(autoreverses: true),
                value: animate
            )
            
            // Secondary subtle pattern overlay
            RadialGradient(
                colors: [
                    Color.brandPrimary.opacity(0.03),
                    Color.clear
                ],
                center: animate ? .topTrailing : .bottomLeading,
                startRadius: 0,
                endRadius: 400
            )
            .ignoresSafeArea()
            .animation(
                .easeInOut(duration: 8)
                    .repeatForever(autoreverses: true),
                value: animate
            )
        }
        .onAppear {
            animate = true
        }
    }
}
