//
//  QuickAddView.swift
//

import SwiftUI

// MARK: - QuickAddView

struct QuickAddView: View {
    let onSelect: (SubscriptionPreset) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""

    var filteredPresets: [SubscriptionPreset] {
        if searchText.isEmpty {
            return SubscriptionPreset.all
        }
        return SubscriptionPreset.all.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.category.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Select any subscription provider to automatically populate details and theme colors.")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    LazyVGrid(
                        columns: Array(
                            repeating: GridItem(.flexible(), spacing: 14),
                            count: 3
                        ),
                        spacing: 16
                    ) {
                        ForEach(filteredPresets) { preset in
                            Button {
                                onSelect(preset)
                                dismiss()
                            } label: {
                                VStack(spacing: 10) {
                                    ZStack {
                                        Circle()
                                            .fill(
                                                LinearGradient(
                                                    colors: [preset.color.opacity(0.25), preset.color.opacity(0.1)],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .frame(width: 56, height: 56)

                                        Image(systemName: preset.systemIcon)
                                            .font(.title2)
                                            .foregroundColor(preset.color)
                                    }

                                    Text(preset.name)
                                        .font(.system(.caption, design: .rounded))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.primary)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.75)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .padding(.horizontal, 6)
                                .background(Color.cardBackground)
                                .cornerRadius(18)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(preset.color.opacity(0.25), lineWidth: 1)
                                )
                                .shadow(color: preset.color.opacity(0.08), radius: 8, x: 0, y: 3)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 12)
            }
            .searchable(text: $searchText, prompt: "Search popular providers...")
            .background(Color.appBackground.ignoresSafeArea())
            .navigationTitle("Popular Providers")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.brandPrimary)
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    QuickAddView { _ in }
}
