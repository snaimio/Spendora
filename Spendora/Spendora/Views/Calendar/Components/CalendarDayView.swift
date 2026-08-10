//
//  CalendarDayView.swift
//  Spendora
//

import SwiftUI

// MARK: - CalendarDayView (Apple Native 44x44 Day Cell)

struct CalendarDayView: View {

    // MARK: - Properties

    let date: Date
    let isToday: Bool
    let isInMonth: Bool
    let subscriptions: [Subscription]

    // MARK: - Body

    var body: some View {
        VStack(spacing: 2) {
            Text(Calendar.current.component(.day, from: date).formatted())
                .font(Font.system(size: 14, weight: (isToday || !subscriptions.isEmpty) ? .bold : .regular, design: .rounded).monospacedDigit())
                .foregroundColor(
                    isToday
                        ? .white
                        : (isInMonth ? Color(.label) : Color(.tertiaryLabel).opacity(0.3))
                )
                .frame(width: 36, height: 36)
                .background(
                    Group {
                        if isToday {
                            Circle()
                                .fill(SpendoraTheme.accent)
                        } else if !subscriptions.isEmpty {
                            Circle()
                                .stroke(SpendoraTheme.accent, lineWidth: 2)
                        }
                    }
                )
            
            if !subscriptions.isEmpty {
                Circle()
                    .fill(SpendoraTheme.accent)
                    .frame(width: 5, height: 5)
            } else {
                Spacer().frame(height: 5)
            }
        }
        .frame(width: 44, height: 44)
    }
}
