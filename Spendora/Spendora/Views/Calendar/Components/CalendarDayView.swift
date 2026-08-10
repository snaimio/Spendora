//
//  CalendarDayView.swift
//  Spendora
//

import SwiftUI

// MARK: - CalendarDayView (Obsidian Indigo Calendar Cell)

/**
 `CalendarDayView` displays calendar day numbers with Obsidian Indigo today indicator (30x30 solid)
 and 1.5pt Indigo stroke rings + 4pt category dots for billing renewal dates.
 */
struct CalendarDayView: View {

    // MARK: - Properties

    let date: Date
    let isToday: Bool
    let isInMonth: Bool
    let subscriptions: [Subscription]

    // MARK: - Body

    var body: some View {
        VStack(spacing: 3) {
            Text(Calendar.current.component(.day, from: date).formatted())
                .font(Font.system(size: 13, weight: (isToday || !subscriptions.isEmpty) ? .bold : .regular, design: .default).monospacedDigit())
                .foregroundColor(
                    isToday
                        ? .white
                        : (isInMonth ? .textPrimary : .textTertiary.opacity(0.4))
                )
                .frame(width: 30, height: 30)
                .background(
                    Group {
                        if isToday {
                            Circle()
                                .fill(Color.brandPrimary)
                                .shadow(color: Color.brandPrimary.opacity(0.35), radius: 4, x: 0, y: 2)
                        } else if !subscriptions.isEmpty {
                            Circle()
                                .stroke(Color.brandPrimary, lineWidth: 1.5)
                                .background(Circle().fill(Color.brandPrimary.opacity(0.08)))
                        }
                    }
                )
            
            if !subscriptions.isEmpty {
                HStack(spacing: 3) {
                    ForEach(subscriptions.prefix(3), id: \.id) { sub in
                        Circle()
                            .fill(sub.categoryEnum.color)
                            .frame(width: 4, height: 4)
                    }
                }
            } else {
                Spacer().frame(height: 4)
            }
        }
    }
}
