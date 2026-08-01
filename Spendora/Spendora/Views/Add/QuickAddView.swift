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
                    Text("Select from 40+ popular subscription providers to auto-fill details.")
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
                                            .fill(preset.color.opacity(0.18))
                                            .frame(width: 58, height: 58)

                                        Image(systemName: preset.systemIcon)
                                            .font(.title2)
                                            .foregroundColor(preset.color)
                                    }

                                    Text(preset.name)
                                        .font(.system(.caption, design: .rounded))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.primary)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color(.secondarySystemGroupedBackground))
                                .cornerRadius(16)
                                .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 12)
            }
            .searchable(text: $searchText, prompt: "Search 40+ popular providers...")
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Popular Providers")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.system(.body, design: .rounded))
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    QuickAddView { _ in }
}
