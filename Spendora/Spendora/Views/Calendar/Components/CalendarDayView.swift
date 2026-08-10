//
//  CalendarDayView.swift
//  Spendora
//

import SwiftUI

// MARK: - CalendarDayView (Coral Fire Calendar Day Cell)

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
                        : (isInMonth ? SpendoraTheme.Colors.textPrimary : SpendoraTheme.Colors.textTertiary.opacity(0.35))
                )
                .frame(width: 32, height: 32)
                .background(
                    Group {
                        if isToday {
                            // Today circle: coral gradient fill #FF6B6B→#FF8E53, white bold number
                            Circle()
                                .fill(SpendoraTheme.Colors.coralGradient)
                                .shadow(color: SpendoraTheme.Colors.coral.opacity(0.35), radius: 6, x: 0, y: 2)
                        } else if !subscriptions.isEmpty {
                            // Billing days: 2pt coral stroke ring around number
                            Circle()
                                .stroke(SpendoraTheme.Colors.coral, lineWidth: 2.0)
                                .background(Circle().fill(SpendoraTheme.Colors.coralTint))
                        }
                    }
                )
            
            // 5pt coral dot centered below
            if !subscriptions.isEmpty {
                Circle()
                    .fill(SpendoraTheme.Colors.coral)
                    .frame(width: 5, height: 5)
            } else {
                Spacer().frame(height: 5)
            }
        }
    }
}
