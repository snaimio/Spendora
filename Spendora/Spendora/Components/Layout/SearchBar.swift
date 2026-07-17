//
//  SearchBar.swift
//  Spendora
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String = "Search subscriptions..."
    
    @FocusState private var isFocused: Bool
    @State private var isHovered = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
                .font(.subheadline)
                .opacity(text.isEmpty ? 0.6 : 1.0)
            
            TextField(placeholder, text: $text)
                .focused($isFocused)
                .autocorrectionDisabled()
                .font(.system(.body, design: .rounded))
                .foregroundColor(.primary)
            
            if !text.isEmpty {
                Button {
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                        .symbolEffect(.bounce, value: text.isEmpty)
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
                    color: Color.black.opacity(isFocused ? 0.06 : 0.04),
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
        .scaleEffect(isHovered ? 1.01 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHovered)
        .onTapGesture {
            isFocused = true
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        SearchBar(text: .constant(""))
        SearchBar(text: .constant("Netflix"))
        SearchBar(text: .constant(""), placeholder: "Custom placeholder...")
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
