//
//  SavingsScoreCircle.swift
//  Spendora
//

import SwiftUI

struct SavingsScoreCircle: View {
    let score: Int
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 12)
                .frame(width: 120, height: 120)
            
            Circle()
                .trim(from: 0, to: CGFloat(score) / 100)
                .stroke(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    style: StrokeStyle(
                        lineWidth: 12,
                        lineCap: .round
                    )
                )
                .frame(width: 120, height: 120)
                .rotationEffect(.degrees(-90))
            
            VStack(spacing: 4) {
                Text("\(score)")
                    .font(.system(size: 36, weight: .bold))
                
                Text("Score")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}
