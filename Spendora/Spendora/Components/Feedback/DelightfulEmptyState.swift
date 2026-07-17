//
//  DelightfulEmptyState.swift
//  Spendora
//

import SwiftUI

struct DelightfulEmptyState: View {
    @State private var pulse = false
    @State private var rotate = false
    @State private var bounce = false
    
    var body: some View {
        VStack(spacing: 28) {
            // Premium animated icon with gradient
            ZStack {
                // Outer glow ring
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [.brandPrimary.opacity(0.3), .brandSecondary.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(width: 140, height: 140)
                    .scaleEffect(pulse ? 1.05 : 0.95)
                    .opacity(pulse ? 0.5 : 0.8)
                
                // Inner gradient circle
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.brandPrimary.opacity(0.12), .brandSecondary.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 110, height: 110)
                
                // Icon with floating animation
                Image(systemName: "creditcard.and.123")
                    .font(.system(size: 44, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.brandPrimary, .brandSecondary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .rotationEffect(.degrees(rotate ? 5 : -5))
                    .offset(y: bounce ? -6 : 6)
            }
            
            VStack(spacing: 12) {
                Text("No Subscriptions Yet")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                
                Text("Tap the + button to add\nyour first subscription")
                    .font(.system(size: 16, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            
            // Premium action hint
            HStack(spacing: 12) {
                Image(systemName: "sparkles")
                    .font(.caption)
                    .foregroundColor(.brandPrimary)
                
                Text("Start tracking your spending today")
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.secondary)
                
                Image(systemName: "sparkles")
                    .font(.caption)
                    .foregroundColor(.brandPrimary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.brandPrimary.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                LinearGradient(
                                    colors: [.brandPrimary.opacity(0.2), .brandSecondary.opacity(0.1)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
        }
        .padding(.vertical, 60)
        .frame(maxWidth: .infinity)
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                pulse.toggle()
            }
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                rotate.toggle()
            }
            withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                bounce.toggle()
            }
        }
    }
}
