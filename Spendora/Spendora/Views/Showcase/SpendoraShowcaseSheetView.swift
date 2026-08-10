//
//  SpendoraShowcaseSheetView.swift
//  Spendora
//
//  Apple Native HIG Showcase Sheet View adhering strictly to Sage Teal #2AB7A9 Accent
//  and Color(.systemBackground) / Color(.secondarySystemBackground) surfaces.
//

import SwiftUI
import Charts

// MARK: - Sample Data Models

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

// MARK: - Main Showcase Sheet View

struct SpendoraShowcaseSheetView: View {
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            ShowcaseDashboardScreen()
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }
                .tag(0)

            ShowcaseSubscriptionsListScreen()
                .tabItem {
                    Label("Subscriptions", systemImage: "list.bullet")
                }
                .tag(1)

            ShowcaseCalendarScreen()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
                .tag(2)

            ShowcaseSettingsScreen()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(3)
        }
        .tint(SpendoraTheme.accent)
    }
}

// MARK: - Panel 1: Dashboard Screen

struct ShowcaseDashboardScreen: View {
    @State private var selectedSortIndex = 0
    private let sortOptions = ["Alphabetical", "Billing Date", "Highest Cost", "Category"]

    private let upcomingRenewals: [ShowcaseRenewalItem] = [
        ShowcaseRenewalItem(name: "Spotify Premium", category: "Music", cost: 10.02, daysRemaining: 30, icon: "music.note", iconColor: Color(.systemPurple)),
        ShowcaseRenewalItem(name: "ChatGPT Plus", category: "AI Tools", cost: 20.00, daysRemaining: 6, icon: "cpu.fill", iconColor: Color(.systemCyan)),
        ShowcaseRenewalItem(name: "Netflix Standard", category: "Entertainment", cost: 17.74, daysRemaining: 12, icon: "tv.fill", iconColor: Color(.systemPink)),
        ShowcaseRenewalItem(name: "iCloud+ 2TB", category: "Productivity", cost: 12.99, daysRemaining: 18, icon: "cloud.fill", iconColor: SpendoraTheme.accent)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: SpendoraTheme.sectionSpacing) {
                    // Hero Spend Card (12pt radius, secondarySystemBackground, 16pt padding)
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Text("THIS MONTH")
                                .font(.caption.weight(.semibold))
                                .foregroundColor(.secondary)
                                .textCase(.uppercase)

                            Spacer()

                            Text("October 2026")
                                .font(.caption.weight(.semibold))
                                .foregroundColor(SpendoraTheme.accent)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("C$76.26")
                                .font(SpendoraTheme.heroNumber)
                                .foregroundColor(Color(.label))
                                .contentTransition(.numericText())

                            Text("4 active subscriptions")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        Divider()

                        // Next Charge Row
                        HStack(alignment: .center, spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color(.tertiarySystemBackground))
                                    .frame(width: 40, height: 40)
                                Image(systemName: "cpu.fill")
                                    .foregroundColor(Color(.systemCyan))
                                    .font(.system(size: 18, weight: .medium))
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text("ChatGPT Plus")
                                    .font(.headline)
                                    .foregroundColor(Color(.label))
                                Text("Due in 6 days")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()

                            Text("C$20.00")
                                .font(SpendoraTheme.cardAmount)
                                .foregroundColor(SpendoraTheme.accent)
                        }
                    }
                    .padding(SpendoraTheme.cardPadding)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: SpendoraTheme.cardRadius, style: .continuous))

                    // Stat Row: 3 Equal Cards (12pt radius)
                    HStack(spacing: 10) {
                        MetricSubCard(title: "YEARLY", value: "C$915.12")
                        MetricSubCard(title: "AVERAGE", value: "C$19.07")
                        MetricSubCard(title: "TOTAL", value: "4")
                    }

                    // Sort Pills
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(sortOptions.indices, id: \.self) { idx in
                                Button {
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                        selectedSortIndex = idx
                                    }
                                } label: {
                                    Text(sortOptions[idx])
                                        .font(.caption.weight(.semibold))
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 7)
                                        .background(
                                            selectedSortIndex == idx
                                                ? SpendoraTheme.accent
                                                : Color(.secondarySystemBackground)
                                        )
                                        .clipShape(Capsule())
                                        .foregroundColor(
                                            selectedSortIndex == idx
                                                ? .white
                                                : .secondary
                                        )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    // Subscription Feed: LazyVStack(spacing: 8)
                    LazyVStack(spacing: 8) {
                        ForEach(upcomingRenewals) { item in
                            HStack(alignment: .top, spacing: 12) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(item.iconColor.opacity(0.15))
                                        .frame(width: 44, height: 44)

                                    Image(systemName: item.icon)
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(item.iconColor)
                                }

                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text(item.name)
                                            .font(.headline)
                                            .foregroundColor(Color(.label))

                                        Spacer()

                                        Image(systemName: "chevron.right")
                                            .font(.caption.weight(.semibold))
                                            .foregroundColor(Color(.tertiaryLabel))
                                    }

                                    Text("\(item.category) · Monthly")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)

                                    HStack {
                                        Text(String(format: "C$%.2f", item.cost))
                                            .font(SpendoraTheme.cardAmount)
                                            .foregroundColor(Color(.label))

                                        Text("· Next: Oct \(item.daysRemaining)")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }

                                    StatusBadgeView(daysUntil: item.daysRemaining)
                                        .padding(.top, 2)
                                }
                            }
                            .padding(SpendoraTheme.cardPadding)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: SpendoraTheme.cardRadius, style: .continuous))
                        }
                    }
                }
                .padding(.horizontal, SpendoraTheme.cardPadding)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            .navigationTitle("Spendora")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 17, weight: .bold))
                    }
                    .tint(SpendoraTheme.accent)
                }
            }
        }
    }
}

// MARK: - Panel 2: Subscriptions List Screen

struct ShowcaseSubscriptionsListScreen: View {
    @State private var searchText = ""

    private let activeList: [ShowcaseRenewalItem] = [
        ShowcaseRenewalItem(name: "Spotify Premium", category: "Music", cost: 10.02, daysRemaining: 30, icon: "music.note", iconColor: Color(.systemPurple)),
        ShowcaseRenewalItem(name: "ChatGPT Plus", category: "AI Tools", cost: 20.00, daysRemaining: 6, icon: "cpu.fill", iconColor: Color(.systemCyan)),
        ShowcaseRenewalItem(name: "Netflix Standard", category: "Entertainment", cost: 17.74, daysRemaining: 12, icon: "tv.fill", iconColor: Color(.systemPink)),
        ShowcaseRenewalItem(name: "iCloud+ 2TB", category: "Productivity", cost: 12.99, daysRemaining: 18, icon: "cloud.fill", iconColor: SpendoraTheme.accent)
    ]

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Text("\(activeList.count) subscriptions")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Spacer()

                        Text("Monthly Total: C$60.75")
                            .font(.caption.weight(.semibold))
                            .foregroundColor(SpendoraTheme.accent)
                    }
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)

                Section("Active Subscriptions (\(activeList.count))") {
                    ForEach(activeList) { item in
                        HStack(alignment: .top, spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(item.iconColor.opacity(0.15))
                                    .frame(width: 44, height: 44)

                                Image(systemName: item.icon)
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(item.iconColor)
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(item.name)
                                        .font(.headline)
                                        .foregroundColor(Color(.label))

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .font(.caption.weight(.semibold))
                                        .foregroundColor(Color(.tertiaryLabel))
                                }

                                Text("\(item.category) · Monthly")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)

                                HStack {
                                    Text(String(format: "C$%.2f", item.cost))
                                        .font(SpendoraTheme.cardAmount)
                                        .foregroundColor(Color(.label))

                                    Text("· Next: Oct \(item.daysRemaining)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }

                                StatusBadgeView(daysUntil: item.daysRemaining)
                                    .padding(.top, 2)
                            }
                        }
                        .padding(SpendoraTheme.cardPadding)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: SpendoraTheme.cardRadius, style: .continuous))
                        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Subscriptions")
            .searchable(text: $searchText, prompt: "Search subscriptions")
        }
    }
}

// MARK: - Panel 3: Visual Calendar Screen

struct ShowcaseCalendarScreen: View {
    private let calendarDays: [Int] = Array(1...31)
    private let billingDates: Set<Int> = [3, 6, 12, 18]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: SpendoraTheme.sectionSpacing) {
                    VStack(spacing: 16) {
                        HStack {
                            Text("October 2026")
                                .font(.headline.weight(.semibold))
                                .foregroundColor(Color(.label))
                            Spacer()
                        }

                        HStack {
                            ForEach(["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"], id: \.self) { day in
                                Text(day)
                                    .font(.caption2.weight(.semibold))
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity)
                            }
                        }

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 6) {
                            ForEach(calendarDays, id: \.self) { day in
                                VStack(spacing: 2) {
                                    Text("\(day)")
                                        .font(Font.system(size: 14, weight: (day == 10 || billingDates.contains(day)) ? .bold : .regular, design: .rounded).monospacedDigit())
                                        .foregroundColor(day == 10 ? .white : (billingDates.contains(day) ? Color(.label) : .secondary))
                                        .frame(width: 36, height: 36)
                                        .background(
                                            Group {
                                                if day == 10 {
                                                    Circle().fill(SpendoraTheme.accent)
                                                } else if billingDates.contains(day) {
                                                    Circle().stroke(SpendoraTheme.accent, lineWidth: 2)
                                                }
                                            }
                                        )

                                    if billingDates.contains(day) {
                                        Circle().fill(SpendoraTheme.accent).frame(width: 5, height: 5)
                                    } else {
                                        Spacer().frame(height: 5)
                                    }
                                }
                                .frame(width: 44, height: 44)
                            }
                        }
                    }
                    .padding(SpendoraTheme.cardPadding)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: SpendoraTheme.cardRadius, style: .continuous))
                }
                .padding(.horizontal, SpendoraTheme.cardPadding)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Panel 4: Settings Screen

struct ShowcaseSettingsScreen: View {
    @State private var isDarkMode = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                PremiumAppInfoRow()
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 8)

                Form {
                    Section("Appearance") {
                        Toggle("Dark Mode", isOn: $isDarkMode)
                            .tint(SpendoraTheme.accent)
                    }

                    Section("Data Management") {
                        Label("Export to CSV", systemImage: "square.and.arrow.up")
                        Label("Export PDF Report", systemImage: "doc.richtext")
                    }

                    Section {
                        Button(role: .destructive) { } label: {
                            Label("Reset All Data", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
