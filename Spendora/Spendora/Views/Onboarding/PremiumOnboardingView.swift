//
//  PremiumOnboardingView.swift
//  Spendora
//

import SwiftUI

// MARK: - PremiumOnboardingView

/**
 `PremiumOnboardingView` presents Spendora's 4-screen introduction flow,
 styled with Apple's native clean design language.
 */
struct PremiumOnboardingView: View {

    // MARK: - Properties

    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage = 0
    @State private var showButtons = false
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "sparkles.rectangle.stack.fill",
            title: "Track All Subscriptions",
            description: "Keep Netflix, Spotify, Apple One, and all recurring bills organized in one executive portfolio.",
            color: Color(hex: "#007AFF")
        ),
        OnboardingPage(
            icon: "bell.badge.fill",
            title: "Smart Billing Alerts",
            description: "Receive timely push notifications before every renewal date. Never get caught off guard by auto-renewals.",
            color: Color(hex: "#FF9500")
        ),
        OnboardingPage(
            icon: "chart.line.uptrend.xyaxis.circle.fill",
            title: "Executive Analytics",
            description: "Gain complete clarity into your annual spending run-rate with intelligent financial breakdowns.",
            color: Color(hex: "#34C759")
        ),
        OnboardingPage(
            icon: "lock.shield.fill",
            title: "100% On-Device & Private",
            description: "Your financial records stay strictly encrypted on your local device. Zero external cloud tracking.",
            color: Color(hex: "#5856D6")
        )
    ]

    // MARK: - Body

    var body: some View {
        ZStack {
            SpendoraBrandBackgroundView()
            
            VStack(spacing: 0) {
                // Top Header: Skip Button
                HStack {
                    Spacer()
                    Button {
                        completeOnboarding()
                    } label: {
                        Text("Skip")
                            .font(AppStyles.Typography.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .background(Color.cardBackground)
                            .clipShape(Capsule())
                    }
                    .padding(.top, 16)
                    .padding(.trailing, 20)
                    .opacity(showButtons ? 1 : 0)
                }
                
                Spacer()
                
                // Page Content Carousel
                TabView(selection: $currentPage) {
                    ForEach(pages.indices, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.spring(response: 0.35, dampingFraction: 0.75), value: currentPage)
                
                Spacer()
                
                // Bottom Control Section
                VStack(spacing: 20) {
                    // Animated Capsule Page Indicators
                    HStack(spacing: 8) {
                        ForEach(pages.indices, id: \.self) { index in
                            Capsule()
                                .fill(currentPage == index ? Color.brandPrimary : Color.secondary.opacity(0.3))
                                .frame(width: currentPage == index ? 24 : 8, height: 8)
                                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
                        }
                    }
                    
                    // Primary Action Button (Apple System Blue)
                    Button {
                        if currentPage == pages.count - 1 {
                            completeOnboarding()
                        } else {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                currentPage += 1
                            }
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                                .font(AppStyles.Typography.headline)
                            
                            Image(systemName: currentPage == pages.count - 1 ? "arrow.right" : "chevron.right")
                                .font(.system(size: 15, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(Color.brandPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: AppStyles.Radius.card, style: .continuous))
                        .opacity(showButtons ? 1 : 0)
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 36)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.4)) {
                showButtons = true
            }
        }
    }

    private func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        hasCompletedOnboarding = true
        dismiss()
    }
}

// MARK: - Preview
#Preview {
    PremiumOnboardingView(hasCompletedOnboarding: .constant(false))
}
