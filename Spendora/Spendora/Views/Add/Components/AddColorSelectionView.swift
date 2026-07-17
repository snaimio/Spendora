//
//  AddColorSelectionView.swift
//  Spendora
//

import SwiftUI

struct AddColorSelectionView: View {
    let colorOptions: [(name: String, hex: String)]
    @Binding var selectedColorHex: String
    let generator: UIImpactFeedbackGenerator
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Choose a Color")
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .padding(.horizontal, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(colorOptions, id: \.hex) { color in
                        ColorChip(
                            color: Color(hex: color.hex),
                            isSelected: selectedColorHex == color.hex,
                            name: color.name
                        )
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                selectedColorHex = color.hex
                                generator.impactOccurred()
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}
