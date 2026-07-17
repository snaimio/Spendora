//
//  QuickStatsView.swift
//  Spendora
//

import SwiftUI

struct QuickStatsView: View {
    let count: Int
    let totalMonthly: Double
    let totalYearly: Double
    
    var body: some View {
        HStack(spacing: 12) {
            QuickStatsStatCard(
                icon: "calendar",
                title: "Yearly",
                value: CurrencyManager.shared.format(totalYearly),
                color: .brandPrimary
            )
            
            QuickStatsStatCard(
                icon: "chart.bar.fill",
                title: "Average",
                value: CurrencyManager.shared.format(count > 0 ? totalMonthly / Double(count) : 0),
                color: .brandAccent
            )
        }
    }
}

struct QuickStatsStatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [color.opacity(0.12), color.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 32, height: 32)
                
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [color, color.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.system(.caption2, design: .rounded))
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            
            Spacer(minLength: 4)
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
        )
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        .onTapGesture {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            withAnimation {
                isPressed = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isPressed = false
                }
            }
        }
    }
}
