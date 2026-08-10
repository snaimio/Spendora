//
//  SpendoraShowcaseSheetView.swift
//  Spendora
//
//  Production-ready, clean, modern SwiftUI UI/UX component sheet & 4-panel screen layout
//  strictly adhering to Spendora's Golden UX (20pt Card Radius, Coral Fire #FF6B6B Accent).
//

import SwiftUI
import Charts

// MARK: - Sample Data Models

struct ShowcaseCategorySpend: Identifiable {
    let id = UUID()
    let category: String
    let amount: Double
    let color: Color
}

struct ShowcaseRenewalItem: Identifiable {
    let id = UUID()
    let name: String
    let category: String
    let cost: Double
    let daysRemaining: Int
    let icon: String
    let iconColor: Color
    var isCancelled: Bool = false
}

// MARK: - Main Showcase Sheet View (4-Panel Adaptive Screen Layout)

struct SpendoraShowcaseSheetView: View {
    @State private var selectedTab: Int = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            // Background Canvas (#FFFBF5 Light / #0F0E17 Dark)
            SpendoraBrandBackgroundView()

            // 4-Screen Page View Carousel
            TabView(selection: $selectedTab) {
                ShowcaseDashboardScreen()
                    .tag(0)

                ShowcaseSubscriptionsListScreen()
                    .tag(1)

                ShowcaseCalendarScreen()
                    .tag(2)

                ShowcaseSettingsScreen()
                    .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea(edges: .bottom)

            // Floating Glassmorphism Bottom Tab Bar
            ShowcaseFloatingTabBar(selectedTab: $selectedTab)
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
        }
    }
}

// MARK: - Panel 1: Dashboard Screen

struct ShowcaseDashboardScreen: View {
    @State private var selectedSortIndex = 0
    private let sortOptions = ["Alphabetical", "Billing Date", "Highest Cost", "Category"]

    private let upcomingRenewals: [ShowcaseRenewalItem] = [
        ShowcaseRenewalItem(name: "Spotify Premium", category: "Music", cost: 10.02, daysRemaining: 30, icon: "music.note", iconColor: Color(hex: "#FF6B6B")),
        ShowcaseRenewalItem(name: "ChatGPT Plus", category: "AI Tools", cost: 20.00, daysRemaining: 6, icon: "cpu.fill", iconColor: Color(hex: "#06B6D4")),
        ShowcaseRenewalItem(name: "Netflix Standard", category: "Entertainment", cost: 17.74, daysRemaining: 12, icon: "tv.fill", iconColor: Color(hex: "#FF4757")),
        ShowcaseRenewalItem(name: "iCloud+ 2TB", category: "Productivity", cost: 12.99, daysRemaining: 18, icon: "cloud.fill", iconColor: Color(hex: "#00C9A7"))
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: SpendoraTheme.Spacing.md) {
                    // Navigation Bar (Left bell, center title, right +/menu/avatar)
                    HStack(alignment: .center) {
                        Image(systemName: "bell.fill")
                            .font(.system(size: 22))
                            .foregroundColor(SpendoraTheme.Colors.coral)

                        Spacer()

                        Text("Dashboard")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(SpendoraTheme.Colors.textPrimary)

                        Spacer()

                        HStack(spacing: 8) {
                            // Coral gradient + button 36x36pt circle
                            Button { } label: {
                                Image(systemName: "plus")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 36, height: 36)
                                    .background(SpendoraTheme.Colors.coralGradient)
                                    .clipShape(Circle())
                                    .shadow(color: SpendoraTheme.Colors.coral.opacity(0.35), radius: 6, y: 2)
                            }

                            // Avatar GU circle coral
                            ZStack {
                                Circle()
                                    .fill(SpendoraTheme.Colors.coralGradient)
                                    .frame(width: 34, height: 34)
                                Text("GU")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.horizontal, SpendoraTheme.Spacing.lg)
                    .padding(.top, 8)

                    // Hero Spend Card (20pt radius, white, coral shadow)
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Text("THIS MONTH")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(SpendoraTheme.Colors.coralWarm)
                                .tracking(1.2)

                            Spacer()

                            Text("October 2026")
                                .font(SpendoraTheme.Typography.caption)
                                .foregroundColor(SpendoraTheme.Colors.coral)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("C$76.26")
                                .font(SpendoraTheme.Typography.heroAmount)
                                .foregroundColor(SpendoraTheme.Colors.textPrimary)

                            Text("4 active subscriptions")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(SpendoraTheme.Colors.textSecondary)
                        }

                        // Divider 0.5pt full width
                        Divider()
                            .background(SpendoraTheme.Colors.border)

                        // Next charge row: service icon 44x44, name 17pt, date 13pt, cost 17pt coral
                        HStack(alignment: .center, spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(SpendoraTheme.Colors.coral.opacity(0.15))
                                    .frame(width: 44, height: 44)
                                Image(systemName: "cpu.fill")
                                    .foregroundColor(SpendoraTheme.Colors.coral)
                                    .font(.system(size: 18, weight: .semibold))
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text("ChatGPT Plus")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(SpendoraTheme.Colors.textPrimary)
                                Text("Due in 6 days")
                                    .font(SpendoraTheme.Typography.caption)
                                    .foregroundColor(SpendoraTheme.Colors.textSecondary)
                            }

                            Spacer()

                            Text("C$20.00")
                                .font(Font.system(size: 17, weight: .semibold).monospacedDigit())
                                .foregroundColor(SpendoraTheme.Colors.coral)
                        }
                        .padding(.top, 2)

                        CountdownChip(daysRemaining: 6)
                    }
                    .padding(SpendoraTheme.Spacing.lg)
                    .spendoraCard(cornerRadius: SpendoraTheme.Radius.hero)
                    .padding(.horizontal, SpendoraTheme.Spacing.lg)

                    // Stat Row: 3 equal cards with 10pt spacing (12pt radius, 12pt padding)
                    HStack(spacing: 10) {
                        MetricSubCard(title: "YEARLY", value: "C$915.12")
                        MetricSubCard(title: "AVERAGE", value: "C$19.07")
                        MetricSubCard(title: "TOTAL", value: "4")
                    }
                    .padding(.horizontal, SpendoraTheme.Spacing.lg)

                    // Sort Pills (Horizontal scroll, active coral gradient)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(sortOptions.indices, id: \.self) { idx in
                                Button {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedSortIndex = idx
                                    }
                                } label: {
                                    Text(sortOptions[idx])
                                        .font(.system(size: 12, weight: .semibold))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(
                                            Group {
                                                if selectedSortIndex == idx {
                                                    SpendoraTheme.Colors.coralGradient
                                                } else {
                                                    LinearGradient(
                                                        colors: [SpendoraTheme.Colors.coralTint, SpendoraTheme.Colors.coralTint],
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    )
                                                }
                                            }
                                        )
                                        .clipShape(Capsule())
                                        .foregroundColor(selectedSortIndex == idx ? .white : SpendoraTheme.Colors.coralWarm)
                                }
                            }
                        }
                        .padding(.horizontal, SpendoraTheme.Spacing.lg)
                    }
                    .padding(.vertical, 2)

                    // Subscription Cards Stack (20pt radius, 16pt padding, 10pt spacing)
                    VStack(spacing: 10) {
                        ForEach(upcomingRenewals) { item in
                            HStack(alignment: .top, spacing: SpendoraTheme.Spacing.md) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: SpendoraTheme.Radius.iconBox, style: .continuous)
                                        .fill(item.iconColor.opacity(0.20))
                                        .frame(width: 46, height: 46)

                                    Image(systemName: item.icon)
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(item.iconColor)
                                }

                                VStack(alignment: .leading, spacing: SpendoraTheme.Spacing.xs) {
                                    HStack {
                                        Text(item.name)
                                            .font(.system(size: 17, weight: .semibold))
                                            .foregroundColor(SpendoraTheme.Colors.textPrimary)

                                        Spacer()

                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 13, weight: .semibold))
                                            .foregroundColor(SpendoraTheme.Colors.chevron)
                                    }

                                    HStack(spacing: 4) {
                                        Text(item.category)
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(item.iconColor)

                                        Text("·")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(SpendoraTheme.Colors.textTertiary)

                                        Text("Monthly")
                                            .font(.system(size: 14, weight: .regular))
                                            .foregroundColor(SpendoraTheme.Colors.textSecondary)
                                    }

                                    HStack(spacing: 4) {
                                        Text(String(format: "C$%.2f/month", item.cost))
                                            .font(Font.system(size: 15, weight: .semibold).monospacedDigit())
                                            .foregroundColor(SpendoraTheme.Colors.textPrimary)

                                        Spacer()

                                        Text("Next: Oct \(item.daysRemaining)")
                                            .font(.system(size: 13))
                                            .foregroundColor(SpendoraTheme.Colors.textSecondary)
                                    }

                                    CountdownChip(daysRemaining: item.daysRemaining)
                                        .padding(.top, 8)
                                }
                            }
                            .padding(SpendoraTheme.Spacing.lg)
                            .spendoraCard(cornerRadius: SpendoraTheme.Radius.card)
                        }
                    }
                    .padding(.horizontal, SpendoraTheme.Spacing.lg)
                    .padding(.bottom, 90)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Panel 2: Subscriptions List Screen

struct ShowcaseSubscriptionsListScreen: View {
    @State private var searchText = ""

    private let activeList: [ShowcaseRenewalItem] = [
        ShowcaseRenewalItem(name: "Spotify Premium", category: "Music", cost: 10.02, daysRemaining: 30, icon: "music.note", iconColor: Color(hex: "#FF6B6B")),
        ShowcaseRenewalItem(name: "ChatGPT Plus", category: "AI Tools", cost: 20.00, daysRemaining: 6, icon: "cpu.fill", iconColor: Color(hex: "#06B6D4")),
        ShowcaseRenewalItem(name: "Netflix Standard", category: "Entertainment", cost: 17.74, daysRemaining: 12, icon: "tv.fill", iconColor: Color(hex: "#FF4757")),
        ShowcaseRenewalItem(name: "iCloud+ 2TB", category: "Productivity", cost: 12.99, daysRemaining: 18, icon: "cloud.fill", iconColor: Color(hex: "#00C9A7"))
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: SpendoraTheme.Spacing.xl) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("PORTFOLIO")
                                .font(SpendoraTheme.Typography.label)
                                .foregroundColor(SpendoraTheme.Colors.coralWarm)
                                .tracking(1.2)

                            Text("Subscriptions")
                                .font(SpendoraTheme.Typography.largeTitle)
                                .foregroundColor(SpendoraTheme.Colors.textPrimary)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, SpendoraTheme.Spacing.lg)
                    .padding(.top, 8)

                    // Search Bar
                    SearchBarView(searchText: $searchText)
                        .padding(.horizontal, SpendoraTheme.Spacing.lg)

                    // Summary Row
                    HStack {
                        Text("\(activeList.count) subscriptions")
                            .font(.system(size: 13))
                            .foregroundColor(SpendoraTheme.Colors.textSecondary)

                        Spacer()

                        Text("Monthly Total: C$60.75")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(SpendoraTheme.Colors.coral)
                    }
                    .padding(.horizontal, SpendoraTheme.Spacing.lg)

                    // Cards
                    VStack(spacing: 10) {
                        ForEach(activeList) { item in
                            ShowcaseRowView(item: item)
                        }
                    }
                    .padding(.horizontal, SpendoraTheme.Spacing.lg)
                    .padding(.bottom, 90)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct ShowcaseRowView: View {
    let item: ShowcaseRenewalItem

    var body: some View {
        HStack(alignment: .top, spacing: SpendoraTheme.Spacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: SpendoraTheme.Radius.iconBox, style: .continuous)
                    .fill(item.iconColor.opacity(0.20))
                    .frame(width: 46, height: 46)

                Image(systemName: item.icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(item.iconColor)
            }

            VStack(alignment: .leading, spacing: SpendoraTheme.Spacing.xs) {
                HStack {
                    Text(item.name)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(SpendoraTheme.Colors.textPrimary)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(SpendoraTheme.Colors.chevron)
                }

                HStack(spacing: 4) {
                    Text(item.category)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(item.iconColor)

                    Text("·")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(SpendoraTheme.Colors.textTertiary)

                    Text(String(format: "C$%.2f/mo", item.cost))
                        .font(Font.system(size: 14, weight: .semibold).monospacedDigit())
                        .foregroundColor(SpendoraTheme.Colors.textPrimary)
                }

                CountdownChip(daysRemaining: item.daysRemaining, isCancelled: item.isCancelled)
                    .padding(.top, 8)
            }
        }
        .padding(SpendoraTheme.Spacing.lg)
        .spendoraCard(cornerRadius: SpendoraTheme.Radius.card)
    }
}

// MARK: - Panel 3: Visual Calendar Screen

struct ShowcaseCalendarScreen: View {
    private let calendarDays: [Int] = Array(1...31)
    private let billingDates: Set<Int> = [3, 6, 12, 18]

    private let upcomingFeed: [ShowcaseRenewalItem] = [
        ShowcaseRenewalItem(name: "ChatGPT Plus", category: "AI Tools", cost: 20.00, daysRemaining: 6, icon: "cpu.fill", iconColor: Color(hex: "#06B6D4")),
        ShowcaseRenewalItem(name: "Netflix Standard", category: "Entertainment", cost: 17.74, daysRemaining: 12, icon: "tv.fill", iconColor: Color(hex: "#FF4757")),
        ShowcaseRenewalItem(name: "iCloud+ 2TB", category: "Productivity", cost: 12.99, daysRemaining: 18, icon: "cloud.fill", iconColor: Color(hex: "#00C9A7"))
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: SpendoraTheme.Spacing.xxl) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("SCHEDULE")
                                .font(SpendoraTheme.Typography.label)
                                .foregroundColor(SpendoraTheme.Colors.coralWarm)
                                .tracking(1.2)

                            Text("Renewal Calendar")
                                .font(SpendoraTheme.Typography.largeTitle)
                                .foregroundColor(SpendoraTheme.Colors.textPrimary)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, SpendoraTheme.Spacing.lg)
                    .padding(.top, 8)

                    // Calendar Card (20pt radius)
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(SpendoraTheme.Colors.coral)
                                .frame(width: 36, height: 36)
                                .background(SpendoraTheme.Colors.coralTint)
                                .clipShape(Circle())

                            Spacer()

                            Text("October 2026")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(SpendoraTheme.Colors.textPrimary)

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(SpendoraTheme.Colors.coral)
                                .frame(width: 36, height: 36)
                                .background(SpendoraTheme.Colors.coralTint)
                                .clipShape(Circle())
                        }

                        // Day Headers
                        HStack {
                            ForEach(["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"], id: \.self) { day in
                                Text(day)
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(SpendoraTheme.Colors.textSecondary)
                                    .frame(maxWidth: .infinity)
                            }
                        }

                        // 44x44pt Grid Cells
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                            ForEach(calendarDays, id: \.self) { day in
                                VStack(spacing: 2) {
                                    Text("\(day)")
                                        .font(Font.system(size: 13, weight: (day == 10 || billingDates.contains(day)) ? .bold : .regular).monospacedDigit())
                                        .foregroundColor(day == 10 ? .white : (billingDates.contains(day) ? SpendoraTheme.Colors.textPrimary : SpendoraTheme.Colors.textSecondary))
                                        .frame(width: 36, height: 36)
                                        .background(
                                            Group {
                                                if day == 10 {
                                                    Circle()
                                                        .fill(SpendoraTheme.Colors.coralGradient)
                                                        .shadow(color: SpendoraTheme.Colors.coral.opacity(0.35), radius: 6, x: 0, y: 2)
                                                } else if billingDates.contains(day) {
                                                    Circle()
                                                        .stroke(SpendoraTheme.Colors.coral, lineWidth: 2.0)
                                                        .background(Circle().fill(SpendoraTheme.Colors.coralTint))
                                                }
                                            }
                                        )

                                    if billingDates.contains(day) {
                                        Circle()
                                            .fill(SpendoraTheme.Colors.coral)
                                            .frame(width: 5, height: 5)
                                    } else {
                                        Spacer().frame(height: 5)
                                    }
                                }
                                .frame(width: 44, height: 44)
                            }
                        }
                    }
                    .padding(SpendoraTheme.Spacing.lg)
                    .spendoraCard(cornerRadius: SpendoraTheme.Radius.hero)
                    .padding(.horizontal, SpendoraTheme.Spacing.lg)

                    // Upcoming Billing Feed (Left 3pt coral bar)
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 6) {
                            Image(systemName: "calendar.badge.clock")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(SpendoraTheme.Colors.coral)

                            Text("UPCOMING BILLING DAYS")
                                .font(SpendoraTheme.Typography.label)
                                .foregroundColor(SpendoraTheme.Colors.coralWarm)
                                .tracking(1.2)
                        }
                        .padding(.horizontal, SpendoraTheme.Spacing.lg)

                        VStack(spacing: 10) {
                            ForEach(upcomingFeed) { item in
                                HStack(spacing: 10) {
                                    RoundedRectangle(cornerRadius: 1.5)
                                        .fill(SpendoraTheme.Colors.coral)
                                        .frame(width: 3, height: 44)

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(item.name)
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(SpendoraTheme.Colors.textPrimary)
                                        Text("Due in \(item.daysRemaining) days")
                                            .font(SpendoraTheme.Typography.caption)
                                            .foregroundColor(SpendoraTheme.Colors.textSecondary)
                                    }

                                    Spacer()

                                    Text(String(format: "C$%.2f", item.cost))
                                        .font(Font.system(size: 16, weight: .semibold).monospacedDigit())
                                        .foregroundColor(SpendoraTheme.Colors.coral)
                                }
                                .padding(14)
                                .spendoraCard(cornerRadius: 16)
                            }
                        }
                        .padding(.horizontal, SpendoraTheme.Spacing.lg)
                    }
                    .padding(.bottom, 90)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Panel 4: Settings Screen

struct ShowcaseSettingsScreen: View {
    @State private var biometricAuthEnabled: Bool = true
    @State private var pushNotificationsEnabled: Bool = true

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: SpendoraTheme.Spacing.xl) {
                    // Header Brand Card
                    PremiumAppInfoRow()
                        .padding(.horizontal, SpendoraTheme.Spacing.lg)
                        .padding(.top, 8)

                    // Profile Row
                    SettingsUserProfileRow(onTap: {})
                        .padding(.horizontal, SpendoraTheme.Spacing.lg)
                        .spendoraCard(cornerRadius: 16)
                        .padding(.horizontal, SpendoraTheme.Spacing.lg)

                    // Data Actions Card
                    VStack(spacing: 0) {
                        PremiumSettingsRow(
                            icon: "square.and.arrow.up",
                            title: "Export to CSV",
                            subtitle: "Download spreadsheet records"
                        )
                        
                        Divider().background(SpendoraTheme.Colors.border)

                        PremiumSettingsRow(
                            icon: "doc.richtext",
                            title: "Export to PDF",
                            subtitle: "Generate annual report document"
                        )
                        
                        Divider().background(SpendoraTheme.Colors.border)

                        PremiumSettingsRow(
                            icon: "trash.fill",
                            title: "Reset All Data",
                            subtitle: "Permanently delete records",
                            isDestructive: true
                        )
                    }
                    .padding(.horizontal, SpendoraTheme.Spacing.lg)
                    .spendoraCard(cornerRadius: 16)
                    .padding(.horizontal, SpendoraTheme.Spacing.lg)
                    .padding(.bottom, 90)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Floating Glassmorphism Bottom Tab Bar

struct ShowcaseFloatingTabBar: View {
    @Binding var selectedTab: Int

    private let tabs: [(icon: String, label: String)] = [
        ("square.grid.2x2.fill", "Dashboard"),
        ("list.bullet", "Subscriptions"),
        ("calendar", "Calendar"),
        ("gearshape.fill", "Settings")
    ]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs.indices, id: \.self) { idx in
                Button {
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = idx
                    }
                } label: {
                    VStack(spacing: 2) {
                        ZStack {
                            if selectedTab == idx {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(SpendoraTheme.Colors.coralTint)
                                    .frame(width: 32, height: 28)
                            }
                            
                            Image(systemName: tabs[idx].icon)
                                .font(.system(size: 17, weight: selectedTab == idx ? .bold : .regular))
                                .foregroundColor(selectedTab == idx ? SpendoraTheme.Colors.coral : SpendoraTheme.Colors.textTertiary)
                        }

                        Text(tabs[idx].label)
                            .font(.system(size: 10, weight: selectedTab == idx ? .semibold : .regular))
                            .foregroundColor(selectedTab == idx ? SpendoraTheme.Colors.coral : SpendoraTheme.Colors.textTertiary)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                }
            }
        }
        .padding(.horizontal, 10)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(SpendoraTheme.Colors.border, lineWidth: 0.5)
        )
        .shadow(color: SpendoraTheme.Colors.coral.opacity(0.10), radius: 16, x: 0, y: 6)
    }
}
