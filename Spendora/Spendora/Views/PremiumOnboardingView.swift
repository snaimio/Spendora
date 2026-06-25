//
//  PremiumOnboardingView.swift
//  Spendora
//

import SwiftUI

struct PremiumOnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage = 0
    @State private var showButtons = false
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "sparkles.rectangle.stack",
            title: "Track All Subscriptions",
            description: "Add Netflix, Spotify, Apple One, and all your subscriptions in one place.",
            color: .categoryEntertainment
        ),
        OnboardingPage(
            icon: "bell.badge.fill",
            title: "Smart Reminders",
            description: "Get notified 3 days before each billing date. Never miss a charge again.",
            color: .categoryProductivity
        ),
        OnboardingPage(
            icon: "chart.line.uptrend.xyaxis",
            title: "AI-Powered Insights",
            description: "Understand your spending patterns with smart analytics and savings tips.",
            color: .categoryHealth
        ),
        OnboardingPage(
            icon: "calendar",
            title: "Visual Calendar View",
            description: "See all your billing dates at a glance with the interactive calendar.",
            color: .categoryShopping
        )
    ]
    
    var body: some View {
        ZStack {
            // Premium Gradient Background
            LinearGradient(
                colors: [
                    Color(hex: "#EEF2FF"),
                    Color(hex: "#F5F3FF"),
                    Color(hex: "#FEF3C7")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                // Skip Button
                HStack {
                    Spacer()
                    Button {
                        withAnimation {
                            hasCompletedOnboarding = true
                        }
                    } label: {
                        Text("Skip")
                            .font(.system(.body, design: .rounded))
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(Color(.systemBackground))
                                    .shadow(color: Color.black.opacity(0.05), radius: 8)
                            )
                    }
                    .padding(.top, 20)
                    .padding(.trailing, 24)
                    .opacity(showButtons ? 1 : 0)
                }
                
                Spacer()
                
                // Page Content
                TabView(selection: $currentPage) {
                    ForEach(pages.indices, id: \.self) { index in
                        OnboardingPageView(page: pages[index], isLast: index == pages.count - 1) {
                            withAnimation {
                                if index == pages.count - 1 {
                                    hasCompletedOnboarding = true
                                } else {
                                    currentPage += 1
                                }
                            }
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.spring(), value: currentPage)
                
                Spacer()
                
                // Bottom Controls
                VStack(spacing: 20) {
                    // Page Dots
                    HStack(spacing: 10) {
                        ForEach(pages.indices, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? Color.brandPrimary : Color.brandPrimary.opacity(0.25))
                                .frame(width: 8, height: 8)
                                .animation(.spring(), value: currentPage)
                        }
                    }
                    
                    // Next/Get Started Button
                    Button {
                        withAnimation {
                            if currentPage == pages.count - 1 {
                                hasCompletedOnboarding = true
                            } else {
                                currentPage += 1
                            }
                        }
                    } label: {
                        HStack {
                            Text(currentPage == pages.count - 1 ? "Get Started" : "Next")
                                .font(.system(.headline, design: .rounded))
                                .fontWeight(.semibold)
                            
                            Image(systemName: currentPage == pages.count - 1 ? "sparkles" : "arrow.right")
                                .font(.system(.body, design: .rounded))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [.brandPrimary, .brandSecondary],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .shadow(color: Color.brandPrimary.opacity(0.3), radius: 12, x: 0, y: 6)
                        .opacity(showButtons ? 1 : 0)
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                showButtons = true
            }
        }
        .interactiveDismissDisabled()
    }
}

// MARK: - Onboarding Page Model
struct OnboardingPage {
    let icon: String
    let title: String
    let description: String
    let color: Color
}

// MARK: - Onboarding Page View
struct OnboardingPageView: View {
    let page: OnboardingPage
    let isLast: Bool
    let onAction: () -> Void
    
    @State private var animate = false
    
    var body: some View {
        VStack(spacing: 32) {
            // Animated Icon
            ZStack {
                Circle()
                    .fill(page.color.opacity(0.12))
                    .frame(width: 160, height: 160)
                    .scaleEffect(animate ? 1.0 : 0.8)
                
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
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    animate = true
                }
            }
            
            VStack(spacing: 12) {
                Text(page.title)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .opacity(animate ? 1 : 0)
                    .offset(y: animate ? 0 : 20)
                
                Text(page.description)
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .opacity(animate ? 1 : 0)
                    .offset(y: animate ? 0 : 20)
            }
            
            // Feature Highlights
            VStack(spacing: 12) {
                FeatureHighlight(icon: "checkmark.circle.fill", text: "100% Privacy - No bank connections")
                FeatureHighlight(icon: "checkmark.circle.fill", text: "Free forever - No hidden charges")
                FeatureHighlight(icon: "checkmark.circle.fill", text: "Cancel anytime with one tap")
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

// MARK: - Feature Highlight
struct FeatureHighlight: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.brandPrimary)
                .font(.system(.body, design: .rounded))
            
            Text(text)
                .font(.system(.subheadline, design: .rounded))
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
}
