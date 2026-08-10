//
//  EmptyStateView.swift
//  Spendora
//

import SwiftUI

// MARK: - EmptyStateView (Golden UX Standard Empty State)

struct EmptyStateView: View {

    // MARK: - Properties

    @State private var showingAddSheet = false
    let generator = UIImpactFeedbackGenerator(style: .medium)

    // MARK: - Body

    var body: some View {
        VStack(spacing: 20) {
            Spacer().frame(height: 20)
            
            // SF Symbol: creditcard.fill 64pt coral tint
            ZStack {
                Circle()
                    .fill(SpendoraTheme.Colors.coralTint)
                    .frame(width: 100, height: 100)
                
                Image(systemName: "creditcard.fill")
                    .font(.system(size: 48))
                    .foregroundColor(SpendoraTheme.Colors.coral)
            }
            .padding(.bottom, 8)
            
            VStack(spacing: 8) {
                // Title: 22pt bold charcoal
                Text("No Subscriptions Yet")
                    .font(SpendoraTheme.Typography.title)
                    .foregroundColor(SpendoraTheme.Colors.textPrimary)
                
                // Subtitle: 15pt secondary centered
                Text("Add your first subscription to start tracking your spending and upcoming renewal dates.")
                    .font(SpendoraTheme.Typography.body)
                    .foregroundColor(SpendoraTheme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .padding(.horizontal, 24)
            }
            
            // Button: coral gradient "Add Subscription" 50pt tall 14pt radius full width
            Button {
                generator.impactOccurred()
                showingAddSheet = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 18, weight: .bold))
                    Text("Add Subscription")
                        .font(.system(size: 16, weight: .bold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(SpendoraTheme.Colors.coralGradient)
                .clipShape(RoundedRectangle(cornerRadius: SpendoraTheme.Radius.button, style: .continuous))
                .shadow(color: SpendoraTheme.Colors.coral.opacity(0.35), radius: 8, y: 4)
            }
            .padding(.horizontal, 24)
            .padding(.top, 12)
            .pressableButton()
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .sheet(isPresented: $showingAddSheet) {
            AddSubscriptionView()
        }
    }
}
