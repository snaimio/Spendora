//
//  SearchBar.swift
//  Spendora
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String = "Search subscriptions..."
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
                .font(.subheadline)
                .frame(width: 20)
            
            TextField(placeholder, text: $text)
                .focused($isFocused)
                .autocorrectionDisabled()
                .font(.system(.body, design: .rounded))
                .foregroundColor(.primary)
                .frame(minHeight: 22)
            
            if !text.isEmpty {
                Button {
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.systemBackground))
                .shadow(
                    color: Color.black.opacity(isFocused ? 0.08 : 0.04),
                    radius: isFocused ? 12 : 8,
                    x: 0,
                    y: isFocused ? 4 : 2
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(
                            LinearGradient(
                                colors: isFocused ? [.brandPrimary.opacity(0.3), .brandSecondary.opacity(0.1)] : [Color.clear, Color.clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: isFocused ? 2 : 0
                        )
                )
        )
        .frame(minHeight: 44)
        .padding(.horizontal, 4)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        SearchBar(text: .constant(""))
        SearchBar(text: .constant("Netflix"))
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
