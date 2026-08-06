//
//  OnboardingPageView.swift
//

/**
 * Main/Core Functions & Purpose:
 * OnboardingPageView subview component displaying individual onboarding slide illustrations, title, description, and feature highlight bullets.
 */

import SwiftUI


// MARK: - OnboardingPageView

/**
 `OnboardingPageView` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for onboardingpageview handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `OnboardingPageView` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct OnboardingPageView: View {

    // MARK: - Properties

    let page: OnboardingPage  // page property
    @State private var animate = false
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        VStack(spacing: 32) {
            ZStack {
                if let imageName = page.customImageName {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                        .shadow(color: page.color.opacity(0.4), radius: 12, x: 0, y: 6)
                        .scaleEffect(animate ? 1.0 : 0.8)
                } else {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [page.color, page.color.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                        .scaleEffect(animate ? 1.0 : 0.8)
                    
                    Image(systemName: page.icon)
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                        .scaleEffect(animate ? 1.0 : 0.6)
                        .rotationEffect(.degrees(animate ? 0 : -10))
                }
            }
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    animate = true
                }
            }
            
            VStack(spacing: 12) {
                Text(page.title)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                    .opacity(animate ? 1 : 0)
                    .offset(y: animate ? 0 : 20)
                
                Text(page.description)
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .opacity(animate ? 1 : 0)
                    .offset(y: animate ? 0 : 20)
            }
            
            VStack(spacing: 12) {
                FeatureHighlight(icon: "checkmark.circle.fill", text: "100% Privacy - Zero bank credentials required")
                FeatureHighlight(icon: "checkmark.circle.fill", text: "Free & Private - No hidden cloud sync tracking")
                FeatureHighlight(icon: "checkmark.circle.fill", text: "Customizable billing alerts & analytics")
            }
            .padding(.horizontal, 24)
            .opacity(animate ? 1 : 0)
            .offset(y: animate ? 0 : 20)
        }
        .padding(.horizontal, 20)
        .onAppear {
            animate = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    animate = true
                }
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
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.brandPrimary)
                .font(.system(.body, design: .rounded))
            
            Text(text)
                .font(.system(.subheadline, design: .rounded))
                .foregroundColor(.textSecondary)
            
            Spacer()
        }
    }
}
