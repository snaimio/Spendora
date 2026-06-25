//
//  ConfettiPiece.swift
//  Spendora
//

import SwiftUI

struct ConfettiPiece: View {
    let index: Int
    let animate: Bool
    
    var body: some View {
        let colors: [Color] = [Color.brandPrimary, Color.brandSecondary, Color.brandAccent, .green, .pink]
        let randomColor = colors[index % colors.count]
        let randomX = CGFloat.random(in: -200...200)
        let randomY = animate ? CGFloat.random(in: 200...700) : -50
        let randomRotation = animate ? Double.random(in: 0...720) : 0
        
        return Rectangle()
            .fill(randomColor)
            .frame(width: 8, height: 8)
            .rotationEffect(.degrees(randomRotation))
            .offset(x: randomX, y: randomY)
            .opacity(animate ? 0 : 1)
            .animation(.easeOut(duration: 1.5).delay(Double(index) * 0.02), value: animate)
    }
}
