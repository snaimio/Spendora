//
//  QuickAddView.swift
//  Spendora
//

import SwiftUI

struct QuickAddView: View {
    let onSelect: (SubscriptionPreset) -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(
                    columns: Array(
                        repeating: GridItem(.flexible()),
                        count: 3
                    ),
                    spacing: 16
                ) {
                    ForEach(SubscriptionPreset.all) { preset in
                        Button {
                            onSelect(preset)
                            dismiss()
                        } label: {
                            VStack(spacing: 8) {
                                ZStack {
                                    Circle()
                                        .fill(preset.color.opacity(0.2))
                                        .frame(width: 64, height: 64)

                                    Image(systemName: preset.systemIcon)
                                        .font(.title2)
                                        .foregroundColor(preset.color)
                                }

                                Text(preset.name)
                                    .font(.caption)
                                    .foregroundColor(.primary)
                                    .lineLimit(1)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .navigationTitle("Quick Add")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    QuickAddView { _ in }
}
