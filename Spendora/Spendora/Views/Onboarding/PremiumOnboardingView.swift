//
//  PremiumOnboardingView.swift
//

import SwiftUI


// MARK: - PremiumOnboardingView

/**
 `PremiumOnboardingView` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for premiumonboardingview handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `PremiumOnboardingView` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
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
            icon: "sparkles.rectangle.stack",
            title: "Track All Subscriptions",
            description: "Add Netflix, Spotify, Apple One, and all your subscriptions in one place.",
            color: .categoryEntertainment
        ),
        OnboardingPage(
            icon: "bell.badge.fill",
            title: "Smart Reminders",
            description: "Get customizable advance alerts before each billing date. Never miss a charge again.",
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
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        ZStack {
            // Adaptive Dark & Light Mode Background Gradient
            if colorScheme == .dark {
                LinearGradient(
                    colors: [
                        Color(hex: "#0F172A"),
                        Color(hex: "#1E1B4B"),
                        Color(hex: "#0F172A")
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            } else {
                LinearGradient(
                    colors: [
                        Color(hex: "#EEF2FF"),
                        Color(hex: "#F5F3FF"),
                        Color(hex: "#E0F2FE")
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            }
            
            VStack {
                // Skip Button
                HStack {
                    Spacer()
                    Button {
                        // ✅ FIXED: Save to UserDefaults directly
                        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                        hasCompletedOnboarding = true
                        dismiss()
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
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: currentPage)
                
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
                        if currentPage == pages.count - 1 {
                            // ✅ FIXED: Save to UserDefaults directly
                            UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                            hasCompletedOnboarding = true
                            dismiss()
                        } else {
                            withAnimation {
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
        .interactiveDismissDisabled(false)
    }
}

// MARK: - Preview
#Preview {
    PremiumOnboardingView(hasCompletedOnboarding: .constant(false))
}
