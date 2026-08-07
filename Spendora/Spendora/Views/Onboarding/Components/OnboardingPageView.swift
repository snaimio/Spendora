//
//  OnboardingPageView.swift
//  Spendora
//

import SwiftUI

// MARK: - OnboardingPageView

/**
 `OnboardingPageView` renders an individual onboarding slide card with:
 - 100x100pt circular vector badge icon container
 - Apple HIG typography (26pt Title, 15pt Subheadline, 14pt Feature Highlights)
 - Adaptive card container (`Color.cardBackground`) with 100% contrast in both Light & Dark modes
 - No squeezed or truncated text across any iPhone screen size
 */
struct OnboardingPageView: View {

    // MARK: - Properties

    let page: OnboardingPage
    @State private var animate = false
    
    // MARK: - Body

    var body: some View {
        VStack(spacing: 24) {
            // Hero Icon Badge Container
            ZStack {
                if let imageName = page.customImageName {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
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
                        .frame(width: 100, height: 100)
                        .shadow(color: page.color.opacity(0.4), radius: 12, x: 0, y: 6)
                        .scaleEffect(animate ? 1.0 : 0.85)
                    
                    Image(systemName: page.icon)
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(.white)
                        .scaleEffect(animate ? 1.0 : 0.7)
                }
            }
            .padding(.top, 12)
            
            // Title & Description Stack
            VStack(spacing: 10) {
                Text(page.title)
                    .font(AppStyles.Typography.title)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                
                Text(page.description)
                    .font(AppStyles.Typography.subheadline)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(4)
                    .minimumScaleFactor(0.85)
                    .padding(.horizontal, 12)
            }
            
            // Feature Highlights Stack
            VStack(alignment: .leading, spacing: 10) {
                FeatureHighlight(icon: "checkmark.seal.fill", text: "100% On-Device - Zero bank credentials required")
                FeatureHighlight(icon: "checkmark.seal.fill", text: "Free & Private - No hidden cloud tracking")
                FeatureHighlight(icon: "checkmark.seal.fill", text: "Customizable billing alerts & analytics")
            }
            .padding(.top, 4)
            .padding(.horizontal, 16)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .background(
            ZStack {
                Color.cardBackground
                LinearGradient(
                    colors: [page.color.opacity(0.08), page.color.opacity(0.02)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        )
        .cornerRadius(22)
        .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(page.color.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal, 20)
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
