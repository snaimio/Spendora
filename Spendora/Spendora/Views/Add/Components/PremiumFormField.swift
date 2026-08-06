//
//  PremiumFormField.swift
//

import SwiftUI

// MARK: - PremiumFormField

/**
 `PremiumFormField` renders form field sections with vibrant icon containers, smooth glass background cards, and crisp rounded corners.
 */
struct PremiumFormField<Content: View>: View {

    // MARK: - Properties

    let icon: String
    let title: String
    let iconColor: Color
    let content: Content
    
    init(
        icon: String,
        title: String,
        iconColor: Color = .brandPrimary,
        @ViewBuilder content: () -> Content
    ) {
        self.icon = icon
        self.title = title
        self.iconColor = iconColor
        self.content = content()
    }

    // MARK: - Body

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(iconColor.opacity(0.14))
                    .frame(width: 36, height: 36)
                
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(iconColor)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                    .tracking(0.5)
                
                content
                    .font(.system(.body, design: .rounded))
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.cardBackground)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.secondary.opacity(0.08), lineWidth: 1)
        )
    }
}
