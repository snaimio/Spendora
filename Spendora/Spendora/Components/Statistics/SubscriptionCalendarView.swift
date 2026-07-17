//
//  SubscriptionCalendarView.swift
//  Spendora
//

import SwiftUI

struct SubscriptionCalendarView: View {
    let subscriptions: [Subscription]
    @State private var currentMonth = Date()
    @State private var selectedDate: Date?
    
    private let calendar = Calendar.current
    private let daysOfWeek = ["S", "M", "T", "W", "T", "F", "S"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Calendar Card
                    VStack(spacing: 16) {
                        // Month Header
                        HStack {
                            Button {
                                withAnimation {
                                    currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
                                }
                            } label: {
                                Image(systemName: "chevron.left")
                                    .font(.title3)
                                    .foregroundColor(.brandPrimary)
                                    .padding(8)
                                    .background(Color.brandPrimary.opacity(0.1))
                                    .cornerRadius(8)
                            }
                            
                            Spacer()
                            
                            Text(monthYearString)
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Button {
                                withAnimation {
                                    currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
                                }
                            } label: {
                                Image(systemName: "chevron.right")
                                    .font(.title3)
                                    .foregroundColor(.brandPrimary)
                                    .padding(8)
                                    .background(Color.brandPrimary.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Days of Week Header
                        HStack {
                            ForEach(daysOfWeek, id: \.self) { day in
                                Text(day)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Calendar Grid
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
                            ForEach(Array(daysInMonth.enumerated()), id: \.offset) { index, date in
                                if let date = date {
                                    CalendarDayCell(
                                        date: date,
                                        hasSubscription: hasSubscription(on: date),
                                        subscriptionCount: subscriptionCount(on: date),
                                        isToday: calendar.isDateInToday(date),
                                        isSelected: selectedDate == date
                                    )
                                    .onTapGesture {
                                        withAnimation {
                                            if selectedDate == date {
                                                selectedDate = nil
                                            } else {
                                                selectedDate = date
                                            }
                                        }
                                    }
                                } else {
                                    Color.clear
                                        .frame(height: 55)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                    .background(Color(.systemBackground))
                    .cornerRadius(24)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
                    .padding(.horizontal)
                    
                    // Selected Date Subscriptions
                    if let selectedDate = selectedDate {
                        let dueSubscriptions = subscriptionsDue(on: selectedDate)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "calendar.badge.clock")
                                    .foregroundColor(.brandPrimary)
                                Text("Due on \(selectedDate.formatted(date: .abbreviated, time: .omitted))")
                                    .font(.headline)
                                Spacer()
                                Text("\(dueSubscriptions.count) subscription\(dueSubscriptions.count > 1 ? "s" : "")")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Divider()
                            
                            ForEach(dueSubscriptions) { subscription in
                                NavigationLink(destination: SubscriptionDetailView(subscription: subscription)) {
                                    HStack {
                                        Circle()
                                            .fill(categoryColor(subscription.category))
                                            .frame(width: 10, height: 10)
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(subscription.displayName)
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                            
                                            Text(subscription.isYearly ? "Yearly billing" : "Monthly billing")
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .trailing, spacing: 4) {
                                            Text(CurrencyManager.shared.format(subscription.monthlyCost))
                                                .font(.subheadline)
                                                .fontWeight(.semibold)
                                            
                                            if subscription.isUpcoming {
                                                Text("Upcoming")
                                                    .font(.caption2)
                                                    .foregroundColor(.orange)
                                            }
                                        }
                                    }
                                    .padding(.vertical, 8)
                                }
                                .buttonStyle(.plain)
                                
                                if subscription.id != dueSubscriptions.last?.id {
                                    Divider()
                                }
                            }
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(20)
                        .padding(.horizontal)
                    }
                    
                    // Summary Stats
                    if !subscriptions.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Monthly Summary")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    CalendarSummaryCard(
                                        title: "Total Monthly",
                                        value: CurrencyManager.shared.format(subscriptions.reduce(0) { $0 + $1.monthlyCost }),
                                        icon: "dollarsign.circle.fill",
                                        color: .brandPrimary
                                    )
                                    
                                    CalendarSummaryCard(
                                        title: "Active Subs",
                                        value: "\(subscriptions.count)",
                                        icon: "number.circle.fill",
                                        color: .green
                                    )
                                    
                                    let upcomingCount = subscriptions.filter { $0.isUpcoming }.count
                                    CalendarSummaryCard(
                                        title: "Upcoming",
                                        value: "\(upcomingCount)",
                                        icon: "clock.fill",
                                        color: .orange
                                    )
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                    }
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }
    
    private var daysInMonth: [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start) else {
            return []
        }
        
        let monthEnd = monthInterval.end
        var dates: [Date?] = []
        var currentDate = monthFirstWeek.start
        
        while currentDate < monthEnd || calendar.component(.weekday, from: currentDate) != 1 {
            if calendar.isDate(currentDate, equalTo: monthInterval.start, toGranularity: .month) {
                dates.append(currentDate)
            } else {
                dates.append(nil)
            }
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        while dates.count % 7 != 0 {
            dates.append(nil)
        }
        
        return dates
    }
    
    private func hasSubscription(on date: Date) -> Bool {
        subscriptions.contains { calendar.isDate($0.nextBillingDate, inSameDayAs: date) }
    }
    
    private func subscriptionCount(on date: Date) -> Int {
        subscriptions.filter { calendar.isDate($0.nextBillingDate, inSameDayAs: date) }.count
    }
    
    private func subscriptionsDue(on date: Date) -> [Subscription] {
        subscriptions.filter { calendar.isDate($0.nextBillingDate, inSameDayAs: date) }
    }
    
    private func categoryColor(_ category: String) -> Color {
        switch category {
        case "Entertainment": return .categoryEntertainment
        case "Productivity": return .categoryProductivity
        case "Health & Fitness": return .categoryHealth
        case "Shopping": return .categoryShopping
        case "Food & Dining": return .categoryFood
        case "Education": return .categoryEducation
        default: return .categoryOther
        }
    }
}

// MARK: - Calendar Day Cell
struct CalendarDayCell: View {
    let date: Date
    let hasSubscription: Bool
    let subscriptionCount: Int
    let isToday: Bool
    let isSelected: Bool
    
    private let calendar = Calendar.current
    
    var body: some View {
        VStack(spacing: 6) {
            Text("\(calendar.component(.day, from: date))")
                .font(.system(size: 16, weight: fontWeight))
                .foregroundColor(textColor)
            
            if hasSubscription {
                if subscriptionCount > 1 {
                    Text("\(subscriptionCount)")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.orange)
                } else {
                    Circle()
                        .fill(circleColor)
                        .frame(width: 6, height: 6)
                }
            } else {
                Circle()
                    .fill(Color.clear)
                    .frame(width: 6, height: 6)
            }
        }
        .frame(height: 55)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? Color.brandPrimary.opacity(0.15) : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isToday ? Color.brandPrimary : Color.clear, lineWidth: 1.5)
        )
    }
    
    private var fontWeight: Font.Weight {
        if isToday { return .bold }
        if hasSubscription { return .semibold }
        return .regular
    }
    
    private var textColor: Color {
        if isSelected {
            return .brandPrimary
        } else if isToday {
            return .brandPrimary
        } else {
            return .primary
        }
    }
    
    private var circleColor: Color {
        if subscriptionCount > 1 {
            return .orange
        }
        return .brandPrimary
    }
}

// MARK: - Calendar Summary Card
struct CalendarSummaryCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.headline)
                    .fontWeight(.bold)
            }
        }
        .padding()
        .frame(width: 140, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 5, x: 0, y: 2)
    }
}
