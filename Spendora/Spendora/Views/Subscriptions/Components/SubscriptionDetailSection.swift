//
//  SubscriptionDetailSection.swift
//  Spendora
//

import SwiftUI

struct SubscriptionDetailSection: View {
    let icon: String
    let title: String
    let value: String
    let color: Color?
    
    init(icon: String, title: String, value: String, color: Color? = nil) {
        self.icon = icon
        self.title = title
        self.value = value
        self.color = color
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.headline)
                .foregroundColor(color ?? .brandPrimary)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.medium)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
