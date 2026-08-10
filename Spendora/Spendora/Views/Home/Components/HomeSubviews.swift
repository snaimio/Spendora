//
//  HomeSubviews.swift
//  Spendora
//

import SwiftUI

// MARK: - Sort Chips (Apple Native Capsule Filter)

struct SortChipsView: View {

    // MARK: - Properties

    @Binding var sortOption: SortOption

    // MARK: - Body

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            sortOption = option
                        }
                    } label: {
                        Text(option.rawValue)
                            .font(.caption.weight(.semibold))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .background(
                                sortOption == option
                                    ? SpendoraTheme.accent
                                    : Color(.secondarySystemBackground)
                            )
                            .clipShape(Capsule())
                            .foregroundColor(
                                sortOption == option
                                    ? .white
                                    : .secondary
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

// MARK: - SearchBarView (Native Search Bar Adapter)

struct SearchBarView: View {
    @Binding var searchText: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
                .font(.system(size: 15))
            
            TextField("Search subscriptions", text: $searchText)
                .font(.body)
                .foregroundColor(Color(.label))
                .autocorrectionDisabled()
            
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                        .font(.system(size: 15))
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}
