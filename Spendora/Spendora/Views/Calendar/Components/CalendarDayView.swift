//
//  CalendarDayView.swift
//  Spendora
//

import SwiftUI

// MARK: - CalendarDayView

/**
 `CalendarDayView` displays calendar day numbers with Spendora Teal today indicator badge and billing dots.
 */
struct CalendarDayView: View {

    // MARK: - Properties

    let date: Date
    let isToday: Bool
    let isInMonth: Bool
    let subscriptions: [Subscription]
    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Body

    var body: some View {
        VStack(spacing: 4) {
            Text(Calendar.current.component(.day, from: date).formatted())
                .font(.system(size: 14, weight: isToday ? .bold : .medium, design: .rounded))
                .foregroundColor(
                    isToday
                        ? (colorScheme == .dark ? Color(hex: "#0F0F1A") : .white)
                        : (isInMonth ? .textPrimary : .textSecondary.opacity(0.35))
                )
                .frame(width: 34, height: 34)
                .background(
                    Group {
                        if isToday {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: "#00D4AA"), Color(hex: "#00B4D8")],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .shadow(color: Color(hex: "#00D4AA").opacity(0.4), radius: 4, y: 2)
                        } else if !subscriptions.isEmpty {
                            Circle()
                                .fill(Color(hex: "#00D4AA").opacity(0.16))
                        }
                    }
                )
            
            if !subscriptions.isEmpty {
                HStack(spacing: 3) {
                    ForEach(subscriptions.prefix(3), id: \.id) { sub in
                        Circle()
                            .fill(sub.categoryEnum.color)
                            .frame(width: 5, height: 5)
                    }
                }
            } else {
                Spacer().frame(height: 5)
            }
        }
    }
}
