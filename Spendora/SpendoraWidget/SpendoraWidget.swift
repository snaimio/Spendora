//
//  SpendoraWidget.swift
//  Spendora
//

import WidgetKit
import SwiftUI

// MARK: - Timeline Provider

struct Provider: TimelineProvider {

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            totalSpending: 142.50,
            totalYearly: 1710.00,
            activeCount: 5,
            upcomingSubscription: "Netflix",
            upcomingCost: 15.99,
            upcomingDate: Date().addingTimeInterval(86400 * 3),
            currencySymbol: "$"
        )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(
            date: Date(),
            totalSpending: 142.50,
            totalYearly: 1710.00,
            activeCount: 5,
            upcomingSubscription: "Netflix",
            upcomingCost: 15.99,
            upcomingDate: Date().addingTimeInterval(86400 * 3),
            currencySymbol: "$"
        )
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let defaults = UserDefaults(suiteName: "group.com.trios2026sn.Spendora")
        
        let total = defaults?.double(forKey: "totalMonthly") ?? 0
        let yearly = defaults?.double(forKey: "totalYearly") ?? (total * 12)
        let count = defaults?.integer(forKey: "activeCount") ?? 0
        let next = defaults?.string(forKey: "nextSubName") ?? "None"
        let nextCost = defaults?.double(forKey: "nextSubCost") ?? 0
        let nextTime = defaults?.double(forKey: "nextSubDate") ?? 0
        let symbol = defaults?.string(forKey: "currencySymbol") ?? "$"
        
        let upcomingDate = nextTime > 0 ? Date(timeIntervalSince1970: nextTime) : nil
        
        let entry = SimpleEntry(
            date: Date(),
            totalSpending: total,
            totalYearly: yearly,
            activeCount: count,
            upcomingSubscription: next,
            upcomingCost: nextCost,
            upcomingDate: upcomingDate,
            currencySymbol: symbol
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
    let currencySymbol: String
    
    var formattedMonthly: String {
        let amount = String(format: "%.2f", totalSpending)
        return "\(currencySymbol)\(amount)"
    }
    
    var formattedUpcomingCost: String {
        let amount = String(format: "%.2f", upcomingCost)
        return "\(currencySymbol)\(amount)"
    }
    
    var formattedUpcomingDate: String {
        guard let upcomingDate = upcomingDate else { return "No bills due" }
        if Calendar.current.isDateInToday(upcomingDate) {
            return "Due Today"
        }
        let days = Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: Date()), to: Calendar.current.startOfDay(for: upcomingDate)).day ?? 0
        if days == 1 { return "Due Tomorrow" }
        if days > 1 { return "In \(days) days" }
        return upcomingDate.formatted(.dateTime.month(.abbreviated).day())
    }
}

// MARK: - Entry View

struct SpendoraWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemMedium:
            MediumWidgetView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}

// MARK: - Small Widget View

struct SmallWidgetView: View {
    let entry: SimpleEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Header Bar
            HStack(spacing: 5) {
                Image(systemName: "creditcard.fill")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Color(hex: "#007AFF"))
                
                Text("SPENDORA")
                    .font(.system(size: 10, weight: .bold, design: .default))
                    .tracking(1.0)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            
            Spacer(minLength: 2)
            
            // Spend Section
            VStack(alignment: .leading, spacing: 2) {
                Text("THIS MONTH")
                    .font(.system(size: 9, weight: .semibold, design: .default))
                    .foregroundColor(.secondary)
                    .tracking(0.8)
                
                Text(entry.formattedMonthly)
                    .font(.system(size: 22, weight: .black, design: .default).monospacedDigit())
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            
            Spacer(minLength: 2)
            
            // Upcoming Charge Pill
            HStack(spacing: 5) {
                Image(systemName: "bell.fill")
                    .font(.system(size: 9))
                    .foregroundColor(Color(hex: "#FF9500"))
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(entry.upcomingSubscription)
                        .font(.system(size: 10, weight: .semibold, design: .default))
                        .lineLimit(1)
                    
                    Text(entry.formattedUpcomingDate)
                        .font(.system(size: 8, design: .default))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.secondary.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .padding(12)
        .containerBackground(for: .widget) {
            Color(.systemBackground)
        }
    }
}

// MARK: - Medium Widget View

struct MediumWidgetView: View {
    let entry: SimpleEntry

    var body: some View {
        HStack(spacing: 16) {
            // Left Half: Spending Summary
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 5) {
                    Image(systemName: "creditcard.fill")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(hex: "#007AFF"))
                    
                    Text("SPENDORA")
                        .font(.system(size: 11, weight: .bold, design: .default))
                        .tracking(1.2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("MONTHLY SPEND")
                        .font(.system(size: 9, weight: .semibold, design: .default))
                        .foregroundColor(.secondary)
                        .tracking(0.8)
                    
                    Text(entry.formattedMonthly)
                        .font(.system(size: 26, weight: .black, design: .default).monospacedDigit())
                        .foregroundColor(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
                
                Text("\(entry.activeCount) active subscriptions")
                    .font(.system(size: 10, design: .default))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            // Right Half: Next Charge & Yearly Stats
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("NEXT BILL")
                        .font(.system(size: 9, weight: .semibold, design: .default))
                        .foregroundColor(.secondary)
                        .tracking(0.8)
                    
                    Text(entry.upcomingSubscription)
                        .font(.system(size: 14, weight: .bold, design: .default))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    HStack(spacing: 4) {
                        Text(entry.formattedUpcomingCost)
                            .font(.system(size: 11, weight: .semibold, design: .default).monospacedDigit())
                            .foregroundColor(Color(hex: "#007AFF"))
                        
                        Text("• \(entry.formattedUpcomingDate)")
                            .font(.system(size: 10, design: .default))
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 1) {
                    Text("YEARLY RUN RATE")
                        .font(.system(size: 8, weight: .semibold, design: .default))
                        .foregroundColor(.secondary)
                        .tracking(0.8)
                    
                    Text(String(format: "%@%.2f", entry.currencySymbol, entry.totalYearly))
                        .font(.system(size: 12, weight: .semibold, design: .default).monospacedDigit())
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(14)
        .containerBackground(for: .widget) {
            Color(.systemBackground)
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
        .description("Keep track of your monthly spending and upcoming subscription renewals at a glance.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Color Hex Helper
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Preview
#Preview(as: .systemSmall) {
    SpendoraWidget()
} timeline: {
    SimpleEntry(
        date: .now,
        totalSpending: 82.47,
        totalYearly: 989.64,
        activeCount: 4,
        upcomingSubscription: "Netflix",
        upcomingCost: 15.99,
        upcomingDate: Date().addingTimeInterval(86400 * 2),
        currencySymbol: "$"
    )
}

#Preview(as: .systemMedium) {
    SpendoraWidget()
} timeline: {
    SimpleEntry(
        date: .now,
        totalSpending: 142.50,
        totalYearly: 1710.00,
        activeCount: 6,
        upcomingSubscription: "Apple One",
        upcomingCost: 22.95,
        upcomingDate: Date().addingTimeInterval(86400 * 3),
        currencySymbol: "$"
    )
}
