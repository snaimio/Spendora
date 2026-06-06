//
//  DebugView.swift
//  Spendora
//

import SwiftUI
import SwiftData

struct DebugView: View {
    @Query private var subscriptions: [Subscription]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            List {
                Section("Database Status") {
                    Text("Total subscriptions: \(subscriptions.count)")
                        .font(.headline)
                }
                
                Section("All Subscriptions") {
                    ForEach(subscriptions) { sub in
                        VStack(alignment: .leading) {
                            Text(sub.displayName)
                                .font(.headline)
                            Text("Cost: \(sub.cost)")
                                .font(.caption)
                            Text("ID: \(sub.id.uuidString)")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            modelContext.delete(subscriptions[index])
                        }
                        try? modelContext.save()
                    }
                }
            }
            .navigationTitle("Debug")
            .toolbar {
                EditButton()
            }
        }
    }
}
