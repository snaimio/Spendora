//
//  NextChargeCard.swift
//  Spendora
//

import SwiftUI

struct NextChargeCard: View {
    let subscription: Subscription
    
    var daysUntilBilling: Int {
        Calendar.current.dateComponents([.day], from: Date(), to: subscription.nextBillingDate).day ?? 0
    }
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(spacing: 4) {
                Text(getMonthAbbreviation())
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
                
                Text(getDayString())
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            .frame(width: 60, height: 60)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Next Charge")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(subscription.displayName)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                HStack(spacing: 8) {
                    Text(subscription.monthlyCost, format: .currency(code: "USD"))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .foregroundColor(.secondary)
                    
                    Text(daysUntilBilling == 0 ? "Today" : "In \(daysUntilBilling) days")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(daysUntilBilling <= 3 ? .orange : .secondary)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .padding(.horizontal)
        .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(daysUntilBilling <= 3 ? Color.orange.opacity(0.3) : Color.clear, lineWidth: 1)
        )
    }
    
    private func getMonthAbbreviation() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: subscription.nextBillingDate).uppercased()
    }
    
    private func getDayString() -> String {
        let day = Calendar.current.component(.day, from: subscription.nextBillingDate)
        return "\(day)"
    }
}
