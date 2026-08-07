//
//  OnboardingPageView.swift
//  Spendora
//

import SwiftUI

// MARK: - OnboardingPageView

/**
 `OnboardingPageView` renders an individual onboarding slide card featuring:
 - 100x100pt circular vector badge icon container
 - 26pt Bold Headline Title
 - DEDICATED DESCRIPTION CARD BOX with rounded borders and 100% WCAG contrast padding
 - Standalone Feature Bullet Points card box at bottom
 */
struct OnboardingPageView: View {

    // MARK: - Properties

    let page: OnboardingPage
    @State private var animate = false
    
    // MARK: - Body

    var body: some View {
        VStack(spacing: 20) {
            // Hero Icon Badge Container
            ZStack {
                if let imageName = page.customImageName {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 96, height: 96)
                        .clipShape(Circle())
                        .shadow(color: page.color.opacity(0.4), radius: 12, x: 0, y: 6)
                        .scaleEffect(animate ? 1.0 : 0.85)
                } else {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [page.color, page.color.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 96, height: 96)
                        .shadow(color: page.color.opacity(0.4), radius: 12, x: 0, y: 6)
                        .scaleEffect(animate ? 1.0 : 0.85)
                    
                    Image(systemName: page.icon)
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .scaleEffect(animate ? 1.0 : 0.7)
                }
            }
            .padding(.top, 8)
            
            // Slide Title
            Text(page.title)
                .font(AppStyles.Typography.title)
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
            
            // DEDICATED SUBTITLE DESCRIPTION CARD BOX
            VStack {
                Text(page.description)
                    .font(AppStyles.Typography.subheadline)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(4)
                    .minimumScaleFactor(0.85)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    Color.appBackground.opacity(0.6)
                    LinearGradient(
                        colors: [page.color.opacity(0.12), page.color.opacity(0.04)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
            )
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(page.color.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
            
            // Feature Highlights Box
            VStack(alignment: .leading, spacing: 10) {
                FeatureHighlight(icon: "checkmark.seal.fill", text: "100% On-Device - Zero bank credentials required")
                FeatureHighlight(icon: "checkmark.seal.fill", text: "Free & Private - No hidden cloud tracking")
                FeatureHighlight(icon: "checkmark.seal.fill", text: "Customizable billing alerts & analytics")
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.appBackground.opacity(0.3))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.secondary.opacity(0.12), lineWidth: 1)
            )
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background(
            ZStack {
                Color.cardBackground
                LinearGradient(
                    colors: [page.color.opacity(0.06), page.color.opacity(0.02)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        )
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 5)
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(page.color.opacity(0.25), lineWidth: 1.2)
        )
        .padding(.horizontal, 18)
        .onAppear {
            animate = false
            withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                animate = true
            }
        }
    }
}

// MARK: - FeatureHighlight

struct FeatureHighlight: View {

    // MARK: - Properties

    let icon: String
    let text: String

    // MARK: - Body

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(.brandPrimary)
                .font(.system(size: 14, weight: .bold))
            
            Text(text)
                .font(AppStyles.Typography.caption)
                .foregroundColor(.textSecondary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            
            Spacer(minLength: 0)
        }
    }
}
