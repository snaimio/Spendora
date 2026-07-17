//
//  SubscriptionCalendarView.swift
//  Spendora
//

import SwiftUI

struct SubscriptionCalendarView: View {
    let subscriptions: [Subscription]
    @State private var selectedDate = Date()
    @State private var selectedSubscription: Subscription?
    
    private let calendar = Calendar.current
    private let daysInWeek = 7
    
    var body: some View {
        NavigationStack {
            VStack {
                // Month Navigation
                HStack {
                    Button {
                        withAnimation {
                            selectedDate = calendar.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.brandPrimary)
                    }
                    
                    Spacer()
                    
                    Text(selectedDate.formatted(.dateTime.month(.wide).year()))
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button {
                        withAnimation {
                            selectedDate = calendar.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
                        }
                    } label: {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.brandPrimary)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                // Day Headers
                HStack {
                    ForEach(calendar.weekdaySymbols, id: \.self) { day in
                        Text(day.prefix(3))
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)
                
                // Calendar Grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: daysInWeek), spacing: 8) {
                    ForEach(daysInMonth(date: selectedDate), id: \.self) { date in
                        CalendarDayView(
                            date: date,
                            isToday: calendar.isDateInToday(date),
                            isInMonth: calendar.isDate(date, equalTo: selectedDate, toGranularity: .month),
                            subscriptions: subscriptionsForDate(date)
                        )
                        .onTapGesture {
                            if let sub = subscriptionsForDate(date).first {
                                selectedSubscription = sub
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                // Legend
                VStack(alignment: .leading, spacing: 8) {
                    Text("Billing Days")
                        .font(.headline)
                        .padding(.top, 8)
                    
                    if subscriptionsWithBillingDates.isEmpty {
                        Text("No upcoming billing dates")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(subscriptionsWithBillingDates.prefix(5), id: \.id) { sub in
                            HStack {
                                Circle()
                                    .fill(Color(hex: sub.colorHex ?? "#6C63FF"))
                                    .frame(width: 8, height: 8)
                                
                                Text(sub.displayName)
                                    .font(.subheadline)
                                
                                Spacer()
                                
                                Text(sub.formattedNextBillingDate)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        if subscriptionsWithBillingDates.count > 5 {
                            Text("+ \(subscriptionsWithBillingDates.count - 5) more")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(16)
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.large)
            .sheet(item: $selectedSubscription) { subscription in
                SubscriptionDetailView(subscription: subscription)
            }
        }
    }
    
    private var subscriptionsWithBillingDates: [Subscription] {
        subscriptions
            .filter { !$0.isOverdue }
            .sorted { $0.nextBillingDate < $1.nextBillingDate }
    }
    
    private func subscriptionsForDate(_ date: Date) -> [Subscription] {
        subscriptions.filter {
            calendar.isDate($0.nextBillingDate, inSameDayAs: date)
        }
    }
    
    private func daysInMonth(date: Date) -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: date) else { return [] }
        guard let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start) else { return [] }
        
        let startDate = monthFirstWeek.start
        let endDate = calendar.date(byAdding: .day, value: 41, to: startDate) ?? Date()
        
        var dates: [Date] = []
        var currentDate = startDate
        
        while currentDate < endDate {
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return dates
    }
}

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

#Preview {
    SubscriptionCalendarView(subscriptions: [])
}
