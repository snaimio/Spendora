//
//  QuickAddView.swift
//

import SwiftUI


// MARK: - QuickAddView

/**
 `QuickAddView` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for quickaddview handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `QuickAddView` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct QuickAddView: View {

    // MARK: - Properties

    let onSelect: (SubscriptionPreset) -> Void  // onSelect property

    @Environment(\.dismiss) private var dismiss


    // MARK: - Body

    /// Main SwiftUI layout body property.
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


// MARK: - Preview

/// Xcode Canvas Preview Provider.
#Preview {
    QuickAddView { _ in }
}
