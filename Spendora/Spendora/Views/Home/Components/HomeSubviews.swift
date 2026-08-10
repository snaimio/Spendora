//
//  HomeSubviews.swift
//  Spendora
//

import SwiftUI

// MARK: - SearchBarView

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
        .padding(.vertical, 11)
        .background(Color.secondaryCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.cardBorder, lineWidth: 0.5)
        )
    }
}

// MARK: - Sort Chips (Fintech Indigo Capsule Filter)

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
                            .font(AppStyles.Typography.captionBold)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(sortOption == option ? Color.brandPrimary : Color.secondaryCardBackground)
                            )
                            .overlay(
                                Capsule()
                                    .stroke(sortOption == option ? Color.clear : Color.cardBorder, lineWidth: 0.5)
                            )
                            .foregroundColor(sortOption == option ? .white : .textSecondary)
                    }
                }
            }
        }
    }
}
