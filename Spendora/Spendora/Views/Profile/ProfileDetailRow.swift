//
//  ProfileDetailRow.swift
//  Spendora
//
//  Capstone 2026 - Mobile Application Development
//  Author: Sheikh Naim
//

/**
 * Main/Core Functions & Purpose:
 * ProfileDetailRow reusable row component displaying account key-value details (e.g. Member Since, Storage Enclave).
 */

import SwiftUI

struct ProfileDetailRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.brandPrimary)
                .frame(width: 24)
            Text(title)
                .font(.system(.body, design: .rounded))
                .foregroundColor(.textPrimary)
            Spacer()
            Text(value)
                .font(.system(.body, design: .rounded))
                .foregroundColor(.textSecondary)
        }
        .padding(14)
    }
}
