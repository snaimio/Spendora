//
//  PremiumSettingsRow.swift
//  Spendora
//

import SwiftUI

// MARK: - PremiumSettingsRow (Golden UX 64pt Row Standard)

struct PremiumSettingsRow<Content: View>: View {

    // MARK: - Properties

    let icon: String
    let title: String
    let subtitle: String?
    var isDestructive: Bool = false
    let trailing: Content?
    
    init(icon: String, title: String, subtitle: String? = nil, isDestructive: Bool = false, @ViewBuilder trailing: () -> Content? = { nil }) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.isDestructive = isDestructive
        self.trailing = trailing()
    }
    
    // MARK: - Body

    var body: some View {
        HStack(spacing: 14) {
            // Icon container: 32x32pt 8pt radius
            ZStack {
                RoundedRectangle(cornerRadius: SpendoraTheme.Radius.pill, style: .continuous)
                    .fill(isDestructive ? SpendoraTheme.Colors.danger.opacity(0.15) : SpendoraTheme.Colors.coral.opacity(0.15))
                    .frame(width: 32, height: 32)
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(isDestructive ? SpendoraTheme.Colors.danger : SpendoraTheme.Colors.coral)
            }
            
            // Title 16pt medium charcoal & Subtitle 13pt secondary
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isDestructive ? SpendoraTheme.Colors.danger : SpendoraTheme.Colors.textPrimary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(SpendoraTheme.Colors.textSecondary)
                }
            }
            
            Spacer()
            
            if let trailing = trailing {
                trailing
            } else {
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(SpendoraTheme.Colors.chevron)
            }
        }
        .frame(minHeight: 64)
        .contentShape(Rectangle())
    }
}
