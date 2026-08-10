//
//  SpendoraShowcaseSheetView.swift
//  Spendora
//
//  Production-ready, clean, modern SwiftUI UI/UX component sheet & 4-panel screen layout
//  strictly adhering to Spendora's 60-30-10 Warm Cream & Coral Fire Design System.
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
                    // Top Navigation Bar
                    HStack(alignment: .center) {
                        // User Avatar (Warm Coral) & Greeting
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(SpendoraTheme.Colors.coralGradient)
                                    .frame(width: 40, height: 40)
                                
                                Text("GU")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Good evening,")
                                    .font(SpendoraTheme.Typography.caption)
                                    .foregroundColor(SpendoraTheme.Colors.textSecondary)
                                
                                Text("Gabriel Utterson")
                                    .font(SpendoraTheme.Typography.body)
                                    .fontWeight(.semibold)
                                    .foregroundColor(SpendoraTheme.Colors.textPrimary)
                            }
                        }

                        Spacer()

                        // Bell Icon in Coral
                        Image(systemName: "bell.fill")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(SpendoraTheme.Colors.coral)
                            .padding(.trailing, 6)

                        // + Button Coral Gradient Pill
                        Button {
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.impactOccurred()
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "plus")
                                    .font(.system(size: 13, weight: .bold))
                                Text("Add")
                                    .font(.system(size: 13, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 7)
                            .background(SpendoraTheme.Colors.coralGradient)
                            .clipShape(Capsule())
                            .shadow(color: SpendoraTheme.Colors.coral.opacity(0.35), radius: 6, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal, SpendoraTheme.Spacing.lg)
                    .padding(.top, 8)

                    // Hero Header Card (20pt radius, coral shadow)
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

                        // Next charge section inside hero card below 0.5pt divider
                        Divider()
                            .background(SpendoraTheme.Colors.border)

                        HStack(alignment: .center, spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(SpendoraTheme.Colors.coral.opacity(0.15))
                                    .frame(width: 40, height: 40)
                                Image(systemName: "cpu.fill")
                                    .foregroundColor(SpendoraTheme.Colors.coral)
                                    .font(.system(size: 17, weight: .semibold))
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
                                .font(Font.system(size: 16, weight: .semibold).monospacedDigit())
                                .foregroundColor(SpendoraTheme.Colors.coral)
                        }
                        .padding(.top, 4)
                    }
                    .padding(SpendoraTheme.Spacing.lg)
                    .spendoraCard(cornerRadius: SpendoraTheme.Radius.hero)
                    .padding(.horizontal, SpendoraTheme.Spacing.lg)

                    // Quick Stats Row: 3-Column Equal Mini-Cards
                    HStack(spacing: 10) {
                        MetricSubCard(title: "YEARLY", value: "C$915.12")
                        MetricSubCard(title: "AVERAGE", value: "C$19.07")
                        MetricSubCard(title: "TOTAL", value: "4")
                    }
                    .padding(.horizontal, SpendoraTheme.Spacing.lg)

                    // Sort Filter Pills
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

                    // Subscription Cards Stack (16pt radius, coral shadow)
                    VStack(spacing: SpendoraTheme.Spacing.md) {
                        ForEach(upcomingRenewals) { item in
                            HStack(alignment: .top, spacing: SpendoraTheme.Spacing.md) {
                                ZStack {
                                    Circle()
                                        .fill(item.iconColor.opacity(0.15))
                                        .frame(width: 42, height: 42)

                                    Image(systemName: item.icon)
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(item.iconColor)
                                }

                                VStack(alignment: .leading, spacing: SpendoraTheme.Spacing.xs) {
                                    HStack {
                                        Text(item.name)
                                            .font(SpendoraTheme.Typography.headline)
                                            .foregroundColor(SpendoraTheme.Colors.textPrimary)

                                        Spacer()

                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 13, weight: .semibold))
                                            .foregroundColor(SpendoraTheme.Colors.chevron)
                                    }

                                    HStack(spacing: 4) {
                                        Text(item.category)
                                            .font(SpendoraTheme.Typography.subheadline)
                                            .foregroundColor(SpendoraTheme.Colors.textSecondary)

                                        Text("•")
                                            .font(SpendoraTheme.Typography.caption)
                                            .foregroundColor(SpendoraTheme.Colors.textTertiary)

                                        Text("Monthly")
                                            .font(SpendoraTheme.Typography.subheadline)
                                            .foregroundColor(SpendoraTheme.Colors.textSecondary)
                                    }

                                    HStack(spacing: 4) {
                                        Text(String(format: "C$%.2f/month", item.cost))
                                            .font(Font.system(size: 15, weight: .semibold).monospacedDigit())
                                            .foregroundColor(SpendoraTheme.Colors.textPrimary)
                                    }

                                    CountdownChip(daysRemaining: item.daysRemaining)
                                        .padding(.top, 2)
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

                    // Search Bar (#FFF0EE Background)
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(SpendoraTheme.Colors.coral)
                            .font(.system(size: 15, weight: .semibold))

                        TextField("Search all subscriptions...", text: $searchText)
                            .font(SpendoraTheme.Typography.body)
                            .foregroundColor(SpendoraTheme.Colors.textPrimary)
                            .autocorrectionDisabled()
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 11)
                    .background(SpendoraTheme.Colors.coralTint)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(SpendoraTheme.Colors.border, lineWidth: 0.5)
                    )
                    .padding(.horizontal, SpendoraTheme.Spacing.lg)

                    // Monthly Total Row (Bold Coral #FF6B6B)
                    HStack {
                        Text("\(activeList.count) subscriptions")
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(SpendoraTheme.Colors.textSecondary)

                        Spacer()

                        Text("Monthly Total: C$60.75")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(SpendoraTheme.Colors.coral)
                    }
                    .padding(.horizontal, SpendoraTheme.Spacing.lg)

                    // Active Section
                    VStack(spacing: SpendoraTheme.Spacing.md) {
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
                Circle()
                    .fill(item.iconColor.opacity(0.15))
                    .frame(width: 42, height: 42)

                Image(systemName: item.icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(item.iconColor)
            }

            VStack(alignment: .leading, spacing: SpendoraTheme.Spacing.xs) {
                HStack {
                    Text(item.name)
                        .font(SpendoraTheme.Typography.headline)
                        .foregroundColor(SpendoraTheme.Colors.textPrimary)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(SpendoraTheme.Colors.chevron)
                }

                HStack(spacing: 4) {
                    Text(item.category)
                        .font(SpendoraTheme.Typography.subheadline)
                        .foregroundColor(SpendoraTheme.Colors.textSecondary)

                    Text("•")
                        .font(SpendoraTheme.Typography.caption)
                        .foregroundColor(SpendoraTheme.Colors.textTertiary)

                    Text(String(format: "C$%.2f/mo", item.cost))
                        .font(Font.system(size: 14, weight: .semibold).monospacedDigit())
                        .foregroundColor(SpendoraTheme.Colors.textPrimary)
                }

                CountdownChip(daysRemaining: item.daysRemaining, isCancelled: item.isCancelled)
                    .padding(.top, 2)
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
                VStack(spacing: SpendoraTheme.Spacing.xl) {
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

                    // Calendar Grid Card (20pt radius, coral shadow)
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(SpendoraTheme.Colors.coral)
                                .padding(8)
                                .background(SpendoraTheme.Colors.coralTint)
                                .clipShape(Circle())

                            Spacer()

                            Text("October 2026")
                                .font(SpendoraTheme.Typography.headline)
                                .foregroundColor(SpendoraTheme.Colors.textPrimary)

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(SpendoraTheme.Colors.coral)
                                .padding(8)
                                .background(SpendoraTheme.Colors.coralTint)
                                .clipShape(Circle())
                        }

                        // Day Headers
                        HStack {
                            ForEach(["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"], id: \.self) { day in
                                Text(day)
                                    .font(SpendoraTheme.Typography.label)
                                    .foregroundColor(SpendoraTheme.Colors.textSecondary)
                                    .frame(maxWidth: .infinity)
                            }
                        }

                        // Grid
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                            ForEach(calendarDays, id: \.self) { day in
                                VStack(spacing: 3) {
                                    Text("\(day)")
                                        .font(Font.system(size: 13, weight: (day == 10 || billingDates.contains(day)) ? .bold : .regular).monospacedDigit())
                                        .foregroundColor(day == 10 ? .white : (billingDates.contains(day) ? SpendoraTheme.Colors.textPrimary : SpendoraTheme.Colors.textSecondary))
                                        .frame(width: 32, height: 32)
                                        .background(
                                            Group {
                                                if day == 10 {
                                                    // Today circle: coral gradient fill
                                                    Circle()
                                                        .fill(SpendoraTheme.Colors.coralGradient)
                                                        .shadow(color: SpendoraTheme.Colors.coral.opacity(0.35), radius: 6, x: 0, y: 2)
                                                } else if billingDates.contains(day) {
                                                    // Billing days: 2pt coral stroke ring
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
                            }
                        }
                    }
                    .padding(SpendoraTheme.Spacing.lg)
                    .spendoraCard(cornerRadius: SpendoraTheme.Radius.hero)
                    .padding(.horizontal, SpendoraTheme.Spacing.lg)

                    // Upcoming Billing Days Feed (Left 3pt coral accent bar)
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
                                HStack(spacing: 12) {
                                    // Left 3pt coral accent bar
                                    RoundedRectangle(cornerRadius: 1.5)
                                        .fill(SpendoraTheme.Colors.coral)
                                        .frame(width: 3, height: 28)

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(item.name)
                                            .font(SpendoraTheme.Typography.body)
                                            .fontWeight(.bold)
                                            .foregroundColor(SpendoraTheme.Colors.textPrimary)
                                        Text("Due in \(item.daysRemaining) days")
                                            .font(SpendoraTheme.Typography.caption)
                                            .foregroundColor(SpendoraTheme.Colors.textSecondary)
                                    }

                                    Spacer()

                                    Text(String(format: "C$%.2f", item.cost))
                                        .font(Font.system(size: 15, weight: .bold).monospacedDigit())
                                        .foregroundColor(SpendoraTheme.Colors.coral)
                                }
                                .padding(14)
                                .spendoraCard(cornerRadius: 14)
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
    @State private var selectedCurrencyIndex: Int = 0
    private let currencies = ["CAD ($)", "USD ($)", "EUR (€)", "GBP (£)"]

    var body: some View {
        NavigationStack {
            Form {
                // Branded Coral Gradient Header Card
                Section {
                    PremiumAppInfoRow()
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)

                // Section: Security & Alerts
                Section {
                    Toggle(isOn: $biometricAuthEnabled) {
                        HStack(spacing: 12) {
                            Image(systemName: "faceid")
                                .font(.system(size: 17))
                                .foregroundColor(SpendoraTheme.Colors.coral)
                                .frame(width: 24)

                            Text("Face ID & Passcode")
                                .foregroundColor(SpendoraTheme.Colors.textPrimary)
                        }
                    }
                    .tint(SpendoraTheme.Colors.coral)

                    Toggle(isOn: $pushNotificationsEnabled) {
                        HStack(spacing: 12) {
                            Image(systemName: "bell.badge.fill")
                                .font(.system(size: 17))
                                .foregroundColor(SpendoraTheme.Colors.coral)
                                .frame(width: 24)

                            Text("Billing Push Reminders")
                                .foregroundColor(SpendoraTheme.Colors.textPrimary)
                        }
                    }
                    .tint(SpendoraTheme.Colors.coral)
                } header: {
                    Text("SECURITY & ALERTS")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(SpendoraTheme.Colors.coralWarm)
                }
                .listRowBackground(SpendoraTheme.Colors.card)

                // Section: Preferences
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Default Portfolio Currency")
                            .font(SpendoraTheme.Typography.subheadline)
                            .foregroundColor(SpendoraTheme.Colors.textSecondary)

                        Picker("Currency", selection: $selectedCurrencyIndex) {
                            ForEach(currencies.indices, id: \.self) { idx in
                                Text(currencies[idx]).tag(idx)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding(.vertical, 4)
                } header: {
                    Text("PREFERENCES")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(SpendoraTheme.Colors.coralWarm)
                }
                .listRowBackground(SpendoraTheme.Colors.card)

                // Section: Data & Backup
                Section {
                    HStack {
                        Image(systemName: "tablecells.fill")
                            .foregroundColor(SpendoraTheme.Colors.coral)
                            .frame(width: 24)
                        Text("Export to CSV (Spreadsheet)")
                            .foregroundColor(SpendoraTheme.Colors.textPrimary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(SpendoraTheme.Colors.chevron)
                    }

                    HStack {
                        Image(systemName: "doc.text.fill")
                            .foregroundColor(SpendoraTheme.Colors.coral)
                            .frame(width: 24)
                        Text("Export Executive Annual PDF")
                            .foregroundColor(SpendoraTheme.Colors.textPrimary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(SpendoraTheme.Colors.chevron)
                    }

                    Button(role: .destructive) { } label: {
                        HStack {
                            Image(systemName: "trash.fill")
                                .foregroundColor(SpendoraTheme.Colors.danger)
                                .frame(width: 24)
                            Text("Reset All Data")
                                .foregroundColor(SpendoraTheme.Colors.danger)
                        }
                    }
                } header: {
                    Text("DATA MANAGEMENT")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(SpendoraTheme.Colors.coralWarm)
                }
                .listRowBackground(SpendoraTheme.Colors.card)
            }
            .scrollContentBackground(.hidden)
            .background(SpendoraTheme.Colors.canvas)
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
                    VStack(spacing: 3) {
                        ZStack {
                            if selectedTab == idx {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(SpendoraTheme.Colors.coralTint)
                                    .frame(width: 44, height: 26)
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
                    .frame(height: 52)
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
        .shadow(color: SpendoraTheme.Colors.coral.opacity(0.12), radius: 14, x: 0, y: 6)
    }
}
