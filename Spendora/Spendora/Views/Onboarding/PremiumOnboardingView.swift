//
//  PremiumOnboardingView.swift
//

import SwiftUI

// MARK: - PremiumOnboardingView

/**
 `PremiumOnboardingView` presents Spendora's initial 4-screen introduction flow,
 featuring Apple HIG compliant typography, vector hero icon badges, animated capsule page indicators, and 100% WCAG contrast text.
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
            description: "Keep Netflix, Spotify, Apple One, and all your recurring payments organized in one central place.",
            color: Color(hex: "#007AFF")
        ),
        OnboardingPage(
            icon: "bell.badge.fill",
            title: "Smart Billing Alerts",
            description: "Receive timely advance notifications before every charge date. Never get surprised by auto-renewals.",
            color: Color(hex: "#5856D6")
        ),
        OnboardingPage(
            icon: "chart.line.uptrend.xyaxis.circle.fill",
            title: "AI-Powered Analytics",
            description: "Understand your financial run-rate with intelligent spending breakdowns and savings opportunities.",
            color: Color(hex: "#AF52DE")
        ),
        OnboardingPage(
            icon: "lock.shield.fill",
            title: "100% On-Device & Private",
            description: "Your financial data stays strictly on your device. Zero external cloud requirements or data tracking.",
            color: Color(hex: "#34C759")
        )
    ]

    // MARK: - Body

    var body: some View {
        ZStack {
            // Adaptive Dark & Light Background Surface
            Color.appBackground
                .ignoresSafeArea()
            
            VStack {
                // Top Header: Skip Button
                HStack {
                    Spacer()
                    Button {
                        completeOnboarding()
                    } label: {
                        Text("Skip")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(.textSecondary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(Color.cardBackground)
                                    .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
                            )
                    }
                    .padding(.top, 16)
                    .padding(.trailing, 24)
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
                VStack(spacing: 24) {
                    // Animated Capsule Page Indicators
                    HStack(spacing: 8) {
                        ForEach(pages.indices, id: \.self) { index in
                            Capsule()
                                .fill(currentPage == index ? Color.brandPrimary : Color.textSecondary.opacity(0.3))
                                .frame(width: currentPage == index ? 24 : 8, height: 8)
                                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
                        }
                    }
                    
                    // Primary Action Button
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
                                .font(.system(size: 17, weight: .bold, design: .rounded))
                            
                            Image(systemName: currentPage == pages.count - 1 ? "sparkles" : "arrow.right")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [Color(hex: "#007AFF"), Color(hex: "#5856D6")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(18)
                        .shadow(color: Color(hex: "#007AFF").opacity(0.35), radius: 12, x: 0, y: 6)
                        .opacity(showButtons ? 1 : 0)
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
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
