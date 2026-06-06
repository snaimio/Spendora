//
//  HomeView.swift
//  Spendora
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var subscriptions: [Subscription]
    
    @State private var showingAddSheet = false
    @State private var selectedSubscription: Subscription?
    @State private var searchText = ""
    @State private var showConfetti = false
    @State private var showingShareSheet = false
    @State private var shareImage: UIImage?
    @State private var refreshID = 0
    @State private var forceRefresh = false
    
    private let generator = UIImpactFeedbackGenerator(style: .medium)
    
    var sortedSubscriptions: [Subscription] {
        subscriptions.sorted { $0.nextBillingDate < $1.nextBillingDate }
    }
    
    var filteredSubscriptions: [Subscription] {
        print("📊 filteredSubscriptions count: \(subscriptions.count)")
        if searchText.isEmpty { return sortedSubscriptions }
        return sortedSubscriptions.filter {
            $0.displayName.localizedCaseInsensitiveContains(searchText) ||
            $0.category.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var totalMonthly: Double {
        filteredSubscriptions.reduce(0) { $0 + $1.monthlyCost }
    }
    
    var totalYearly: Double {
        filteredSubscriptions.reduce(0) { $0 + $1.yearlyCost }
    }
    
    var topCategory: String {
        let grouped = Dictionary(grouping: filteredSubscriptions) { $0.category }
        let totals = grouped.map { ($0.key, $0.value.reduce(0) { $0 + $1.monthlyCost }) }
        return totals.max { $0.1 < $1.1 }?.0 ?? "None"
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AnimatedGradientBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Hero Section
                        VStack(spacing: 12) {
                            Text("MONTHLY SPEND")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                                .tracking(2)
                            
                            AnimatedNumber(value: totalMonthly)
                                .font(.system(size: 56, weight: .bold))
                                .foregroundStyle(Color.brandPrimary)
                            
                            if totalMonthly > 0 {
                                Text("across \(filteredSubscriptions.count) subscriptions")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.top, 20)
                        
                        // Quick Stats Row
                        if !filteredSubscriptions.isEmpty {
                            HStack(spacing: 16) {
                                QuickStatCard(
                                    title: "Yearly",
                                    value: totalYearly,
                                    icon: "calendar",
                                    color: Color.brandSecondary
                                )
                                
                                QuickStatCard(
                                    title: "Average",
                                    value: filteredSubscriptions.isEmpty ? 0 : totalMonthly / Double(filteredSubscriptions.count),
                                    icon: "chart.line.uptrend.xyaxis",
                                    color: Color.brandAccent
                                )
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // Charts
                        if !filteredSubscriptions.isEmpty {
                            SpendingChartView(subscriptions: filteredSubscriptions)
                                .padding(.horizontal, 20)
                        }
                        
                        // Search Bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.secondary)
                            TextField("Search subscriptions...", text: $searchText)
                                .textFieldStyle(.plain)
                        }
                        .padding(12)
                        .background(Color(.systemBackground))
                        .cornerRadius(16)
                        .padding(.horizontal, 20)
                        
                        // MARK: - Subscriptions List
                        if filteredSubscriptions.isEmpty {
                            DelightfulEmptyState()
                                .padding(.horizontal, 20)
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(filteredSubscriptions) { subscription in
                                    Button {
                                        print("🟡 TAPPED subscription: \(subscription.displayName)")
                                        generator.impactOccurred()
                                        selectedSubscription = subscription
                                    } label: {
                                        SubscriptionCard(subscription: subscription)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.vertical, 20)
                }
                .id(refreshID)
                .id(forceRefresh)
                .onAppear {
                    print("📊 HomeView appeared, subscriptions count: \(subscriptions.count)")
                }
                .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("SubscriptionAdded"))) { _ in
                    print("📢 Received refresh notification")
                    forceRefresh.toggle()
                    refreshID += 1
                }
            }
            .navigationTitle("Spendora")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button {
                            generator.impactOccurred()
                            showingAddSheet = true
                        } label: {
                            Label("Add Subscription", systemImage: "plus")
                        }
                        
                        if !filteredSubscriptions.isEmpty {
                            Button {
                                generator.impactOccurred()
                                generateAndShareReport()
                            } label: {
                                Label("Share Spending Report", systemImage: "square.and.arrow.up")
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle.fill")
                            .font(.title2)
                            .foregroundStyle(Color.brandPrimary)
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddSubscriptionView()
                    .onDisappear {
                        refreshID += 1
                        forceRefresh.toggle()
                    }
            }
            .sheet(item: $selectedSubscription) { subscription in
                SubscriptionDetailView(subscription: subscription)
            }
            .sheet(isPresented: $showingShareSheet) {
                if let image = shareImage {
                    ShareSheet(items: [image])
                }
            }
            .overlay {
                if showConfetti {
                    ConfettiView {
                        showConfetti = false
                    }
                }
            }
        }
    }
    
    private func generateAndShareReport() {
        let renderer = ImageRenderer(content: ShareableReportCard(
            totalMonthly: totalMonthly,
            totalYearly: totalYearly,
            subscriptionCount: filteredSubscriptions.count,
            topCategory: topCategory,
            topCategoryAmount: getTopCategoryAmount()
        ))
        
        if let image = renderer.uiImage {
            shareImage = image
            showingShareSheet = true
        }
    }
    
    private func getTopCategoryAmount() -> Double {
        let grouped = Dictionary(grouping: filteredSubscriptions) { $0.category }
        let totals = grouped.map { ($0.key, $0.value.reduce(0) { $0 + $1.monthlyCost }) }
        return totals.max { $0.1 < $1.1 }?.1 ?? 0
    }
}

// MARK: - Quick Stat Card
struct QuickStatCard: View {
    let title: String
    let value: Double
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(CurrencyManager.shared.format(value))
                    .font(.headline)
                    .fontWeight(.bold)
            }
            Spacer()
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Shareable Report Card
struct ShareableReportCard: View {
    let totalMonthly: Double
    let totalYearly: Double
    let subscriptionCount: Int
    let topCategory: String
    let topCategoryAmount: Double
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "creditcard.and.123")
                .font(.system(size: 50))
                .foregroundStyle(Color.brandPrimary)
            
            Text("My Subscription Report")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(Date().formatted(date: .abbreviated, time: .omitted))
                .font(.caption)
                .foregroundColor(.secondary)
            
            Divider()
                .padding(.horizontal)
            
            VStack(spacing: 16) {
                StatCard(
                    icon: "dollarsign.circle.fill",
                    title: "Monthly Spending",
                    value: CurrencyManager.shared.format(totalMonthly),
                    color: Color.brandPrimary
                )
                
                StatCard(
                    icon: "calendar",
                    title: "Yearly Spending",
                    value: CurrencyManager.shared.format(totalYearly),
                    color: Color.brandSecondary
                )
                
                StatCard(
                    icon: "number.circle.fill",
                    title: "Active Subscriptions",
                    value: "\(subscriptionCount)",
                    color: .green
                )
                
                if topCategory != "None" {
                    StatCard(
                        icon: "chart.pie.fill",
                        title: "Top Category",
                        value: topCategory,
                        subtitle: CurrencyManager.shared.format(topCategoryAmount),
                        color: .orange
                    )
                }
            }
            .padding()
            
            Text("Generated by Spendora")
                .font(.caption2)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding()
        .frame(width: 350, height: 550)
        .background(Color(.systemBackground))
        .cornerRadius(32)
        .shadow(color: .black.opacity(0.1), radius: 20)
    }
}

// MARK: - Stat Card Component
struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    var subtitle: String?
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.title3)
                    .fontWeight(.bold)
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}

// MARK: - Animated Number Component
struct AnimatedNumber: View {
    let value: Double
    @State private var animatedValue: Double = 0
    
    var body: some View {
        Text(CurrencyManager.shared.format(animatedValue))
            .contentTransition(.numericText())
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animatedValue)
            .onAppear {
                animatedValue = value
            }
            .onChange(of: value) { _, newValue in
                withAnimation {
                    animatedValue = newValue
                }
            }
    }
}

// MARK: - Delightful Empty State
struct DelightfulEmptyState: View {
    @State private var bounce = false
    @State private var rotate = false
    
    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(Color.brandPrimary.opacity(0.1))
                    .frame(width: 100, height: 100)
                    .scaleEffect(bounce ? 1.1 : 0.9)
                
                Image(systemName: "creditcard.and.123")
                    .font(.system(size: 44))
                    .foregroundStyle(Color.brandPrimary)
                    .rotationEffect(.degrees(rotate ? 10 : -10))
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                    bounce.toggle()
                }
                withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                    rotate.toggle()
                }
            }
            
            Text("No Subscriptions Yet")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Tap the + button to add your first subscription and start tracking")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

// MARK: - Share Sheet
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Confetti View
struct ConfettiView: View {
    @State private var animate = false
    let onComplete: () -> Void
    
    var body: some View {
        ZStack {
            ForEach(0..<100, id: \.self) { i in
                ConfettiPiece(index: i, animate: animate)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 2.0)) {
                animate = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                onComplete()
            }
        }
    }
}

struct ConfettiPiece: View {
    let index: Int
    let animate: Bool
    
    var body: some View {
        let colors: [Color] = [Color.brandPrimary, Color.brandSecondary, Color.brandAccent, .green, .pink]
        let randomColor = colors[index % colors.count]
        let randomX = CGFloat.random(in: -200...200)
        let randomY = animate ? CGFloat.random(in: 200...700) : -50
        let randomRotation = animate ? Double.random(in: 0...720) : 0
        
        return Rectangle()
            .fill(randomColor)
            .frame(width: 8, height: 8)
            .rotationEffect(.degrees(randomRotation))
            .offset(x: randomX, y: randomY)
            .opacity(animate ? 0 : 1)
            .animation(.easeOut(duration: 1.5).delay(Double(index) * 0.02), value: animate)
    }
}
