//
//  CalendarDayView.swift
//  Spendora
//

import SwiftUI

// MARK: - CalendarDayView (Slate & Rose-Gold Luxury Calendar Day Cell)

/**
 `CalendarDayView` displays calendar day numbers with Rose-Gold today indicator and glowing ring indicators for billing dates.
 */
struct CalendarDayView: View {

    // MARK: - Properties

    let date: Date
    let isToday: Bool
    let isInMonth: Bool
    let subscriptions: [Subscription]

    // MARK: - Body

    var body: some View {
        VStack(spacing: 4) {
            Text(Calendar.current.component(.day, from: date).formatted())
                .font(Font.system(size: 14, weight: (isToday || !subscriptions.isEmpty) ? .bold : .regular, design: .default).monospacedDigit())
                .foregroundColor(
                    isToday
                        ? Color(hex: "#0E0E10")
                        : (isInMonth ? .textPrimary : .textSecondary.opacity(0.35))
                )
                .frame(width: 32, height: 32)
                .background(
                    Group {
                        if isToday {
                            Circle()
                                .fill(Color.brandPrimary)
                                .shadow(color: Color.brandPrimary.opacity(0.4), radius: 6, x: 0, y: 2)
                        } else if !subscriptions.isEmpty {
                            Circle()
                                .stroke(Color.brandPrimary, lineWidth: 1.5)
                                .background(Circle().fill(Color.brandPrimary.opacity(0.12)))
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
