//
//  AIInsightsView.swift
//

import SwiftUI


// MARK: - AIInsightsView

/**
 `AIInsightsView` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for aiinsightsview handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `AIInsightsView` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct AIInsightsView: View {

    // MARK: - Properties

    let subscriptions: [Subscription]  // subscriptions property
    @Environment(\.dismiss) private var dismiss
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    AIInsightsHeaderView()
                    
                    if subscriptions.isEmpty {
                        EmptyInsightsView()
                    } else {
                        AIInsightsContent(subscriptions: subscriptions)
                    }
                }
                .padding()
            }
            .navigationTitle("AI Insights")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // ✅ FIXED: Done button with brand primary color
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.brandPrimary)
                }
            }
        }
    }
}

// MARK: - AI Insights Header

// MARK: - AIInsightsHeaderView

/**
 `AIInsightsHeaderView` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for aiinsightsheaderview handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `AIInsightsHeaderView` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct AIInsightsHeaderView: View {

    // MARK: - Properties


    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 60))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.brandPrimary, .brandSecondary],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Text("AI Insights")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Smart analysis of your subscription spending")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.top, 20)
    }
}

// MARK: - Empty Insights

// MARK: - EmptyInsightsView

/**
 `EmptyInsightsView` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for emptyinsightsview handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `EmptyInsightsView` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct EmptyInsightsView: View {

    // MARK: - Properties


    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "plus.circle")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text("No subscriptions to analyze")
                .font(.headline)
            
            Text("Add your first subscription to get AI-powered insights")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 40)
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}

// MARK: - AI Insights Content

// MARK: - AIInsightsContent

/**
 `AIInsightsContent` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for aiinsightscontent handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `AIInsightsContent` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct AIInsightsContent: View {

    // MARK: - Properties

    let subscriptions: [Subscription]  // subscriptions property
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        VStack(spacing: 16) {
            AIInsightCard(
                icon: "dollarsign.circle.fill",
                title: "Monthly Spending",
                value: CurrencyManager.shared.format(
                    subscriptions.reduce(0) { $0 + $1.monthlyCost }
                ),
                color: .blue
            )
            
            if let mostExpensive = subscriptions.max(by: { $0.monthlyCost < $1.monthlyCost }) {
                AIInsightCard(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Most Expensive",
                    value: mostExpensive.displayName,
                    subtitle: CurrencyManager.shared.format(mostExpensive.monthlyCost) + "/month",
                    color: .red
                )
            }
            
            let unusedSubs = subscriptions.filter { $0.usageRating <= 2 }
            if !unusedSubs.isEmpty {
                AIInsightCard(
                    icon: "lightbulb.fill",
                    title: "Savings Opportunity",
                    value: "\(unusedSubs.count) underused",
                    subtitle: "Consider cancelling these subscriptions",
                    color: .orange
                )
            }
            
            let trialsEnding = subscriptions.filter {
                $0.isTrial && !$0.trialConvertedToPaid && $0.trialDaysRemaining <= 3 && $0.trialDaysRemaining >= 0
            }
            if !trialsEnding.isEmpty {
                AIInsightCard(
                    icon: "clock.fill",
                    title: "Trials Ending Soon",
                    value: "\(trialsEnding.count) trials",
                    subtitle: trialsEnding.map { $0.displayName }.joined(separator: ", "),
                    color: .purple
                )
            }
            
            SpendingDistributionView(subscriptions: subscriptions)
        }
    }
}

// MARK: - Spending Distribution

// MARK: - SpendingDistributionView

/**
 `SpendingDistributionView` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for spendingdistributionview handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `SpendingDistributionView` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct SpendingDistributionView: View {

    // MARK: - Properties

    let subscriptions: [Subscription]  // subscriptions property
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Spending by Category")
                .font(.headline)
            
            let grouped = Dictionary(grouping: subscriptions) { $0.category }
            let sortedCategories = grouped.sorted {
                $0.value.reduce(0) { $0 + $1.monthlyCost } >
                $1.value.reduce(0) { $0 + $1.monthlyCost }
            }
            
            ForEach(sortedCategories.prefix(5), id: \.key) { category, subs in
                let total = subs.reduce(0) { $0 + $1.monthlyCost }
                let percentage = (total / subscriptions.reduce(0) { $0 + $1.monthlyCost }) * 100
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(category)
                            .font(.subheadline)
                        Spacer()
                        Text(CurrencyManager.shared.format(total))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    
                    ProgressView(value: percentage, total: 100)
                        .tint(categoryColor(for: category))
                        .frame(height: 6)
                        .scaleEffect(x: 1, y: 1.5, anchor: .center)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
    

    /**
     Executes `categoryColor` for component logic.
     
     - Parameter category: Value passed to `categoryColor`.
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    private func categoryColor(for category: String) -> Color {
        switch category {
        case "Entertainment": return .categoryEntertainment
        case "Productivity": return .categoryProductivity
        case "Health & Fitness": return .categoryHealth
        case "Shopping": return .categoryShopping
        case "Food & Dining": return .categoryFood
        case "Education": return .categoryEducation
        default: return .categoryOther
        }
    }
}
