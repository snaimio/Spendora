//
//  SpendoraWidget.swift
//  SpendoraWidget
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), totalSpending: 0, upcomingSubscription: "No subscriptions")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), totalSpending: 0, upcomingSubscription: "No subscriptions")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        // 🔥 Read REAL data from shared UserDefaults
        let defaults = UserDefaults(suiteName: "group.com.trios2026sn.Spendora")
        let total = defaults?.double(forKey: "totalSpending") ?? 0
        let next = defaults?.string(forKey: "nextSubscription") ?? "No subscriptions"
        
        let entry = SimpleEntry(date: Date(), totalSpending: total, upcomingSubscription: next)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
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
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            SpendoraWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Spendora")
        .description("Track your subscription spending.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
