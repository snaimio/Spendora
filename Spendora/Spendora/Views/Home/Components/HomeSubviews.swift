//
//  HomeSubviews.swift
//

/**
 * Main/Core Functions & Purpose:
 * HomeSubviews extracted component file containing StatCardView, SearchBarView, SortChipsView, SubscriptionCardView, and EmptyStateView.
 */

import SwiftUI

// MARK: - Stat Card

// MARK: - StatCardView

/**
 `StatCardView` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for statcardview handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `StatCardView` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct StatCardView: View {

    // MARK: - Properties

    let icon: String  // icon property
    let title: String  // title property
    let value: String  // value property
    let colors: [Color]  // colors property
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: colors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 32, height: 32)
                
                Image(systemName: icon)
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.system(.caption2, design: .rounded))
                    .foregroundColor(.textSecondary)
                
                Text(value)
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
            }
            
            Spacer(minLength: 4)
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.cardBackground)
                .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
        )
    }
}

// MARK: - Search Bar

// MARK: - SearchBarView

/**
 `SearchBarView` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for searchbarview handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `SearchBarView` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct SearchBarView: View {

    // MARK: - Properties

    @Binding var searchText: String
    
    // MARK: - Body

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.textSecondary)
                .font(.system(size: 15))
            
            TextField("Search subscriptions...", text: $searchText)
                .font(AppStyles.Typography.body)
                .foregroundColor(.textPrimary)
                .autocorrectionDisabled()
            
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.textSecondary)
                        .font(.system(size: 15))
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color(hex: "#2C2C2E"), lineWidth: 1)
        )
    }
}

// MARK: - Sort Chips

struct SortChipsView: View {

    // MARK: - Properties

    @Binding var sortOption: SortOption

    // MARK: - Body

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            sortOption = option
                        }
                    } label: {
                        Text(option.rawValue)
                            .font(AppStyles.Typography.captionBold)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .background(
                                Capsule()
                                    .fill(sortOption == option ? Color.brandPrimary : Color(hex: "#2C2C2E"))
                            )
                            .foregroundColor(sortOption == option ? Color(hex: "#0E0E10") : .textSecondary)
                    }
                }
            }
        }
    }
}
