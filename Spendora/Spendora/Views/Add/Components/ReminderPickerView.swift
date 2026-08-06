//
//  ReminderPickerView.swift
//

import SwiftUI

// MARK: - ReminderOption Enum

enum ReminderOption: Int, CaseIterable, Identifiable {
    case disabled = -1
    case sameDay = 0
    case oneDayBefore = 1
    case twoDaysBefore = 2
    case threeDaysBefore = 3
    case oneWeekBefore = 7
    
    var id: Int { rawValue }
    
    var displayName: String {
        switch self {
        case .disabled: return "Disabled"
        case .sameDay: return "On Due Date"
        case .oneDayBefore: return "1 Day Before"
        case .twoDaysBefore: return "2 Days Before"
        case .threeDaysBefore: return "3 Days Before"
        case .oneWeekBefore: return "1 Week Before"
        }
    }
    
    var icon: String {
        switch self {
        case .disabled: return "bell.slash.fill"
        case .sameDay: return "bell.fill"
        default: return "bell.badge.fill"
        }
    }
}

// MARK: - ReminderPickerView

struct ReminderPickerView: View {
    @Binding var reminderDaysBefore: Int
    
    var body: some View {
        PremiumFormField(
            icon: "bell.circle.fill",
            title: "Reminder Alert",
            iconColor: .brandRose
        ) {
            Picker("Reminder Alert", selection: $reminderDaysBefore) {
                ForEach(ReminderOption.allCases) { option in
                    Label(option.displayName, systemImage: option.icon)
                        .tag(option.rawValue)
                }
            }
            .labelsHidden()
            .tint(.brandPrimary)
        }
    }
}
