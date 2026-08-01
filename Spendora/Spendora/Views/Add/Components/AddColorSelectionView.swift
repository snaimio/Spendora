//
//  AddColorSelectionView.swift
//

import SwiftUI

// MARK: - AddColorSelectionView

struct AddColorSelectionView: View {
    let colorOptions: [(name: String, hex: String)]
    @Binding var selectedColorHex: String
    let generator: UIImpactFeedbackGenerator

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Theme Color")
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .padding(.horizontal, 16)
            
            HStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 14) {
                        ForEach(colorOptions, id: \.hex) { item in
                            Button {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                    selectedColorHex = item.hex
                                    generator.impactOccurred()
                                }
                            } label: {
                                ColorChip(
                                    color: Color(hex: item.hex),
                                    isSelected: selectedColorHex == item.hex,
                                    name: item.name
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                }
            }
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 2)
            .padding(.horizontal, 16)
        }
    }
}
