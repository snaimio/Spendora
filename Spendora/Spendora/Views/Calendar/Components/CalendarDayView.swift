//
//  CalendarDayView.swift
//  Spendora
//

import SwiftUI

// MARK: - CalendarDayView (Golden UX 44x44 Touch Target & 36x36 Indicator)

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
                .font(Font.system(size: 13, weight: (isToday || !subscriptions.isEmpty) ? .bold : .regular, design: .default).monospacedDigit())
                .foregroundColor(
                    isToday
                        ? .white
                        : (isInMonth ? SpendoraTheme.Colors.textPrimary : SpendoraTheme.Colors.textTertiary.opacity(0.25))
                )
                .frame(width: 36, height: 36)
                .background(
                    Group {
                        if isToday {
                            Circle()
                                .fill(SpendoraTheme.Colors.coralGradient)
                                .shadow(color: SpendoraTheme.Colors.coral.opacity(0.35), radius: 6, x: 0, y: 2)
                        } else if !subscriptions.isEmpty {
                            Circle()
                                .stroke(SpendoraTheme.Colors.coral, lineWidth: 2.0)
                                .background(Circle().fill(SpendoraTheme.Colors.coralTint))
                        }
                    }
                )
            
            if !subscriptions.isEmpty {
                Circle()
                    .fill(SpendoraTheme.Colors.coral)
                    .frame(width: 5, height: 5)
            } else {
                Spacer().frame(height: 5)
            }
        }
        .frame(width: 44, height: 44)
    }
}
