//
//  HomeSubviews.swift
//  Spendora
//

import SwiftUI

// MARK: - SearchBarView (60-30-10 Coral Fire Search Field)

struct SearchBarView: View {

    // MARK: - Properties

    @Binding var searchText: String
    
    // MARK: - Body

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(SpendoraTheme.Colors.coral)
                .font(.system(size: 15, weight: .semibold))
            
            TextField("Search subscriptions...", text: $searchText)
                .font(SpendoraTheme.Typography.body)
                .foregroundColor(SpendoraTheme.Colors.textPrimary)
                .autocorrectionDisabled()
            
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(SpendoraTheme.Colors.textSecondary)
                        .font(.system(size: 15))
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 11)
        .background(SpendoraTheme.Colors.coralTint)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(SpendoraTheme.Colors.border, lineWidth: 0.5)
        )
    }
}

// MARK: - Sort Chips (Coral Fire Capsule Filter)

struct SortChipsView: View {

    // MARK: - Properties

    @Binding var sortOption: SortOption

    // MARK: - Body

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            sortOption = option
                        }
                    } label: {
                        Text(option.rawValue)
                            .font(.system(size: 12, weight: .semibold))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Group {
                                    if sortOption == option {
                                        SpendoraTheme.Colors.coralGradient
                                    } else {
                                        LinearGradient(
                                            colors: [SpendoraTheme.Colors.coralTint, SpendoraTheme.Colors.coralTint],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    }
                                }
                            )
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(sortOption == option ? Color.clear : SpendoraTheme.Colors.border, lineWidth: 0.5)
                            )
                            .foregroundColor(sortOption == option ? .white : SpendoraTheme.Colors.coralWarm)
                    }
                }
            }
        }
    }
}
