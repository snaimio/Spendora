//
//  ConfettiPiece.swift
//  Spendora
//

import SwiftUI

struct ConfettiPiece: View {
    let index: Int
    let animate: Bool
    
    var body: some View {
        let colors: [Color] = [
            Color(hex: "#6366F1"),  // Brand Primary
            Color(hex: "#8B5CF6"),  // Brand Secondary
            Color(hex: "#F59E0B"),  // Brand Accent
            Color(hex: "#10B981"),  // Green
            Color(hex: "#EC4899"),  // Pink
            Color(hex: "#3B82F6"),  // Blue
            Color(hex: "#EF4444"),  // Red
            Color(hex: "#F59E0B"),  // Orange
        ]
        
        let randomColor = colors[index % colors.count]
        let randomX = CGFloat.random(in: -200...200)
        let randomY = animate ? CGFloat.random(in: 200...700) : -50
        let randomRotation = animate ? Double.random(in: 0...720) : 0
        let randomScale = CGFloat.random(in: 0.6...1.4)
        
        // Random shape selection
        let shapeIndex = index % 4
        
        return Group {
            if shapeIndex == 0 {
                // Square
                Rectangle()
                    .fill(randomColor)
                    .frame(width: 8, height: 8)
                    .cornerRadius(2)
            } else if shapeIndex == 1 {
                // Circle
                Circle()
                    .fill(randomColor)
                    .frame(width: 8, height: 8)
            } else if shapeIndex == 2 {
                // Horizontal rectangle
                Rectangle()
                    .fill(randomColor)
                    .frame(width: 12, height: 4)
                    .cornerRadius(2)
            } else {
                // Vertical rectangle
                Rectangle()
                    .fill(randomColor)
                    .frame(width: 4, height: 12)
                    .cornerRadius(2)
            }
        }
        .scaleEffect(randomScale)
        .rotationEffect(.degrees(randomRotation))
        .offset(x: randomX, y: randomY)
        .opacity(animate ? 0 : 1)
        .shadow(color: randomColor.opacity(0.3), radius: 2, x: 0, y: 1)
        .animation(
            .easeOut(duration: 1.8)
                .delay(Double(index) * 0.015),
            value: animate
        )
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        // Background
        LinearGradient(
            colors: [Color(.systemBackground), Color(.systemBackground)],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        
        // Multiple confetti pieces for preview
        ForEach(0..<30, id: \.self) { i in
            ConfettiPiece(index: i, animate: true)
        }
    }
}
