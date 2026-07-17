//
//  SearchBar.swift
//  Spendora
//
//  Created by Sheikh Naim on 2026-06-19.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String = "Search subscriptions..."

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
                .font(.subheadline)

            TextField(placeholder, text: $text)
                .focused($isFocused)
                .autocorrectionDisabled()
                .font(.system(.body, design: .rounded))

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                }
                .transition(.opacity)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(
                    color: .black.opacity(0.05),
                    radius: 6,
                    x: 0,
                    y: 2
                )
        )
    }
}

// MARK: - Preview

#Preview {
    VStack {
        SearchBar(text: .constant(""))
        SearchBar(text: .constant("Netflix"))
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
