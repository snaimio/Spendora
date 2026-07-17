//
//  AnimatedGradientBackground.swift
//  Spendora
//

import SwiftUI

struct AnimatedGradientBackground: View {
    @State private var animate = false
    @State private var scale = false
    
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
            
            // Decorative dots pattern (subtle)
            GeometryReader { geometry in
                let size = geometry.size
                Canvas { context, size in
                    for i in 0..<20 {
                        let x = CGFloat(i) * size.width / 20
                        let y = CGFloat(i * 7 % 20) * size.height / 20
                        let opacity = 0.03 + (sin(CGFloat(i) * 0.5 + Date().timeIntervalSince1970 * 0.1) * 0.02)
                        
                        context.fill(
                            Path(ellipseIn: CGRect(x: x, y: y, width: 4, height: 4)),
                            with: .color(Color.brandPrimary.opacity(opacity))
                        )
                    }
                }
            }
            .ignoresSafeArea()
            .opacity(0.5)
        }
        .onAppear {
            animate = true
        }
    }
}
