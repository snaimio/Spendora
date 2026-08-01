//
//  HomeView+Sheets.swift
//

/**
 * Main/Core Functions & Purpose:
 * Extension for HomeView containing sheet presentation modifiers (Add Subscription, Details, Reports, Profile, AI Insights).
 */

import SwiftUI


// MARK: - HomeView Extension

/**
 Extension on `HomeView` providing utility methods and helpers.
 */
extension HomeView {
    
    var homeSheetModifiers: some View {  // homeSheetModifiers property
        EmptyView()
            .sheet(isPresented: $showingAddSheet) {
                NavigationStack {
                    AddSubscriptionView()
                }
                .onDisappear {
                    refreshID += 1
                    updateWidgetData()
                }
            }
            .sheet(item: $selectedSubscription) { subscription in
                SubscriptionDetailView(subscription: subscription)
                    .onDisappear {
                        updateWidgetData()
                    }
            }
            .sheet(isPresented: $showingYearlyReport) {
                NavigationStack {
                    YearlyReportView(subscriptions: filteredSubscriptions)
                }
            }
            .sheet(isPresented: $showingChallenges) {
                NavigationStack {
                    ChallengesView(subscriptions: filteredSubscriptions)
                }
            }
            .sheet(isPresented: $showingSavingsScore) {
                NavigationStack {
                    SavingsScoreView(subscriptions: filteredSubscriptions)
                }
            }
            .sheet(isPresented: $showingAIInsights) {
                NavigationStack {
                    AIInsightsView(subscriptions: filteredSubscriptions)
                }
            }
            .sheet(isPresented: $showingProfileSheet) {
                ProfileView()
            }
            .sheet(isPresented: $showingNotificationCenter) {
                NotificationCenterSheet()
            }
    }
}
