//
//  AnimatedNumber.swift
//  Spendora
//

import SwiftUI

struct AnimatedNumber: View {
    let value: Double

    @State private var animatedValue: Double = 0

    var body: some View {
        Text(CurrencyManager.shared.format(animatedValue))
            .contentTransition(.numericText())
            .animation(
                .spring(response: 0.6, dampingFraction: 0.8),
                value: animatedValue
            )
            .onAppear {
                animatedValue = value
            }
            .onChange(of: value) { _, newValue in
                withAnimation {
                    animatedValue = newValue
                }
            }
    }
}
