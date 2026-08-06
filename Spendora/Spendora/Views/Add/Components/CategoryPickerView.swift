//
//  CategoryPickerView.swift
//

import SwiftUI


// MARK: - CategoryPickerView

/**
 `CategoryPickerView` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for categorypickerview handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `CategoryPickerView` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct CategoryPickerView: View {

    // MARK: - Properties

    @Binding var selectedCategory: String
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        PremiumFormField(
            icon: "folder.fill",
            title: "Category",
            iconColor: .brandRose
        ) {
            Picker("", selection: $selectedCategory) {
                ForEach(SubscriptionCategory.allCases, id: \.rawValue) { category in
                    Label(category.rawValue, systemImage: category.icon)
                        .tag(category.rawValue)
                }
            }
            .pickerStyle(.menu)
            .labelsHidden()
            .tint(.brandPrimary)
        }
    }
}
