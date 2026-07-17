//
//  PremiumSettingsRow.swift
//  Spendora
//

import SwiftUI

struct PremiumSettingsRow<Content: View>: View {
    let icon: String
    let title: String
    let subtitle: String?
    let trailing: Content?
    
    init(icon: String, title: String, subtitle: String? = nil, @ViewBuilder trailing: () -> Content? = { nil }) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.trailing = trailing()
    }
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.brandPrimary)
                .frame(width: 28)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(.body, design: .rounded))
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            if let trailing = trailing {
                trailing
            }
        }
        .padding(.vertical, 4)
    }
}
