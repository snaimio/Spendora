//
//  SpendoraWidget.swift
//  SpendoraWidget
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), totalSpending: 82.47, upcomingSubscription: "Netflix")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), totalSpending: 82.47, upcomingSubscription: "Netflix")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let entry = SimpleEntry(date: Date(), totalSpending: 82.47, upcomingSubscription: "Netflix")
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
        VStack {
            Text("Spendora")
                .font(.headline)
                .foregroundColor(.blue)
            Text("$\(entry.totalSpending, specifier: "%.2f")")
                .font(.title)
                .bold()
            Text("Next: \(entry.upcomingSubscription)")
                .font(.caption)
                .foregroundColor(.secondary)
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
