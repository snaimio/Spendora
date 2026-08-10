//
//  SubscriptionCalendarView.swift
//  Spendora
//

import SwiftUI

// MARK: - SubscriptionCalendarView (60-30-10 Coral Fire Calendar)

struct SubscriptionCalendarView: View {

    // MARK: - Properties

    let subscriptions: [Subscription]
    @State private var selectedDate = Date()
    @State private var selectedSubscription: Subscription?
    @Environment(\.colorScheme) private var colorScheme
    
    private let calendar = Calendar.current
    private let daysInWeek = 7

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                SpendoraBrandBackgroundView()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // CARD 1: Calendar Grid Container Card (20pt radius, coral shadow)
                        VStack(spacing: 16) {
                            // Month Navigation Header
                            HStack {
                                Button {
                                    withAnimation(.easeInOut(duration: 0.25)) {
                                        selectedDate = calendar.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
                                    }
                                } label: {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(SpendoraTheme.Colors.coral)
                                        .padding(8)
                                        .background(SpendoraTheme.Colors.coralTint)
                                        .clipShape(Circle())
                                }
                                
                                Spacer()
                                
                                Text(selectedDate.formatted(.dateTime.month(.wide).year()))
                                    .font(SpendoraTheme.Typography.headline)
                                    .foregroundColor(SpendoraTheme.Colors.textPrimary)
                                
                                Spacer()
                                
                                Button {
                                    withAnimation(.easeInOut(duration: 0.25)) {
                                        selectedDate = calendar.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
                                    }
                                } label: {
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(SpendoraTheme.Colors.coral)
                                        .padding(8)
                                        .background(SpendoraTheme.Colors.coralTint)
                                        .clipShape(Circle())
                                }
                            }
                            .padding(.horizontal, 4)
                            
                            // Day Headers
                            HStack {
                                ForEach(calendar.shortWeekdaySymbols, id: \.self) { day in
                                    Text(day.uppercased())
                                        .font(SpendoraTheme.Typography.label)
                                        .foregroundColor(SpendoraTheme.Colors.textSecondary)
                                        .frame(maxWidth: .infinity)
                                }
                            }
                            .padding(.vertical, 4)
                            
                            // Calendar Grid
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: daysInWeek), spacing: 10) {
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
                        }
                        .padding(16)
                        .spendoraCard(cornerRadius: SpendoraTheme.Radius.hero)
                        
                        // CARD 2: Upcoming Billing Schedule List
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 6) {
                                Image(systemName: "calendar.badge.clock")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(SpendoraTheme.Colors.coral)
                                
                                Text("UPCOMING BILLING DAYS")
                                    .font(SpendoraTheme.Typography.label)
                                    .foregroundColor(SpendoraTheme.Colors.coralWarm)
                                    .tracking(1.2)
                            }
                            .padding(.horizontal, 4)
                            
                            if subscriptionsWithBillingDates.isEmpty {
                                HStack {
                                    Spacer()
                                    Text("No upcoming billing charges found.")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(SpendoraTheme.Colors.textSecondary)
                                        .padding(.vertical, 14)
                                    Spacer()
                                }
                            } else {
                                VStack(spacing: 10) {
                                    ForEach(subscriptionsWithBillingDates.prefix(5), id: \.id) { sub in
                                        HStack(spacing: 12) {
                                            // Left 3pt coral accent bar
                                            RoundedRectangle(cornerRadius: 1.5)
                                                .fill(SpendoraTheme.Colors.coral)
                                                .frame(width: 3, height: 28)
                                            
                                            // Service name bold
                                            Text(sub.displayName)
                                                .font(.system(size: 15, weight: .bold))
                                                .foregroundColor(SpendoraTheme.Colors.textPrimary)
                                            
                                            Spacer()
                                            
                                            // Amount in coral #FF6B6B
                                            Text(CurrencyManager.shared.format(sub.isOneTime ? sub.cost : sub.monthlyCost))
                                                .font(Font.system(size: 15, weight: .bold).monospacedDigit())
                                                .foregroundColor(SpendoraTheme.Colors.coral)
                                            
                                            // Date in #8A8A9A
                                            Text(sub.formattedNextBillingDate)
                                                .font(SpendoraTheme.Typography.caption)
                                                .foregroundColor(SpendoraTheme.Colors.textSecondary)
                                        }
                                        .padding(14)
                                        .spendoraCard(cornerRadius: 14)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.large)
            .sheet(item: $selectedSubscription) { sub in
                SubscriptionDetailView(subscription: sub)
            }
        }
    }
    
    // MARK: - Private Helpers

    private var subscriptionsWithBillingDates: [Subscription] {
        subscriptions
            .filter { !$0.isCancelled }
            .sorted { $0.nextBillingDate < $1.nextBillingDate }
    }

    private func subscriptionsForDate(_ date: Date) -> [Subscription] {
        subscriptions.filter { sub in
            guard !sub.isCancelled else { return false }
            return calendar.isDate(sub.nextBillingDate, equalTo: date, toGranularity: .day)
        }
    }

    private func daysInMonth(date: Date) -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: date),
              let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: monthInterval.start)),
              let monthRange = calendar.range(of: .day, in: .month, for: date)
        else { return [] }
        
        let firstWeekday = calendar.component(.weekday, from: firstDay)
        let leadingDays = (firstWeekday - calendar.firstWeekday + 7) % 7
        
        var days: [Date] = []
        
        for dayOffset in -leadingDays..<monthRange.count {
            if let date = calendar.date(byAdding: .day, value: dayOffset, to: firstDay) {
                days.append(date)
            }
        }
        
        let remaining = (7 - (days.count % 7)) % 7
        if let lastDay = days.last {
            for dayOffset in 1...max(0, remaining) {
                if let date = calendar.date(byAdding: .day, value: dayOffset, to: lastDay) {
                    days.append(date)
                }
            }
        }
        
        return days
    }
}
