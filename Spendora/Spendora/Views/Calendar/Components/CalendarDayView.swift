//
//  CalendarDayView.swift
//  Spendora
//

import SwiftUI

// MARK: - CalendarDayView (Apple Standard Calendar Day Cell)

/**
 `CalendarDayView` displays calendar day numbers with Apple System Blue today indicator badge and billing dots.
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
                .font(Font.system(size: 14, weight: isToday ? .semibold : .regular, design: .default).monospacedDigit())
                .foregroundColor(
                    isToday
                        ? .white
                        : (isInMonth ? .textPrimary : .textSecondary.opacity(0.35))
                )
                .frame(width: 32, height: 32)
                .background(
                    Group {
                        if isToday {
                            Circle()
                                .fill(Color.brandPrimary)
                        } else if !subscriptions.isEmpty {
                            Circle()
                                .fill(Color.brandPrimary.opacity(0.12))
                        }
                    }
                )
            
            if !subscriptions.isEmpty {
                HStack(spacing: 3) {
                    ForEach(subscriptions.prefix(3), id: \.id) { sub in
                        Circle()
                            .fill(sub.categoryEnum.color)
                            .frame(width: 4.5, height: 4.5)
                    }
                }
            } else {
                Spacer().frame(height: 4.5)
            }
        }
    }
}
