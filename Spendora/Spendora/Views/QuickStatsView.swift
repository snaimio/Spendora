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
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [color.opacity(0.12), color.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.headline)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [color, color.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.secondary)
                    .tracking(0.3)
                
                Text(value)
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.bold)
                    .contentTransition(.numericText())
            }
            
            Spacer()
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
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

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        QuickStatsView(count: 3, totalMonthly: 45.99, totalYearly: 551.88)
        QuickStatsView(count: 0, totalMonthly: 0, totalYearly: 0)
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
