//
//  ConfettiView.swift
//  Spendora
//

import SwiftUI

struct ConfettiView: View {
    @State private var animate = false
    let onComplete: () -> Void
    
    var body: some View {
        ZStack {
            // Premium gradient background for confetti celebration
            LinearGradient(
                colors: [
                    Color(.systemBackground),
                    Color(.systemBackground).opacity(0.95)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ForEach(0..<120, id: \.self) { i in
                ConfettiPiece(
                    index: i,
                    animate: animate
                )
            }
        }
        .onAppear {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            
            withAnimation(.easeOut(duration: 2.0)) {
                animate = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeOut(duration: 0.5)) {
                    onComplete()
                }
            }
        }
    }
}
