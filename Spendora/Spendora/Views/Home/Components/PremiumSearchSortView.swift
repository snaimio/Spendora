//
//  PremiumSearchSortView.swift
//  Spendora
//

import SwiftUI

struct PremiumSearchSortView: View {
    @Binding var searchText: String
    @Binding var sortOption: SortOption
    
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
