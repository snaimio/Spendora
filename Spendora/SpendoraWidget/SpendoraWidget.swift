//
//  SpendoraWidget.swift
//  SpendoraWidget
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            totalSpending: 0,
            upcomingSubscription: "No subscriptions"
        )
    }
    
    func getSnapshot(
        in context: Context,
        completion: @escaping (SimpleEntry) -> Void
    ) {
        let entry = SimpleEntry(
            date: Date(),
            totalSpending: 0,
            upcomingSubscription: "No subscriptions"
        )
        completion(entry)
    }
    
    // 👇 CRITICAL: This reads data from the app
    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<SimpleEntry>) -> Void
    ) {
        // 👇 MUST match WidgetSyncService
        let defaults = UserDefaults(suiteName: "group.com.trios2026sn.Spendora")
        
        // 👇 MUST match the keys in WidgetSyncService
        let total = defaults?.double(forKey: "totalMonthly") ?? 0
        let next = defaults?.string(forKey: "nextSubName") ?? "No subscriptions"
        
        let entry = SimpleEntry(
            date: Date(),
            totalSpending: total,
            upcomingSubscription: next
        )
        
        // Refresh every hour
        let refreshDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
        
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let totalSpending: Double
    let upcomingSubscription: String
}

struct SpendoraWidgetEntryView: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Spendora")
                .font(.headline)
                .foregroundColor(.blue)
            
            Text("$\(entry.totalSpending, specifier: "%.2f")")
                .font(.title)
                .bold()
            
            if entry.totalSpending > 0 {
                Text("Next: \(entry.upcomingSubscription)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                Text("Add a subscription")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
}

@main
struct SpendoraWidget: Widget {
    let kind: String = "SpendoraWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: Provider()
        ) { entry in
            SpendoraWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Spendora")
        .description("Track your subscription spending.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Preview
#Preview(as: .systemSmall) {
    SpendoraWidget()
} timeline: {
    SimpleEntry(
        date: .now,
        totalSpending: 82.47,
        upcomingSubscription: "Netflix"
    )
}
