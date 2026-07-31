/**
 * Main/Core Functions & Purpose:
 * HomeView main dashboard view of the Spendora app.
 * Displays overall monthly/yearly spend totals, upcoming charge cards, search & sort controls,
 * subscription cards list, quick actions toolbar menu (Yearly Report, Challenges, Savings Score, AI Insights),
 * and user profile avatar header.
 */

import SwiftUI
import SwiftData
import WidgetKit

struct HomeView: View {
    @Environment(\.modelContext) var modelContext
    @Query var subscriptions: [Subscription]
    
    // UI state management
    @State var showingAddSheet = false
    @State var selectedSubscription: Subscription?
    @State var searchText = ""
    @State var refreshID = 0
    @State var sortOption: SortOption = .alphabetical
    @State var animateHeader = false
    
    @ObservedObject var profileManager = UserProfileManager.shared
    @State var showingProfileSheet = false
    
    @State var showingYearlyReport = false
    @State var showingChallenges = false
    @State var showingSavingsScore = false
    @State var showingAIInsights = false
    
    let generator = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Brand Header & Profile Avatar Bar
                        DashboardBrandHeaderView {
                            generator.impactOccurred()
                            showingProfileSheet = true
                        }
                        .opacity(animateHeader ? 1 : 0)
                        
                        // Hero Spending Summary Card
                        HeroCardView(
                            totalMonthly: totalMonthly,
                            totalYearly: totalYearly,
                            count: filteredSubscriptions.count,
                            subscriptionCount: subscriptionCount
                        )
                        .opacity(animateHeader ? 1 : 0)
                        .offset(y: animateHeader ? 0 : 15)
                        
                        if !subscriptions.isEmpty {
                            if let next = nextSubscription {
                                NextChargeCardView(subscription: next)
                                    .transition(.move(edge: .top).combined(with: .opacity))
                            }
                            
                            // Stats Grid
                            HStack(spacing: 12) {
                                StatCardView(
                                    icon: "calendar",
                                    title: "Yearly",
                                    value: CurrencyManager.shared.format(totalYearly),
                                    colors: [Color(hex: "#FF6B6B"), Color(hex: "#FFE66D")]
                                )
                                
                                StatCardView(
                                    icon: "chart.bar.fill",
                                    title: "Average",
                                    value: CurrencyManager.shared.format(subscriptionCount > 0 ? totalMonthly / Double(subscriptionCount) : 0),
                                    colors: [Color(hex: "#4ECDC4"), Color(hex: "#45B7D1")]
                                )
                            }
                            
                            // Search Bar
                            SearchBarView(searchText: $searchText)
                            
                            // Sort Options
                            SortChipsView(sortOption: $sortOption)
                            
                            // Subscriptions List
                            VStack(spacing: 12) {
                                ForEach(filteredSubscriptions) { subscription in
                                    SubscriptionCardView(subscription: subscription)
                                        .onTapGesture {
                                            generator.impactOccurred()
                                            selectedSubscription = subscription
                                        }
                                }
                            }
                        } else {
                            EmptyStateView()
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
                .id(refreshID)
                .onAppear {
                    updateWidgetData()
                    withAnimation(.easeOut(duration: 0.6)) {
                        animateHeader = true
                    }
                }
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        generator.impactOccurred()
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.brandPrimary)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button {
                            showingYearlyReport = true
                        } label: {
                            Label("Yearly Report", systemImage: "calendar")
                        }
                        
                        Button {
                            showingChallenges = true
                        } label: {
                            Label("Challenges", systemImage: "trophy")
                        }
                        
                        Button {
                            showingSavingsScore = true
                        } label: {
                            Label("Savings Score", systemImage: "star.circle.fill")
                        }
                        
                        Button {
                            showingAIInsights = true
                        } label: {
                            Label("AI Insights", systemImage: "brain.head.profile")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle.fill")
                            .font(.title2)
                            .foregroundColor(.brandSecondary)
                    }
                }
            }
            .background(homeSheetModifiers)
            .onChange(of: subscriptions.count) { _, _ in
                updateWidgetData()
            }
        }
    }
}
