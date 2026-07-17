//
//  ColorChip.swift
//  Spendora
//

import SwiftUI

struct ColorChip: View {
    let color: Color
    let isSelected: Bool
    let name: String
    
    var body: some View {
        VStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 44, height: 44)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: isSelected ? 3 : 0)
                        .shadow(color: .black.opacity(0.15), radius: 4)
                )
                .overlay(
                    Circle()
                        .stroke(color, lineWidth: isSelected ? 1 : 0)
                )
                .scaleEffect(isSelected ? 1.1 : 1.0)
            
            Text(name)
                .font(.system(.caption2, design: .rounded))
                .foregroundColor(isSelected ? .primary : .secondary)
        }
    }
}
