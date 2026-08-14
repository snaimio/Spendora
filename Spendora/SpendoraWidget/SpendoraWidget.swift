//
//  SpendoraWidget.swift
//  SpendoraWidget
//

import WidgetKit
import SwiftUI

// MARK: - Sage Teal Palette & Luxury Solid Theme Constants

private struct WidgetTheme {
    /// Sage Teal brand accent #2AB7A9
    static let accent = Color(red: 42/255, green: 183/255, blue: 169/255)
    
    /// Accent tint with subtle transparency
    static let accentTint = Color(red: 42/255, green: 183/255, blue: 169/255).opacity(0.18)
    
    /// Cool solid signature dark teal background #0E2426
    static let solidBackground = Color(red: 14/255, green: 36/255, blue: 38/255)
    
    /// Card surface overlay on top of solid background
    static let cardBackground = Color.white.opacity(0.08)
    
    /// Card border stroke
    static let cardBorder = Color.white.opacity(0.12)
}

// MARK: - Spendora App Logo Emblem View

struct SpendoraLogoEmblem: View {
    var size: CGFloat = 20

    var body: some View {
        Image("SpendoraLogo")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size, height: size)
            .clipShape(RoundedRectangle(cornerRadius: size * 0.23, style: .continuous))
            .background(
                RoundedRectangle(cornerRadius: size * 0.25, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
            )
            .overlay(
                RoundedRectangle(cornerRadius: size * 0.23, style: .continuous)
                    .stroke(Color.white.opacity(0.25), lineWidth: 0.5)
            )
    }
}

// MARK: - Timeline Provider

struct Provider: TimelineProvider {

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            totalSpending: 76.26,
            totalYearly: 915.12,
            activeCount: 4,
            upcomingSubscription: "Netflix",
            upcomingCost: 15.99,
            upcomingDate: Date().addingTimeInterval(86400 * 3),
            upcomingIcon: "tv.fill",
            upcomingCategory: "Entertainment",
            monthlyBudget: 150.0,
            currencySymbol: "$",
            formattedMonthlyStored: "$76.26",
            formattedYearlyStored: "$915.12",
            formattedNextCostStored: "$15.99"
        )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(
            date: Date(),
            totalSpending: 76.26,
            totalYearly: 915.12,
            activeCount: 4,
            upcomingSubscription: "Netflix",
            upcomingCost: 15.99,
            upcomingDate: Date().addingTimeInterval(86400 * 3),
            upcomingIcon: "tv.fill",
            upcomingCategory: "Entertainment",
            monthlyBudget: 150.0,
            currencySymbol: "$",
            formattedMonthlyStored: "$76.26",
            formattedYearlyStored: "$915.12",
            formattedNextCostStored: "$15.99"
        )
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let defaults = UserDefaults(suiteName: "group.com.trios2026sn.Spendora")
        
        let total = defaults?.double(forKey: "totalMonthly") ?? 0
        let yearly = defaults?.double(forKey: "totalYearly") ?? (total * 12)
        let count = defaults?.integer(forKey: "activeCount") ?? 0
        let next = defaults?.string(forKey: "nextSubName") ?? "No bills due"
        let nextCost = defaults?.double(forKey: "nextSubCost") ?? 0
        let nextTime = defaults?.double(forKey: "nextSubDate") ?? 0
        let nextIcon = defaults?.string(forKey: "nextSubIcon") ?? "creditcard.fill"
        let nextCategory = defaults?.string(forKey: "nextSubCategory") ?? "Subscriptions"
        let budget = defaults?.double(forKey: "monthlyBudget") ?? 0
        let symbol = defaults?.string(forKey: "currencySymbol") ?? "$"
        let formattedMonthly = defaults?.string(forKey: "formattedMonthly")
        let formattedYearly = defaults?.string(forKey: "formattedYearly")
        let formattedNextCost = defaults?.string(forKey: "formattedNextCost")
        
        let upcomingDate = nextTime > 0 ? Date(timeIntervalSince1970: nextTime) : nil
        
        let entry = SimpleEntry(
            date: Date(),
            totalSpending: total,
            totalYearly: yearly,
            activeCount: count,
            upcomingSubscription: next,
            upcomingCost: nextCost,
            upcomingDate: upcomingDate,
            upcomingIcon: nextIcon,
            upcomingCategory: nextCategory,
            monthlyBudget: budget,
            currencySymbol: symbol,
            formattedMonthlyStored: formattedMonthly,
            formattedYearlyStored: formattedYearly,
            formattedNextCostStored: formattedNextCost
        )
        
        // Refresh every 30 minutes
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 30, to: Date()) ?? Date().addingTimeInterval(1800)
        let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
        
        completion(timeline)
    }
}

// MARK: - Entry Model

struct SimpleEntry: TimelineEntry {
    let date: Date
    let totalSpending: Double
    let totalYearly: Double
    let activeCount: Int
    let upcomingSubscription: String
    let upcomingCost: Double
    let upcomingDate: Date?
    let upcomingIcon: String
    let upcomingCategory: String
    let monthlyBudget: Double
    let currencySymbol: String
    var formattedMonthlyStored: String? = nil
    var formattedYearlyStored: String? = nil
    var formattedNextCostStored: String? = nil
    
    var formattedMonthly: String {
        if let stored = formattedMonthlyStored, !stored.isEmpty {
            return stored
        }
        let amount = String(format: "%.2f", totalSpending)
        return "\(currencySymbol)\(amount)"
    }
    
    var formattedYearly: String {
        if let stored = formattedYearlyStored, !stored.isEmpty {
            return stored
        }
        let amount = String(format: "%.2f", totalYearly)
        return "\(currencySymbol)\(amount)"
    }
    
    var formattedUpcomingCost: String {
        if let stored = formattedNextCostStored, !stored.isEmpty {
            return stored
        }
        let amount = String(format: "%.2f", upcomingCost)
        return "\(currencySymbol)\(amount)"
    }
    
    var formattedUpcomingDate: String {
        guard let upcomingDate = upcomingDate else { return "No bills due" }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let target = calendar.startOfDay(for: upcomingDate)
        let days = calendar.dateComponents([.day], from: today, to: target).day ?? 0
        
        if days < 0 {
            return "Overdue"
        } else if days == 0 {
            return "Due Today"
        } else if days == 1 {
            return "Due Tomorrow"
        } else {
            return "In \(days) days"
        }
    }
    
    var isUpcomingOverdue: Bool {
        guard let upcomingDate = upcomingDate else { return false }
        return Calendar.current.startOfDay(for: upcomingDate) < Calendar.current.startOfDay(for: Date())
    }
    
    var isUpcomingToday: Bool {
        guard let upcomingDate = upcomingDate else { return false }
        return Calendar.current.isDateInToday(upcomingDate)
    }
    
    var budgetProgress: Double {
        guard monthlyBudget > 0 else { return 0 }
        return min(max(totalSpending / monthlyBudget, 0), 1.0)
    }
}

// MARK: - Widget Entry View Router

struct SpendoraWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        Group {
            switch family {
            case .systemSmall:
                SmallWidgetView(entry: entry)
            case .systemMedium:
                MediumWidgetView(entry: entry)
            case .systemLarge:
                LargeWidgetView(entry: entry)
            case .accessoryInline:
                InlineAccessoryView(entry: entry)
            case .accessoryCircular:
                CircularAccessoryView(entry: entry)
            case .accessoryRectangular:
                RectangularAccessoryView(entry: entry)
            default:
                SmallWidgetView(entry: entry)
            }
        }
        .widgetURL(URL(string: "spendora://home"))
    }
}

// MARK: - Small Widget View (158x158pt)

struct SmallWidgetView: View {
    let entry: SimpleEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header Bar: App Logo + App Title + Count
            HStack(spacing: 6) {
                SpendoraLogoEmblem(size: 18)
                
                Text("SPENDORA")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .tracking(0.8)
                    .foregroundColor(Color.white.opacity(0.85))
                
                Spacer()
                
                Text("\(entry.activeCount) active")
                    .font(.system(size: 9, weight: .medium, design: .rounded))
                    .foregroundColor(Color.white.opacity(0.5))
            }
            
            Spacer(minLength: 4)
            
            // Hero Metric: This Month Total
            VStack(alignment: .leading, spacing: 1) {
                Text("THIS MONTH")
                    .font(.system(size: 9, weight: .semibold, design: .rounded))
                    .foregroundColor(Color.white.opacity(0.6))
                    .tracking(0.6)
                
                Text(entry.formattedMonthly)
                    .font(.system(size: 24, weight: .semibold, design: .rounded).monospacedDigit())
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            
            Spacer(minLength: 6)
            
            // Next Charge Action Card
            HStack(spacing: 6) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(WidgetTheme.accentTint)
                        .frame(width: 26, height: 26)
                    
                    Image(systemName: entry.upcomingIcon)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(WidgetTheme.accent)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(entry.upcomingSubscription)
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Text(entry.formattedUpcomingDate)
                        .font(.system(size: 9, weight: .medium, design: .rounded))
                        .foregroundColor(
                            entry.isUpcomingOverdue
                                ? Color(red: 255/255, green: 90/255, blue: 95/255)
                                : (entry.isUpcomingToday ? WidgetTheme.accent : Color.white.opacity(0.65))
                        )
                }
                
                Spacer(minLength: 0)
                
                if entry.upcomingCost > 0 {
                    Text(entry.formattedUpcomingCost)
                        .font(.system(size: 11, weight: .semibold, design: .rounded).monospacedDigit())
                        .foregroundColor(WidgetTheme.accent)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(WidgetTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(WidgetTheme.cardBorder, lineWidth: 0.5)
            )
        }
        .padding(12)
        .containerBackground(for: .widget) {
            WidgetTheme.solidBackground
        }
    }
}

// MARK: - Medium Widget View (338x158pt)

struct MediumWidgetView: View {
    let entry: SimpleEntry

    var body: some View {
        HStack(spacing: 14) {
            // Left Half: Monthly Spending Hero & Count
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    SpendoraLogoEmblem(size: 18)
                    
                    Text("SPENDORA")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .tracking(1.0)
                        .foregroundColor(Color.white.opacity(0.85))
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("THIS MONTH")
                        .font(.system(size: 9, weight: .semibold, design: .rounded))
                        .foregroundColor(Color.white.opacity(0.6))
                        .tracking(0.6)
                    
                    Text(entry.formattedMonthly)
                        .font(.system(size: 26, weight: .semibold, design: .rounded).monospacedDigit())
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                }
                
                Text("\(entry.activeCount) active subscriptions")
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundColor(Color.white.opacity(0.6))
                
                if entry.monthlyBudget > 0 {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.white.opacity(0.15))
                                .frame(height: 4)
                            
                            Capsule()
                                .fill(entry.budgetProgress >= 1.0 ? Color(red: 255/255, green: 90/255, blue: 95/255) : WidgetTheme.accent)
                                .frame(width: geo.size.width * CGFloat(entry.budgetProgress), height: 4)
                        }
                    }
                    .frame(height: 4)
                    .padding(.top, 2)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
                .overlay(Color.white.opacity(0.15))
                .padding(.vertical, 4)
            
            // Right Half: Next Charge & Yearly Run Rate
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("NEXT UPCOMING")
                        .font(.system(size: 9, weight: .semibold, design: .rounded))
                        .foregroundColor(Color.white.opacity(0.6))
                        .tracking(0.6)
                    
                    HStack(spacing: 8) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(WidgetTheme.accentTint)
                                .frame(width: 32, height: 32)
                            
                            Image(systemName: entry.upcomingIcon)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(WidgetTheme.accent)
                        }
                        
                        VStack(alignment: .leading, spacing: 1) {
                            Text(entry.upcomingSubscription)
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                                .lineLimit(1)
                            
                            Text(entry.formattedUpcomingDate)
                                .font(.system(size: 10, weight: .medium, design: .rounded))
                                .foregroundColor(
                                    entry.isUpcomingOverdue
                                        ? Color(red: 255/255, green: 90/255, blue: 95/255)
                                        : (entry.isUpcomingToday ? WidgetTheme.accent : Color.white.opacity(0.65))
                                )
                        }
                    }
                    
                    if entry.upcomingCost > 0 {
                        Text(entry.formattedUpcomingCost)
                            .font(.system(size: 13, weight: .semibold, design: .rounded).monospacedDigit())
                            .foregroundColor(WidgetTheme.accent)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 1) {
                    Text("YEARLY RUN RATE")
                        .font(.system(size: 8, weight: .semibold, design: .rounded))
                        .foregroundColor(Color.white.opacity(0.5))
                        .tracking(0.6)
                    
                    Text(entry.formattedYearly)
                        .font(.system(size: 12, weight: .semibold, design: .rounded).monospacedDigit())
                        .foregroundColor(Color.white.opacity(0.8))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(14)
        .containerBackground(for: .widget) {
            WidgetTheme.solidBackground
        }
    }
}

// MARK: - Large Widget View (338x354pt)

struct LargeWidgetView: View {
    let entry: SimpleEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header Bar
            HStack {
                HStack(spacing: 6) {
                    SpendoraLogoEmblem(size: 20)
                    
                    Text("SPENDORA")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .tracking(1.0)
                        .foregroundColor(Color.white.opacity(0.85))
                }
                
                Spacer()
                
                Text("\(entry.activeCount) Active Subscriptions")
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundColor(Color.white.opacity(0.6))
            }
            
            // Executive Metrics Row
            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("MONTHLY SPEND")
                        .font(.system(size: 9, weight: .semibold, design: .rounded))
                        .foregroundColor(Color.white.opacity(0.6))
                    
                    Text(entry.formattedMonthly)
                        .font(.system(size: 24, weight: .semibold, design: .rounded).monospacedDigit())
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .background(WidgetTheme.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(WidgetTheme.cardBorder, lineWidth: 0.5)
                )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("YEARLY RUN RATE")
                        .font(.system(size: 9, weight: .semibold, design: .rounded))
                        .foregroundColor(Color.white.opacity(0.6))
                    
                    Text(entry.formattedYearly)
                        .font(.system(size: 24, weight: .semibold, design: .rounded).monospacedDigit())
                        .foregroundColor(WidgetTheme.accent)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .background(WidgetTheme.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(WidgetTheme.cardBorder, lineWidth: 0.5)
                )
            }
            
            // Next Charge Card Section
            VStack(alignment: .leading, spacing: 6) {
                Text("UPCOMING BILL")
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .foregroundColor(Color.white.opacity(0.6))
                    .tracking(0.6)
                
                HStack(spacing: 10) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(WidgetTheme.accentTint)
                            .frame(width: 38, height: 38)
                        
                        Image(systemName: entry.upcomingIcon)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(WidgetTheme.accent)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(entry.upcomingSubscription)
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text(entry.formattedUpcomingDate)
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .foregroundColor(
                                entry.isUpcomingOverdue
                                    ? Color(red: 255/255, green: 90/255, blue: 95/255)
                                    : (entry.isUpcomingToday ? WidgetTheme.accent : Color.white.opacity(0.65))
                            )
                    }
                    
                    Spacer()
                    
                    if entry.upcomingCost > 0 {
                        Text(entry.formattedUpcomingCost)
                            .font(.system(size: 16, weight: .semibold, design: .rounded).monospacedDigit())
                            .foregroundColor(WidgetTheme.accent)
                    }
                }
                .padding(10)
                .background(WidgetTheme.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(WidgetTheme.cardBorder, lineWidth: 0.5)
                )
            }
            
            Spacer(minLength: 0)
            
            // Footer Hint
            HStack {
                Image(systemName: "sparkles")
                    .font(.system(size: 11))
                    .foregroundColor(WidgetTheme.accent)
                
                Text("Tap to review budget & AI insights in Spendora")
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundColor(Color.white.opacity(0.55))
            }
        }
        .padding(14)
        .containerBackground(for: .widget) {
            WidgetTheme.solidBackground
        }
    }
}

// MARK: - Lock Screen Accessories

struct InlineAccessoryView: View {
    let entry: SimpleEntry

    var body: some View {
        Text("💳 Spendora: \(entry.formattedMonthly) • Next: \(entry.upcomingSubscription)")
    }
}

struct CircularAccessoryView: View {
    let entry: SimpleEntry

    var body: some View {
        Gauge(value: entry.budgetProgress) {
            Image(systemName: "creditcard.fill")
        } currentValueLabel: {
            Text("\(entry.activeCount)")
                .font(.system(size: 14, weight: .bold, design: .rounded))
        }
        .gaugeStyle(.accessoryCircular)
    }
}

struct RectangularAccessoryView: View {
    let entry: SimpleEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 4) {
                SpendoraLogoEmblem(size: 12)
                Text("SPENDORA")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
            }
            
            Text("Month: \(entry.formattedMonthly)")
                .font(.system(size: 12, weight: .semibold, design: .rounded))
            
            Text("Next: \(entry.upcomingSubscription) (\(entry.formattedUpcomingDate))")
                .font(.system(size: 10, design: .rounded))
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Widget Main Configuration

struct SpendoraWidget: Widget {
    let kind: String = "SpendoraWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: Provider()
        ) { entry in
            SpendoraWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Spendora Tracker")
        .description("Keep track of your monthly subscription spending and upcoming bill renewals at a glance.")
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .systemLarge,
            .accessoryInline,
            .accessoryCircular,
            .accessoryRectangular
        ])
    }
}

// MARK: - Previews

#Preview(as: .systemSmall) {
    SpendoraWidget()
} timeline: {
    SimpleEntry(
        date: .now,
        totalSpending: 76.26,
        totalYearly: 915.12,
        activeCount: 4,
        upcomingSubscription: "Netflix",
        upcomingCost: 15.99,
        upcomingDate: Date().addingTimeInterval(86400 * 3),
        upcomingIcon: "tv.fill",
        upcomingCategory: "Entertainment",
        monthlyBudget: 150.0,
        currencySymbol: "$",
        formattedMonthlyStored: "$76.26",
        formattedYearlyStored: "$915.12",
        formattedNextCostStored: "$15.99"
    )
}

#Preview(as: .systemMedium) {
    SpendoraWidget()
} timeline: {
    SimpleEntry(
        date: .now,
        totalSpending: 76.26,
        totalYearly: 915.12,
        activeCount: 4,
        upcomingSubscription: "ChatGPT Plus",
        upcomingCost: 20.00,
        upcomingDate: Date().addingTimeInterval(86400 * 2),
        upcomingIcon: "sparkles",
        upcomingCategory: "Productivity",
        monthlyBudget: 150.0,
        currencySymbol: "$",
        formattedMonthlyStored: "$76.26",
        formattedYearlyStored: "$915.12",
        formattedNextCostStored: "$20.00"
    )
}

#Preview(as: .systemLarge) {
    SpendoraWidget()
} timeline: {
    SimpleEntry(
        date: .now,
        totalSpending: 76.26,
        totalYearly: 915.12,
        activeCount: 4,
        upcomingSubscription: "Spotify Premium",
        upcomingCost: 10.99,
        upcomingDate: Date().addingTimeInterval(86400 * 5),
        upcomingIcon: "music.note",
        upcomingCategory: "Entertainment",
        monthlyBudget: 150.0,
        currencySymbol: "$",
        formattedMonthlyStored: "$76.26",
        formattedYearlyStored: "$915.12",
        formattedNextCostStored: "$10.99"
    )
}
