/**
 * Main/Core Functions & Purpose:
 * CalendarDayView component displaying date numbers, today indicator circle, and subscription billing dots on the calendar grid.
 */

import SwiftUI

struct CalendarDayView: View {
    let date: Date
    let isToday: Bool
    let isInMonth: Bool
    let subscriptions: [Subscription]
    
    var body: some View {
        VStack(spacing: 2) {
            Text(Calendar.current.component(.day, from: date).formatted())
                .font(.callout)
                .fontWeight(isToday ? .bold : .regular)
                .foregroundColor(isInMonth ? .primary : .secondary)
                .frame(width: 36, height: 36)
                .background(
                    Group {
                        if isToday {
                            Circle()
                                .fill(Color.brandPrimary)
                        } else if !subscriptions.isEmpty {
                            Circle()
                                .fill(Color.brandPrimary.opacity(0.15))
                        }
                    }
                )
                .foregroundColor(isToday ? .white : .primary)
            
            if !subscriptions.isEmpty {
                HStack(spacing: 2) {
                    ForEach(subscriptions.prefix(3), id: \.id) { sub in
                        Circle()
                            .fill(Color(hex: sub.colorHex ?? "#6C63FF"))
                            .frame(width: 4, height: 4)
                    }
                }
            }
        }
    }
}
