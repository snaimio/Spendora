/**
 * Main/Core Functions & Purpose:
 * HomeSubviews extracted component file containing StatCardView, SearchBarView, SortChipsView, SubscriptionCardView, and EmptyStateView.
 */

import SwiftUI

// MARK: - Stat Card
struct StatCardView: View {
    let icon: String
    let title: String
    let value: String
    let colors: [Color]
    
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
struct SearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.textSecondary)
                .font(.subheadline)
            
            TextField("Search subscriptions...", text: $searchText)
                .font(.system(.body, design: .rounded))
                .foregroundColor(.textPrimary)
                .autocorrectionDisabled()
            
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.textSecondary)
                        .font(.subheadline)
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.cardBackground)
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
        )
    }
}

// MARK: - Sort Chips
struct SortChipsView: View {
    @Binding var sortOption: SortOption
    
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
                            .font(.system(.caption, design: .rounded))
                            .fontWeight(sortOption == option ? .semibold : .regular)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(sortOption == option ?
                                        LinearGradient(
                                            colors: [Color(hex: "#FF6B6B"), Color(hex: "#FFE66D")],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ) :
                                        LinearGradient(
                                            colors: [Color(.secondarySystemBackground), Color(.secondarySystemBackground)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                            .foregroundColor(sortOption == option ? .white : .textSecondary)
                    }
                }
            }
        }
    }
}
