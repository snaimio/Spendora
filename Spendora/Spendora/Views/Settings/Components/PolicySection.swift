//
//  PolicySection.swift
//  Spendora
//

import SwiftUI

struct PolicySection: View {
    let icon: String
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.brandPrimary.opacity(0.12), .brandSecondary.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: icon)
                        .font(.subheadline)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.brandPrimary, .brandSecondary],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                
                Text(title)
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.primary)
            }
            
            Text(content)
                .font(.system(.body, design: .rounded))
                .foregroundColor(.secondary)
                .lineSpacing(4)
                .padding(.leading, 48)
        }
        .padding(.vertical, 4)
    }
}
