//
//  CalendarDayView.swift
//

/**
 * Main/Core Functions & Purpose:
 * CalendarDayView component displaying date numbers, today indicator circle, and subscription billing dots on the calendar grid.
 */

import SwiftUI


// MARK: - CalendarDayView

/**
 `CalendarDayView` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for calendardayview handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `CalendarDayView` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct CalendarDayView: View {

    // MARK: - Properties

    let date: Date  // date property
    let isToday: Bool  // isToday property
    let isInMonth: Bool  // isInMonth property
    let subscriptions: [Subscription]  // subscriptions property
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
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
