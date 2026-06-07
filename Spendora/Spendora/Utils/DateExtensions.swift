//
//  DateExtensions.swift
//  Spendora
//

import Foundation

extension Date {
    
    /// Format date as "MMM d, yyyy" (e.g., "Jan 15, 2025")
    var formattedAsMonthDayYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: self)
    }
    
    /// Format date as "EEEE, MMM d" (e.g., "Monday, Jan 15")
    var formattedAsWeekdayMonthDay: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: self)
    }
    
    /// Format date as "MMM d" (e.g., "Jan 15")
    var formattedAsMonthDay: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: self)
    }
    
    /// Get days until this date from today
    func daysUntil(from date: Date = Date()) -> Int {
        Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    
    /// Check if date is within next N days
    func isWithinNext(_ days: Int, from date: Date = Date()) -> Bool {
        let daysUntil = daysUntil(from: date)
        return daysUntil >= 0 && daysUntil <= days
    }
    
    /// Start of day
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    /// End of day
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay) ?? self
    }
    
    /// Add days to date
    func addingDays(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }
    
    /// Add months to date
    func addingMonths(_ months: Int) -> Date {
        Calendar.current.date(byAdding: .month, value: months, to: self) ?? self
    }
    
    /// Check if date is today
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
    
    /// Check if date is in the future
    var isFuture: Bool {
        self > Date()
    }
}
