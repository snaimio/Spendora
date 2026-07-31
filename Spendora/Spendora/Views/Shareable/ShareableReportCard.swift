//
//  ShareableReportCard.swift
//  Spendora
//

import SwiftUI

struct ShareableReportCard: View {
    let totalMonthly: Double
    let totalYearly: Double
    let subscriptionCount: Int
    let topCategory: String
    let topCategoryAmount: Double
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Premium App Logo
            Image("AppLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 72, height: 72)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .shadow(color: Color(hex: "#FF6B6B").opacity(0.3), radius: 10, x: 0, y: 5)
            
            Text("My Subscription Report")
                .font(.system(.title2, design: .rounded))
                .fontWeight(.bold)
            
            Text(Date().formatted(date: .abbreviated, time: .omitted))
                .font(.system(.caption, design: .rounded))
                .foregroundColor(.secondary)
            
            Divider()
                .padding(.horizontal)
            
            VStack(spacing: 16) {
                ReportStatCard(
                    icon: "dollarsign.circle.fill",
                    title: "Monthly Spending",
                    value: CurrencyManager.shared.format(totalMonthly),
                    color: Color(hex: "#FF6B6B")
                )
                
                ReportStatCard(
                    icon: "calendar",
                    title: "Yearly Spending",
                    value: CurrencyManager.shared.format(totalYearly),
                    color: Color(hex: "#4ECDC4")
                )
                
                ReportStatCard(
                    icon: "number.circle.fill",
                    title: "Active Subscriptions",
                    value: "\(subscriptionCount)",
                    color: Color(hex: "#FFE66D")
                )
                
                if topCategory != "None" {
                    ReportStatCard(
                        icon: "chart.pie.fill",
                        title: "Top Category",
                        value: topCategory,
                        subtitle: CurrencyManager.shared.format(topCategoryAmount),
                        color: Color(hex: "#A8E6CF")
                    )
                }
            }
            .padding(.horizontal, 8)
            
            HStack(spacing: 6) {
                Image("AppLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16, height: 16)
                    .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                
                Text("Tracked with Spendora")
                    .font(.system(.caption2, design: .rounded))
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .frame(width: 350, height: 550)
        .background(Color(.systemBackground))
        .cornerRadius(32)
        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 8)
    }
}

struct ReportStatCard: View {
    let icon: String
    let title: String
    let value: String
    var subtitle: String? = nil
    let color: Color
    
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.12))
                    .frame(width: 36, height: 36)
                
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.bold)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(.caption2, design: .rounded))
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: Color.black.opacity(0.02), radius: 4, x: 0, y: 2)
        )
    }
}
