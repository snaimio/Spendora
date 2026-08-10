//
//  SpendoraShowcaseSheetView.swift
//  Spendora
//
//  Production-ready, clean, modern SwiftUI UI/UX component sheet & 3-panel screen layout
//  strictly adhering to Apple HIG (iOS 17/18) and Slate & Warm Gold (#C6A473) design patterns.
//

import SwiftUI
import Charts

// MARK: - Slate & Warm Gold Design Tokens

extension Color {
    static let spendoraCanvas = Color(hex: "#0E0E10")
    static let spendoraCard = Color(hex: "#1C1C1E")
    static let spendoraCardBorder = Color(hex: "#2C2C2E")
    static let spendoraGold = Color(hex: "#C6A473")
    static let spendoraGoldLight = Color(hex: "#DFCAA6")
    static let spendoraRed = Color(hex: "#FF453A")
    static let spendoraGreen = Color(hex: "#30D158")
    static let spendoraSlate = Color(hex: "#8E8E93")
}

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
}

// MARK: - Main Showcase Sheet View (3-Screen Adaptive Layout)

/**
 `SpendoraShowcaseSheetView` presents the complete production-grade 3-screen layout:
 1. Executive Dashboard (Swift Charts Donut, Balance, Renewal List)
 2. Analytics & AI Insights (Savings Score, Active Trials, Actionable Audits)
 3. App Settings & Data Privacy (Form Sections, Toggles, Currency & Exports)
 */
struct SpendoraShowcaseSheetView: View {
    @State private var selectedTab: Int = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            // Background Canvas (OLED Charcoal Black #0E0E10 + Ambient Radial Glow)
            ZStack {
                Color.spendoraCanvas
                    .ignoresSafeArea()
                
                // Subtle Warm Gold Ambient Orb (Top-Right)
                RadialGradient(
                    colors: [Color.spendoraGold.opacity(0.12), Color.clear],
                    center: .topTrailing,
                    startRadius: 10,
                    endRadius: 400
                )
                .ignoresSafeArea()
            }

            // Screen Content
            TabView(selection: $selectedTab) {
                ShowcaseDashboardScreen()
                    .tag(0)

                ShowcaseAnalyticsScreen()
                    .tag(1)

                ShowcaseSettingsScreen()
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea(edges: .bottom)

            // Floating Glassmorphism Bottom Tab Bar
            ShowcaseFloatingTabBar(selectedTab: $selectedTab)
                .padding(.horizontal, 24)
                .padding(.bottom, 12)
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Panel 1: Executive Dashboard Screen

struct ShowcaseDashboardScreen: View {
    private let categoryBreakdown: [ShowcaseCategorySpend] = [
        ShowcaseCategorySpend(category: "Productivity", amount: 28.50, color: Color(hex: "#007AFF")),
        ShowcaseCategorySpend(category: "AI Tools", amount: 20.00, color: Color(hex: "#32ADE6")),
        ShowcaseCategorySpend(category: "Entertainment", amount: 16.99, color: Color(hex: "#FF453A")),
        ShowcaseCategorySpend(category: "Music", amount: 10.02, color: Color.spendoraGold)
    ]

    private let upcomingRenewals: [ShowcaseRenewalItem] = [
        ShowcaseRenewalItem(name: "Spotify Premium", category: "Music", cost: 10.02, daysRemaining: 3, icon: "music.note", iconColor: Color.spendoraGold),
        ShowcaseRenewalItem(name: "ChatGPT Plus", category: "AI Tools", cost: 20.00, daysRemaining: 6, icon: "cpu.fill", iconColor: Color(hex: "#32ADE6")),
        ShowcaseRenewalItem(name: "Netflix Standard", category: "Entertainment", cost: 16.99, daysRemaining: 12, icon: "tv.fill", iconColor: Color(hex: "#FF453A")),
        ShowcaseRenewalItem(name: "iCloud+ 2TB", category: "Productivity", cost: 12.99, daysRemaining: 18, icon: "cloud.fill", iconColor: Color(hex: "#007AFF"))
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Minimal Top Navigation Bar
                    HStack(alignment: .center) {
                        // User Avatar & Greeting
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.spendoraGold, Color.spendoraGold.opacity(0.6)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 40, height: 40)
                                
                                Text("GU")
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .foregroundColor(Color.spendoraCanvas)
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Good evening,")
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(.spendoraSlate)
                                
                                Text("Gabriel Utterson")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }

                        Spacer()

                        // Dynamic Quick-Action Button
                        Button {
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.impactOccurred()
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Color.spendoraCanvas)
                                .frame(width: 36, height: 36)
                                .background(Color.spendoraGold)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)

                    // Interactive Donut Chart Card (Swift Charts)
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("MONTHLY EXPENDITURE")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.spendoraSlate)
                                .tracking(1.2)

                            Spacer()

                            Text("October 2026")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.spendoraGold)
                        }

                        ZStack {
                            Chart(categoryBreakdown) { item in
                                SectorMark(
                                    angle: .value("Amount", item.amount),
                                    innerRadius: .ratio(0.72),
                                    angularInset: 2.0
                                )
                                .cornerRadius(4)
                                .foregroundStyle(item.color)
                            }
                            .frame(height: 190)

                            // Centered Total Spend Metric
                            VStack(spacing: 2) {
                                Text("Total Spend")
                                    .font(.system(size: 11, weight: .regular))
                                    .foregroundColor(.spendoraSlate)
                                
                                Text("C$75.51")
                                    .font(.system(size: 26, weight: .black, design: .default).monospacedDigit())
                                    .foregroundColor(.white)
                            }
                        }

                        // Category Chips
                        HStack(spacing: 12) {
                            ForEach(categoryBreakdown) { item in
                                HStack(spacing: 5) {
                                    Circle()
                                        .fill(item.color)
                                        .frame(width: 7, height: 7)
                                    Text(item.category)
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundColor(.spendoraSlate)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(18)
                    .background(Color.spendoraCard)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color.spendoraCardBorder, lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.4), radius: 8, x: 0, y: 4)
                    .padding(.horizontal, 20)

                    // Upcoming Renewals List Header
                    HStack {
                        Text("Upcoming Renewals")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)

                        Spacer()

                        Text("View All")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.spendoraGold)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 6)

                    // Upcoming Renewals Stack
                    VStack(spacing: 10) {
                        ForEach(upcomingRenewals) { item in
                            HStack(spacing: 14) {
                                // Emblem Icon
                                ZStack {
                                    Circle()
                                        .fill(item.iconColor.opacity(0.15))
                                        .frame(width: 42, height: 42)

                                    Image(systemName: item.icon)
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(item.iconColor)
                                }

                                // Title & Category
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(item.name)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)

                                    Text(item.category)
                                        .font(.system(size: 13, weight: .regular))
                                        .foregroundColor(.spendoraSlate)
                                }

                                Spacer()

                                // Cost & Countdown Badge
                                VStack(alignment: .trailing, spacing: 4) {
                                    Text(String(format: "C$%.2f", item.cost))
                                        .font(.system(size: 15, weight: .semibold).monospacedDigit())
                                        .foregroundColor(.white)

                                    Text("In \(item.daysRemaining) days")
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundColor(item.daysRemaining <= 3 ? .spendoraGold : .spendoraSlate)
                                        .padding(.horizontal, 7)
                                        .padding(.vertical, 2.5)
                                        .background((item.daysRemaining <= 3 ? Color.spendoraGold : Color.spendoraSlate).opacity(0.14))
                                        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                                }
                            }
                            .padding(14)
                            .background(Color.spendoraCard)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(Color.spendoraCardBorder, lineWidth: 1)
                            )
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

// MARK: - Panel 2: Analytics & AI Insights View

struct ShowcaseAnalyticsScreen: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("FINANCIAL INTELLIGENCE")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.spendoraSlate)
                                .tracking(1.2)

                            Text("Analytics & Insights")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)

                    // Dynamic 2-Column Metric Tiles
                    HStack(spacing: 14) {
                        // Metric 1: Savings Score
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "star.circle.fill")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.spendoraGold)

                                Spacer()

                                Text("Top 10%")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.spendoraGreen)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.spendoraGreen.opacity(0.16))
                                    .clipShape(Capsule())
                            }

                            Text("84/100")
                                .font(.system(size: 28, weight: .black, design: .default).monospacedDigit())
                                .foregroundColor(.white)

                            Text("Savings Health Score")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.spendoraSlate)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.spendoraCard)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(Color.spendoraCardBorder, lineWidth: 1)
                        )

                        // Metric 2: Active Trials
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "hourglass.badge.plus")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Color(hex: "#FF9500"))

                                Spacer()

                                Text("Action Req.")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(Color(hex: "#FF9500"))
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color(hex: "#FF9500").opacity(0.16))
                                    .clipShape(Capsule())
                            }

                            Text("1")
                                .font(.system(size: 28, weight: .black, design: .default).monospacedDigit())
                                .foregroundColor(.white)

                            Text("Active Free Trial")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.spendoraSlate)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.spendoraCard)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(Color.spendoraCardBorder, lineWidth: 1)
                        )
                    }
                    .padding(.horizontal, 20)

                    // Actionable AI Insight Container Card
                    VStack(alignment: .leading, spacing: 14) {
                        HStack(spacing: 10) {
                            ZStack {
                                Circle()
                                    .fill(Color.spendoraGold.opacity(0.18))
                                    .frame(width: 36, height: 36)

                                Image(systemName: "sparkles")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.spendoraGold)
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text("AI AUDIT RECOMMENDATION")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.spendoraGold)
                                    .tracking(1.0)

                                Text("Underused Subscription Detected")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                            }

                            Spacer()
                        }

                        Text("You logged a 1-star usage rating for **Paramount+** ($9.99/mo) and haven't accessed it in 42 days. Cancelling before the Nov 2 renewal will save **C$119.88/year**.")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Color(hex: "#D1D1D6"))
                            .lineSpacing(4)

                        // Action Buttons
                        HStack(spacing: 12) {
                            Button {
                                if let url = URL(string: "https://paramountplus.com/account") {
                                    UIApplication.shared.open(url)
                                }
                            } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: "safari")
                                        .font(.system(size: 13, weight: .semibold))
                                    Text("Cancel on Provider Website")
                                        .font(.system(size: 13, weight: .semibold))
                                }
                                .foregroundColor(Color.spendoraCanvas)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background(Color.spendoraGold)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            }

                            Button {
                                let generator = UIImpactFeedbackGenerator(style: .light)
                                generator.impactOccurred()
                            } label: {
                                Text("Keep Active")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.spendoraSlate)
                                    .frame(width: 96)
                                    .frame(height: 44)
                                    .background(Color.spendoraCardBorder.opacity(0.5))
                                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            }
                        }
                        .padding(.top, 4)
                    }
                    .padding(18)
                    .background(Color.spendoraCard)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color.spendoraGold.opacity(0.35), lineWidth: 1)
                    )
                    .padding(.horizontal, 20)

                    // Secondary Insight: Duplicate Category Overlap
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "rectangle.stack.fill")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(hex: "#32ADE6"))

                            Text("2 Music Subscriptions Active")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)

                            Spacer()

                            Text("Overlap")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(Color(hex: "#32ADE6"))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color(hex: "#32ADE6").opacity(0.16))
                                .clipShape(Capsule())
                        }

                        Text("You are paying for both Spotify Premium ($10.02) and Apple Music ($10.99). Consolidating into one plan saves C$120.24 annually.")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.spendoraSlate)
                            .lineSpacing(3)
                    }
                    .padding(16)
                    .background(Color.spendoraCard)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color.spendoraCardBorder, lineWidth: 1)
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 90)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Panel 3: App Settings & Data Privacy View

struct ShowcaseSettingsScreen: View {
    @State private var biometricAuthEnabled: Bool = true
    @State private var pushNotificationsEnabled: Bool = true
    @State private var icloudSyncEnabled: Bool = true
    @State private var selectedCurrencyIndex: Int = 0
    private let currencies = ["CAD ($)", "USD ($)", "EUR (€)", "GBP (£)"]

    var body: some View {
        NavigationStack {
            Form {
                // Section 1: Data & Privacy
                Section {
                    Toggle(isOn: $biometricAuthEnabled) {
                        HStack(spacing: 12) {
                            Image(systemName: "faceid")
                                .font(.system(size: 17))
                                .foregroundColor(.spendoraGold)
                                .frame(width: 24)

                            Text("Face ID & Passcode")
                                .foregroundColor(.white)
                        }
                    }
                    .tint(.spendoraGold)

                    Toggle(isOn: $pushNotificationsEnabled) {
                        HStack(spacing: 12) {
                            Image(systemName: "bell.badge.fill")
                                .font(.system(size: 17))
                                .foregroundColor(.spendoraGold)
                                .frame(width: 24)

                            Text("Billing Push Reminders")
                                .foregroundColor(.white)
                        }
                    }
                    .tint(.spendoraGold)
                } header: {
                    Text("Security & Alerts")
                        .foregroundColor(.spendoraSlate)
                }
                .listRowBackground(Color.spendoraCard)

                // Section 2: Appearance & Preferences
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Default Portfolio Currency")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.spendoraSlate)

                        Picker("Currency", selection: $selectedCurrencyIndex) {
                            ForEach(currencies.indices, id: \.self) { idx in
                                Text(currencies[idx]).tag(idx)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding(.vertical, 4)
                } header: {
                    Text("Preferences")
                        .foregroundColor(.spendoraSlate)
                }
                .listRowBackground(Color.spendoraCard)

                // Section 3: Cloud Sync & Backup
                Section {
                    Toggle(isOn: $icloudSyncEnabled) {
                        HStack(spacing: 12) {
                            Image(systemName: "icloud.fill")
                                .font(.system(size: 17))
                                .foregroundColor(Color(hex: "#007AFF"))
                                .frame(width: 24)

                            VStack(alignment: .leading, spacing: 2) {
                                Text("iCloud Encrypted Sync")
                                    .foregroundColor(.white)
                                Text("Synced 4 minutes ago")
                                    .font(.system(size: 11))
                                    .foregroundColor(.spendoraSlate)
                            }
                        }
                    }
                    .tint(.spendoraGold)
                } header: {
                    Text("Cloud Sync")
                        .foregroundColor(.spendoraSlate)
                }
                .listRowBackground(Color.spendoraCard)

                // Section 4: Data Export Actions
                Section {
                    Button {
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                    } label: {
                        HStack {
                            Image(systemName: "tablecells.fill")
                                .foregroundColor(.spendoraGold)
                                .frame(width: 24)
                            Text("Export to CSV (Spreadsheet)")
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.spendoraSlate)
                        }
                    }

                    Button {
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                    } label: {
                        HStack {
                            Image(systemName: "doc.text.fill")
                                .foregroundColor(.spendoraGold)
                                .frame(width: 24)
                            Text("Export Executive Annual PDF")
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.spendoraSlate)
                        }
                    }

                    Button {
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.down.doc.fill")
                                .foregroundColor(.spendoraGold)
                                .frame(width: 24)
                            Text("Download Full JSON Backup")
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.spendoraSlate)
                        }
                    }
                } header: {
                    Text("Data Management")
                        .foregroundColor(.spendoraSlate)
                } footer: {
                    Text("Your financial records stay 100% on-device and private. Zero third-party analytics.")
                        .foregroundColor(.spendoraSlate)
                }
                .listRowBackground(Color.spendoraCard)
            }
            .scrollContentBackground(.hidden)
            .background(Color.spendoraCanvas)
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
        ("chart.pie.fill", "Intelligence"),
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
                            .font(.system(size: 19, weight: selectedTab == idx ? .bold : .regular))
                            .foregroundColor(selectedTab == idx ? Color.spendoraGold : Color.spendoraSlate)

                        Text(tabs[idx].label)
                            .font(.system(size: 10, weight: selectedTab == idx ? .semibold : .regular))
                            .foregroundColor(selectedTab == idx ? Color.spendoraGold : Color.spendoraSlate)
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
                .stroke(Color.spendoraCardBorder.opacity(0.8), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.5), radius: 16, x: 0, y: 6)
    }
}

// MARK: - Previews

#Preview("Spendora Showcase Sheet - OLED Slate & Gold") {
    SpendoraShowcaseSheetView()
}
