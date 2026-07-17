//
//  PremiumStatPill.swift
//  Spendora
//

import SwiftUI

struct PremiumStatPill: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.brandPrimary)
            
            Text(label)
                .font(.system(size: 10, design: .rounded))
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.system(size: 11, design: .rounded))
                .fontWeight(.semibold)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
        .fixedSize(horizontal: false, vertical: true)
    }
}
