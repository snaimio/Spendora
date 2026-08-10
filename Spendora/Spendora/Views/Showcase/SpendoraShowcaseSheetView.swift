//
//  SpendoraShowcaseSheetView.swift
//  Spendora
//
//  Production-ready, clean, modern SwiftUI UI/UX component sheet & 4-panel screen layout
//  strictly adhering to Apple HIG (iOS 17/18) and Slate & Warm Rose-Gold (#C6A473) design patterns.
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

// MARK: - Main Showcase Sheet View (4-Panel Adaptive Grid & Screen Layout)

/**
 `SpendoraShowcaseSheetView` presents the complete production-grade 4-screen layout:
 1. Dashboard Screen (Hero Header Card C$76.26, Quick Stats 3-Col, Segmented Filter, Subscription Cards)
 2. Subscriptions List View (Translucent Search Bar #2C2C2E, Active & Cancelled Card Groups)
 3. Visual Calendar View (Dark Grid with Glowing Rose-Gold Date Rings, Upcoming Billing Feed)
 4. Settings & Data Privacy View (Branded Rose-Gold Logo Header, Unified #C6A473 Action Rows)
 */
struct SpendoraShowcaseSheetView: View {
    @State private var selectedTab: Int = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            // Background Canvas (OLED Charcoal Black #0E0E10 + Ambient Radial Glow)
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
        .preferredColorScheme(.dark)
    }
}

// MARK: - Panel 1: Dashboard Screen

struct ShowcaseDashboardScreen: View {
    @State private var selectedSortIndex = 0
    private let sortOptions = ["Alphabetical", "Billing Date", "Highest Cost", "Category"]

    private let categoryBreakdown: [ShowcaseCategorySpend] = [
        ShowcaseCategorySpend(category: "Productivity", amount: 28.50, color: Color(hex: "#C6A473")),
        ShowcaseCategorySpend(category: "AI Tools", amount: 20.00, color: Color(hex: "#64D2FF")),
        ShowcaseCategorySpend(category: "Entertainment", amount: 17.74, color: Color(hex: "#FF375F")),
        ShowcaseCategorySpend(category: "Music", amount: 10.02, color: Color(hex: "#DFCAA6"))
    ]

    private let upcomingRenewals: [ShowcaseRenewalItem] = [
        ShowcaseRenewalItem(name: "Spotify Premium", category: "Music", cost: 10.02, daysRemaining: 30, icon: "music.note", iconColor: Color(hex: "#C6A473")),
        ShowcaseRenewalItem(name: "ChatGPT Plus", category: "AI Tools", cost: 20.00, daysRemaining: 6, icon: "cpu.fill", iconColor: Color(hex: "#64D2FF")),
        ShowcaseRenewalItem(name: "Netflix Standard", category: "Entertainment", cost: 17.74, daysRemaining: 12, icon: "tv.fill", iconColor: Color(hex: "#FF375F")),
        ShowcaseRenewalItem(name: "iCloud+ 2TB", category: "Productivity", cost: 12.99, daysRemaining: 18, icon: "cloud.fill", iconColor: Color(hex: "#C6A473"))
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Minimal Top Navigation Bar
                    HStack(alignment: .center) {
                        // User Avatar & Greeting
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.brandPrimary, Color.brandAccent],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 40, height: 40)
                                
                                Text("GU")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(Color(hex: "#0E0E10"))
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Good evening,")
                                    .font(AppStyles.Typography.caption)
                                    .foregroundColor(.textSecondary)
                                
                                Text("Gabriel Utterson")
                                    .font(AppStyles.Typography.body)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                            }
                        }

                        Spacer()

                        // Dynamic Quick-Action Button (+)
                        Button {
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.impactOccurred()
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Color(hex: "#0E0E10"))
                                .frame(width: 38, height: 38)
                                .background(Color.brandPrimary)
                                .clipShape(Circle())
                                .shadow(color: Color.brandPrimary.opacity(0.35), radius: 6, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)

                    // Hero Header Card: "THIS MONTH" C$76.26 with Rose-Gold Accent
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Text("THIS MONTH")
                                .font(AppStyles.Typography.micro)
                                .foregroundColor(.textSecondary)
                                .tracking(1.2)

                            Spacer()

                            Text("October 2026")
                                .font(AppStyles.Typography.caption)
                                .foregroundColor(.brandPrimary)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("C$76.26")
                                .font(AppStyles.Typography.heroPrice)
                                .foregroundColor(.white)

                            Text("4 active subscriptions")
                                .font(AppStyles.Typography.subheadline)
                                .foregroundColor(.textSecondary)
                        }

                        // Rose-Gold Mini Progress Line
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color.white.opacity(0.08))
                                    .frame(height: 5)

                                Capsule()
                                    .fill(Color.brandPrimary)
                                    .frame(width: geo.size.width * 0.62, height: 5)
                            }
                        }
                        .frame(height: 5)
                        .padding(.top, 2)
                    }
                    .padding(AppStyles.Spacing.cardPadding)
                    .appleCard(cornerRadius: AppStyles.Radius.hero)
                    .padding(.horizontal, 20)

                    // Quick Stats Row: 3-Column Balanced Metric Tiles
                    HStack(spacing: 10) {
                        MetricSubCard(title: "Yearly", value: "C$915.12")
                        MetricSubCard(title: "Average", value: "C$19.07")
                        MetricSubCard(title: "Total", value: "4")
                    }
                    .padding(.horizontal, 20)

                    // Filter Bar: Segmented Controls with Capsule Highlight
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(sortOptions.indices, id: \.self) { idx in
                                Button {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedSortIndex = idx
                                    }
                                } label: {
                                    Text(sortOptions[idx])
                                        .font(AppStyles.Typography.captionBold)
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 7)
                                        .background(
                                            Capsule()
                                                .fill(selectedSortIndex == idx ? Color.brandPrimary : Color(hex: "#2C2C2E"))
                                        )
                                        .foregroundColor(selectedSortIndex == idx ? Color(hex: "#0E0E10") : .textSecondary)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.vertical, 2)

                    // Subscription Cards Stack
                    VStack(spacing: 12) {
                        ForEach(upcomingRenewals) { item in
                            HStack(alignment: .top, spacing: AppStyles.Spacing.medium) {
                                ZStack {
                                    Circle()
                                        .fill(item.iconColor.opacity(0.15))
                                        .frame(width: 42, height: 42)

                                    Image(systemName: item.icon)
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(item.iconColor)
                                }

                                VStack(alignment: .leading, spacing: AppStyles.Spacing.element) {
                                    HStack {
                                        Text(item.name)
                                            .font(AppStyles.Typography.headline)
                                            .foregroundColor(.white)

                                        Spacer()

                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 13, weight: .semibold))
                                            .foregroundColor(.textTertiary)
                                    }

                                    HStack(spacing: 4) {
                                        Text(item.category)
                                            .font(AppStyles.Typography.subheadline)
                                            .foregroundColor(.textSecondary)

                                        Text("•")
                                            .font(AppStyles.Typography.caption)
                                            .foregroundColor(.textTertiary)

                                        Text("Monthly")
                                            .font(AppStyles.Typography.subheadline)
                                            .foregroundColor(.textSecondary)
                                    }

                                    HStack(spacing: 4) {
                                        Text(String(format: "C$%.2f/month", item.cost))
                                            .font(Font.system(size: 15, weight: .semibold).monospacedDigit())
                                            .foregroundColor(.white)
                                    }

                                    CountdownChip(daysRemaining: item.daysRemaining)
                                        .padding(.top, 2)
                                }
                            }
                            .padding(AppStyles.Spacing.cardPadding)
                            .appleCard(cornerRadius: AppStyles.Radius.card)
                        }
                    }
                    .padding(.horizontal, 20)
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
        ShowcaseRenewalItem(name: "Spotify Premium", category: "Music", cost: 10.02, daysRemaining: 30, icon: "music.note", iconColor: Color.brandPrimary),
        ShowcaseRenewalItem(name: "ChatGPT Plus", category: "AI Tools", cost: 20.00, daysRemaining: 6, icon: "cpu.fill", iconColor: Color(hex: "#64D2FF")),
        ShowcaseRenewalItem(name: "Netflix Standard", category: "Entertainment", cost: 17.74, daysRemaining: 12, icon: "tv.fill", iconColor: Color(hex: "#FF375F")),
        ShowcaseRenewalItem(name: "iCloud+ 2TB", category: "Productivity", cost: 12.99, daysRemaining: 18, icon: "cloud.fill", iconColor: Color.brandPrimary)
    ]

    private let cancelledList: [ShowcaseRenewalItem] = [
        ShowcaseRenewalItem(name: "Paramount+", category: "Entertainment", cost: 9.99, daysRemaining: 0, icon: "play.tv.fill", iconColor: Color.textSecondary, isCancelled: true),
        ShowcaseRenewalItem(name: "Duolingo Plus", category: "Education", cost: 6.99, daysRemaining: 0, icon: "character.book.closed.fill", iconColor: Color.textSecondary, isCancelled: true)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("PORTFOLIO")
                                .font(AppStyles.Typography.micro)
                                .foregroundColor(.textSecondary)
                                .tracking(1.2)

                            Text("Subscriptions")
                                .font(AppStyles.Typography.title)
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)

                    // Integrated Top Search Bar (#2C2C2E border stroke)
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.textSecondary)
                            .font(.system(size: 15))

                        TextField("Search all subscriptions...", text: $searchText)
                            .font(AppStyles.Typography.body)
                            .foregroundColor(.white)
                            .autocorrectionDisabled()
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(Color.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(Color(hex: "#2C2C2E"), lineWidth: 1)
                    )
                    .padding(.horizontal, 20)

                    // Active Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Active (\(activeList.count))")
                                .font(AppStyles.Typography.captionBold)
                                .foregroundColor(.textSecondary)
                                .textCase(.uppercase)
                                .tracking(1.0)
                            Spacer()
                        }
                        .padding(.horizontal, 20)

                        VStack(spacing: 12) {
                            ForEach(activeList) { item in
                                ShowcaseRowView(item: item)
                            }
                        }
                        .padding(.horizontal, 20)
                    }

                    // Cancelled Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Cancelled & Paused (\(cancelledList.count))")
                                .font(AppStyles.Typography.captionBold)
                                .foregroundColor(.textSecondary)
                                .textCase(.uppercase)
                                .tracking(1.0)
                            Spacer()
                        }
                        .padding(.horizontal, 20)

                        VStack(spacing: 12) {
                            ForEach(cancelledList) { item in
                                ShowcaseRowView(item: item)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
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
        HStack(alignment: .top, spacing: AppStyles.Spacing.medium) {
            ZStack {
                Circle()
                    .fill(item.iconColor.opacity(0.15))
                    .frame(width: 42, height: 42)

                Image(systemName: item.icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(item.iconColor)
            }

            VStack(alignment: .leading, spacing: AppStyles.Spacing.element) {
                HStack {
                    Text(item.name)
                        .font(AppStyles.Typography.headline)
                        .foregroundColor(.white)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.textTertiary)
                }

                HStack(spacing: 4) {
                    Text(item.category)
                        .font(AppStyles.Typography.subheadline)
                        .foregroundColor(.textSecondary)

                    Text("•")
                        .font(AppStyles.Typography.caption)
                        .foregroundColor(.textTertiary)

                    Text(String(format: "C$%.2f/mo", item.cost))
                        .font(Font.system(size: 14, weight: .semibold).monospacedDigit())
                        .foregroundColor(.white)
                }

                CountdownChip(daysRemaining: item.daysRemaining, isCancelled: item.isCancelled)
                    .padding(.top, 2)
            }
        }
        .padding(AppStyles.Spacing.cardPadding)
        .appleCard(cornerRadius: AppStyles.Radius.card)
    }
}

// MARK: - Panel 3: Visual Calendar Screen

struct ShowcaseCalendarScreen: View {
    private let calendarDays: [Int] = Array(1...31)
    private let billingDates: Set<Int> = [3, 6, 12, 18]

    private let upcomingFeed: [ShowcaseRenewalItem] = [
        ShowcaseRenewalItem(name: "ChatGPT Plus", category: "AI Tools", cost: 20.00, daysRemaining: 6, icon: "cpu.fill", iconColor: Color(hex: "#64D2FF")),
        ShowcaseRenewalItem(name: "Netflix Standard", category: "Entertainment", cost: 17.74, daysRemaining: 12, icon: "tv.fill", iconColor: Color(hex: "#FF375F")),
        ShowcaseRenewalItem(name: "iCloud+ 2TB", category: "Productivity", cost: 12.99, daysRemaining: 18, icon: "cloud.fill", iconColor: Color.brandPrimary)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("SCHEDULE")
                                .font(AppStyles.Typography.micro)
                                .foregroundColor(.textSecondary)
                                .tracking(1.2)

                            Text("Renewal Calendar")
                                .font(AppStyles.Typography.title)
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)

                    // Sleek Dark Calendar Grid with Glowing Rose-Gold Rings
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.brandPrimary)
                                .padding(8)
                                .background(Color.brandPrimary.opacity(0.12))
                                .clipShape(Circle())

                            Spacer()

                            Text("October 2026")
                                .font(AppStyles.Typography.headline)
                                .foregroundColor(.white)

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.brandPrimary)
                                .padding(8)
                                .background(Color.brandPrimary.opacity(0.12))
                                .clipShape(Circle())
                        }

                        // Day Headers
                        HStack {
                            ForEach(["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"], id: \.self) { day in
                                Text(day)
                                    .font(AppStyles.Typography.micro)
                                    .foregroundColor(.textSecondary)
                                    .frame(maxWidth: .infinity)
                            }
                        }

                        // Grid
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                            ForEach(calendarDays, id: \.self) { day in
                                VStack(spacing: 3) {
                                    Text("\(day)")
                                        .font(Font.system(size: 13, weight: billingDates.contains(day) ? .bold : .regular).monospacedDigit())
                                        .foregroundColor(day == 10 ? Color(hex: "#0E0E10") : (billingDates.contains(day) ? .white : .textSecondary))
                                        .frame(width: 30, height: 30)
                                        .background(
                                            Group {
                                                if day == 10 {
                                                    // Today Indicator (Rose-Gold)
                                                    Circle()
                                                        .fill(Color.brandPrimary)
                                                        .shadow(color: Color.brandPrimary.opacity(0.4), radius: 6, x: 0, y: 2)
                                                } else if billingDates.contains(day) {
                                                    // Active Billing Day Glowing Ring
                                                    Circle()
                                                        .stroke(Color.brandPrimary, lineWidth: 1.5)
                                                        .background(Circle().fill(Color.brandPrimary.opacity(0.14)))
                                                }
                                            }
                                        )

                                    if billingDates.contains(day) {
                                        Circle()
                                            .fill(Color.brandPrimary)
                                            .frame(width: 4, height: 4)
                                    } else {
                                        Spacer().frame(height: 4)
                                    }
                                }
                            }
                        }
                    }
                    .padding(AppStyles.Spacing.cardPadding)
                    .appleCard(cornerRadius: AppStyles.Radius.hero)
                    .padding(.horizontal, 20)

                    // Upcoming Billing Days Feed
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 6) {
                            Image(systemName: "calendar.badge.clock")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.brandPrimary)

                            Text("UPCOMING BILLING DAYS")
                                .font(AppStyles.Typography.micro)
                                .foregroundColor(.textSecondary)
                                .tracking(1.2)
                        }
                        .padding(.horizontal, 20)

                        VStack(spacing: 10) {
                            ForEach(upcomingFeed) { item in
                                HStack(spacing: 12) {
                                    ZStack {
                                        Circle()
                                            .fill(item.iconColor.opacity(0.15))
                                            .frame(width: 38, height: 38)
                                        Image(systemName: item.icon)
                                            .foregroundColor(item.iconColor)
                                            .font(.system(size: 16, weight: .semibold))
                                    }

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(item.name)
                                            .font(AppStyles.Typography.body)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                        Text("Due in \(item.daysRemaining) days")
                                            .font(AppStyles.Typography.caption)
                                            .foregroundColor(.textSecondary)
                                    }

                                    Spacer()

                                    Text(String(format: "C$%.2f", item.cost))
                                        .font(Font.system(size: 15, weight: .semibold).monospacedDigit())
                                        .foregroundColor(.white)
                                }
                                .padding(14)
                                .appleCard(cornerRadius: AppStyles.Radius.card)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 90)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Panel 4: Settings & Data Privacy View

struct ShowcaseSettingsScreen: View {
    @State private var biometricAuthEnabled: Bool = true
    @State private var pushNotificationsEnabled: Bool = true
    @State private var icloudSyncEnabled: Bool = true
    @State private var selectedCurrencyIndex: Int = 0
    private let currencies = ["CAD ($)", "USD ($)", "EUR (€)", "GBP (£)"]

    var body: some View {
        NavigationStack {
            Form {
                // Branded Rose-Gold Logo Header Card
                Section {
                    HStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.brandPrimary, Color.brandAccent],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 52, height: 52)

                            Image("SpendoraLogo")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 48, height: 48)
                                .clipShape(Circle())
                        }

                        VStack(alignment: .leading, spacing: 3) {
                            HStack(spacing: 6) {
                                Text("SPENDORA")
                                    .font(.system(size: 17, weight: .black))
                                    .tracking(1.2)
                                    .foregroundColor(.white)

                                Text("CAPSTONE")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundColor(Color(hex: "#0E0E10"))
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.brandPrimary)
                                    .clipShape(Capsule())
                            }

                            Text("Smart Subscription & Expense Intelligence")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.textSecondary)
                        }
                    }
                    .padding(.vertical, 6)
                }
                .listRowBackground(Color.cardBackground)

                // Section: Security & Alerts
                Section("Security & Alerts") {
                    Toggle(isOn: $biometricAuthEnabled) {
                        HStack(spacing: 12) {
                            Image(systemName: "faceid")
                                .font(.system(size: 17))
                                .foregroundColor(.brandPrimary)
                                .frame(width: 24)

                            Text("Face ID & Passcode")
                                .foregroundColor(.white)
                        }
                    }
                    .tint(.brandPrimary)

                    Toggle(isOn: $pushNotificationsEnabled) {
                        HStack(spacing: 12) {
                            Image(systemName: "bell.badge.fill")
                                .font(.system(size: 17))
                                .foregroundColor(.brandPrimary)
                                .frame(width: 24)

                            Text("Billing Push Reminders")
                                .foregroundColor(.white)
                        }
                    }
                    .tint(.brandPrimary)
                }
                .listRowBackground(Color.cardBackground)

                // Section: Preferences
                Section("Preferences") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Default Portfolio Currency")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.textSecondary)

                        Picker("Currency", selection: $selectedCurrencyIndex) {
                            ForEach(currencies.indices, id: \.self) { idx in
                                Text(currencies[idx]).tag(idx)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding(.vertical, 4)
                }
                .listRowBackground(Color.cardBackground)

                // Section: Data & Backup
                Section("Data Management") {
                    HStack {
                        Image(systemName: "tablecells.fill")
                            .foregroundColor(.brandPrimary)
                            .frame(width: 24)
                        Text("Export to CSV (Spreadsheet)")
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }

                    HStack {
                        Image(systemName: "doc.text.fill")
                            .foregroundColor(.brandPrimary)
                            .frame(width: 24)
                        Text("Export Executive Annual PDF")
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }

                    HStack {
                        Image(systemName: "arrow.down.doc.fill")
                            .foregroundColor(.brandPrimary)
                            .frame(width: 24)
                        Text("Download Full JSON Backup")
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                } footer: {
                    Text("Your financial records stay 100% on-device and private. Zero external cloud tracking.")
                        .foregroundColor(.textSecondary)
                }
                .listRowBackground(Color.cardBackground)
            }
            .scrollContentBackground(.hidden)
            .background(Color.appBackground)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.bottom, 70)
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
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        selectedTab = idx
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: tabs[idx].icon)
                            .font(.system(size: 18, weight: selectedTab == idx ? .bold : .regular))
                            .foregroundColor(selectedTab == idx ? Color.brandPrimary : Color.textSecondary)

                        Text(tabs[idx].label)
                            .font(.system(size: 10, weight: selectedTab == idx ? .semibold : .regular))
                            .foregroundColor(selectedTab == idx ? Color.brandPrimary : Color.textSecondary)
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
                .stroke(Color(hex: "#2C2C2E").opacity(0.8), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.5), radius: 16, x: 0, y: 6)
    }
}

// MARK: - Previews

#Preview("Spendora 4-Panel Luxury Showcase") {
    SpendoraShowcaseSheetView()
}
