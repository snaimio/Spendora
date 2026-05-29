//
//  EmptyStateView.swift
//  Spendora
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
                .frame(height: 60)
            
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "creditcard.and.123")
                    .font(.system(size: 50))
                    .foregroundColor(.blue)
            }
            
            Text("No Subscriptions Yet")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Start tracking your subscriptions by tapping the + button above.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .accessibilityElement(children: .combine)
        .accessibilityLabel("No subscriptions. Tap the add button to get started.")
    }
}
