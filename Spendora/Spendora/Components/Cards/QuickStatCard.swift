//
//  QuickStatCard.swift
//  Spendora
//

import SwiftUI

struct QuickStatCard: View {
    let title: String
    let value: Double
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(CurrencyManager.shared.format(value))
                    .font(.headline)
                    .fontWeight(.bold)
            }
            Spacer()
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
}
