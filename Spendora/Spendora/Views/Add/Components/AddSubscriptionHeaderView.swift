//
//  AddSubscriptionHeaderView.swift
//  Spendora
//

import SwiftUI

struct AddSubscriptionHeaderView: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "sparkles.rectangle.stack.fill")
                .font(.system(size: 36))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.brandPrimary, .brandSecondary],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .padding(.top, 8)
            
            Text("Add Subscription")
                .font(.system(size: 24, weight: .bold, design: .rounded))
            
            Text("Track your spending with ease")
                .font(.system(.subheadline, design: .rounded))
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 12)
    }
}
