//
//  PremiumOnboardingView.swift
//  Spendora
//

import SwiftUI

// MARK: - PremiumOnboardingView

/**
 `PremiumOnboardingView` presents Spendora's 4-screen introduction flow,
 styled with Spendora Teal brand identity, vector hero icon badges, and animated capsule page indicators.
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
            description: "Keep Netflix, Spotify, Apple One, and all your recurring payments organized in one central executive dashboard.",
            color: Color(hex: "#00D4AA")
        ),
        OnboardingPage(
            icon: "bell.badge.fill",
            title: "Smart Billing Alerts",
            description: "Receive advance push notifications before every renewal date. Never get caught off guard by auto-renewals again.",
            color: Color(hex: "#FFD93D")
        ),
        OnboardingPage(
            icon: "chart.line.uptrend.xyaxis.circle.fill",
            title: "AI-Powered Analytics",
            description: "Gain full visibility into your annual spending run-rate with intelligent financial breakdowns and savings score insights.",
            color: Color(hex: "#00B4D8")
        ),
        OnboardingPage(
            icon: "lock.shield.fill",
            title: "100% On-Device & Private",
            description: "Your financial data stays strictly encrypted on your local device. Zero external cloud tracking or bank credentials required.",
            color: Color(hex: "#6C5CE7")
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
                            .fontWeight(.bold)
                            .foregroundColor(.textSecondary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(Color.cardBackground)
                                    .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
                            )
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
                                .fill(currentPage == index ? Color(hex: "#00D4AA") : Color.textSecondary.opacity(0.3))
                                .frame(width: currentPage == index ? 24 : 8, height: 8)
                                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
                        }
                    }
                    
                    // Primary Action Button (Spendora Teal Gradient)
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
                            
                            Image(systemName: currentPage == pages.count - 1 ? "sparkles" : "arrow.right")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [Color(hex: "#00D4AA"), Color(hex: "#00B4D8")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(18)
                        .shadow(color: Color(hex: "#00D4AA").opacity(0.4), radius: 10, x: 0, y: 5)
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

// MARK: - OnboardingPage Model

struct OnboardingPage: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
    let color: Color
}

// MARK: - OnboardingPageView

struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: 24) {
            // Icon Emblem
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [page.color.opacity(0.25), page.color.opacity(0.08)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 130, height: 130)
                
                Image(systemName: page.icon)
                    .font(.system(size: 54, weight: .bold))
                    .foregroundColor(page.color)
            }
            .shadow(color: page.color.opacity(0.3), radius: 12, y: 6)
            
            VStack(spacing: 12) {
                Text(page.title)
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 24)
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Preview
#Preview {
    PremiumOnboardingView(hasCompletedOnboarding: .constant(false))
}
