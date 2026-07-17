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
            ForEach(0..<100, id: \.self) { i in
                ConfettiPiece(
                    index: i,
                    animate: animate
                )
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 2.0)) {
                animate = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                onComplete()
            }
        }
    }
}
