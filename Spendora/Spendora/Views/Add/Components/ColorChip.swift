//
//  ColorChip.swift
//

import SwiftUI

// MARK: - ColorChip

struct ColorChip: View {
    let color: Color
    let isSelected: Bool
    let name: String

    var body: some View {
        ZStack {
            Circle()
                .fill(color)
                .frame(width: 32, height: 32)
                .overlay(
                    Circle()
                        .stroke(Color.primary.opacity(0.15), lineWidth: 1)
                )
                .shadow(color: color.opacity(0.3), radius: isSelected ? 6 : 2, x: 0, y: 2)

            if isSelected {
                Image(systemName: "checkmark")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
        }
        .scaleEffect(isSelected ? 1.15 : 1.0)
        .padding(.vertical, 4)
    }
}
