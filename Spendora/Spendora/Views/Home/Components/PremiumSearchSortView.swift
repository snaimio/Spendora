//
//  PremiumSearchSortView.swift
//

import SwiftUI

// SortOption is now in Models/SortOption.swift


// MARK: - PremiumSearchSortView

/**
 `PremiumSearchSortView` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for premiumsearchsortview handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `PremiumSearchSortView` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct PremiumSearchSortView: View {

    // MARK: - Properties

    @Binding var searchText: String
    @Binding var sortOption: SortOption
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                
                TextField("Search subscriptions...", text: $searchText)
                    .font(.system(.body, design: .rounded))
                    .autocorrectionDisabled()
                
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }
                }
            }
            .padding(14)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(SortOption.allCases, id: \.self) { option in
                        SortChip(
                            title: option.rawValue,
                            isSelected: sortOption == option
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                sortOption = option
                            }
                        }
                    }
                }
                .padding(.horizontal, 2)
            }
        }
    }
}
