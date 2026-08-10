//
//  SubscriptionCalendarView.swift
//  Spendora
//

import SwiftUI

// MARK: - SubscriptionCalendarView (Apple Native Calendar Screen)

struct SubscriptionCalendarView: View {

    // MARK: - Properties

    let subscriptions: [Subscription]
    @State private var selectedDate = Date()
    @State private var selectedSubscription: Subscription?
    
    private let calendar = Calendar.current
    private let daysInWeek = 7
    let generator = UIImpactFeedbackGenerator(style: .medium)

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: SpendoraTheme.sectionSpacing) {
                    // CALENDAR CARD: 12pt Radius, secondarySystemBackground, 16pt Padding
                    VStack(spacing: 16) {
                        // Month Navigation Header
                        HStack {
                            Button {
                                generator.impactOccurred()
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    selectedDate = calendar.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
                                }
                            } label: {
                                Image(systemName: "chevron.left")
                                    .font(.headline)
                                    .foregroundColor(SpendoraTheme.accent)
                            }
                            
                            Spacer()
                            
                            Text(selectedDate.formatted(.dateTime.month(.wide).year()))
                                .font(.headline.weight(.semibold))
                                .foregroundColor(Color(.label))
                            
                            Spacer()
                            
                            Button {
                                generator.impactOccurred()
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    selectedDate = calendar.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
                                }
                            } label: {
                                Image(systemName: "chevron.right")
                                    .font(.headline)
                                    .foregroundColor(SpendoraTheme.accent)
                            }
                        }
                        .padding(.horizontal, 4)
                        
                        // Day Headers: SUN MON TUE WED THU FRI SAT
                        HStack {
                            ForEach(["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"], id: \.self) { day in
                                Text(day)
                                    .font(.caption2.weight(.semibold))
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        
                        // Day Grid: 7 Columns, 44x44pt Minimum
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: daysInWeek), spacing: 6) {
                            ForEach(daysInMonth(date: selectedDate), id: \.self) { date in
                                let isToday = calendar.isDateInToday(date)
                                let isInMonth = calendar.isDate(date, equalTo: selectedDate, toGranularity: .month)
                                let daySubs = subscriptionsForDate(date)
                                
                                CalendarDayView(
                                    date: date,
                                    isToday: isToday,
                                    isInMonth: isInMonth,
                                    subscriptions: daySubs
                                )
                                .frame(width: 44, height: 44)
                                .onTapGesture {
                                    if let sub = daySubs.first {
                                        generator.impactOccurred()
                                        selectedSubscription = sub
                                    }
                                }
                            }
                        }
                    }
                    .padding(SpendoraTheme.cardPadding)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: SpendoraTheme.cardRadius, style: .continuous))
                    
                    // UPCOMING BILLING SECTION: LazyVStack(spacing: 8)
                    VStack(alignment: .leading, spacing: 10) {
                        Text("UPCOMING BILLING DAYS")
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.secondary)
                            .textCase(.uppercase)
                            .padding(.horizontal, 4)
                        
                        if subscriptionsWithBillingDates.isEmpty {
                            ContentUnavailableView(
                                "All Clear This Month",
                                systemImage: "calendar.badge.checkmark",
                                description: Text("No upcoming subscription renewals found")
                            )
                            .padding(.vertical, 20)
                        } else {
                            LazyVStack(spacing: 8) {
                                ForEach(subscriptionsWithBillingDates.prefix(5), id: \.id) { sub in
                                    HStack(spacing: 12) {
                                        // Left Accent Bar (3pt Width)
                                        Rectangle()
                                            .fill(SpendoraTheme.accent)
                                            .frame(width: SpendoraTheme.accentBarWidth)
                                            .clipShape(Capsule())
                                        
                                        // Icon
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                .fill(sub.categoryEnum.color.opacity(0.15))
                                                .frame(width: 36, height: 36)
                                            
                                            Image(systemName: UniqueSubscriptionThemeHelper.resolveIcon(for: sub))
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(sub.categoryEnum.color)
                                        }
                                        
                                        // Name & Date
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(sub.displayName)
                                                .font(.system(size: 15, weight: .semibold))
                                                .foregroundColor(Color(.label))
                                            
                                            Text(sub.formattedNextBillingDate)
                                                .font(.caption)
                                                .foregroundColor(Color(.secondaryLabel))
                                        }
                                        
                                        Spacer()
                                        
                                        // Amount in Darker Accent (#1A8A7F)
                                        Text(CurrencyManager.shared.format(sub.isOneTime ? sub.cost : sub.monthlyCost))
                                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                                            .monospacedDigit()
                                            .foregroundColor(SpendoraTheme.accentText)
                                    }
                                    .padding(12)
                                    .background(Color(.secondarySystemBackground))
                                    .clipShape(RoundedRectangle(cornerRadius: SpendoraTheme.cardRadius, style: .continuous))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: SpendoraTheme.cardRadius, style: .continuous)
                                            .stroke(Color(.separator), lineWidth: 0.5)
                                    )
                                    .onTapGesture {
                                        generator.impactOccurred()
                                        selectedSubscription = sub
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, SpendoraTheme.cardPadding)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.large)
            .sheet(item: $selectedSubscription) { sub in
                SubscriptionDetailView(subscription: sub)
            }
        }
    }
    
    // MARK: - Helpers

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
        if remaining > 0, let lastDay = days.last {
            for dayOffset in 1...remaining {
                if let date = calendar.date(byAdding: .day, value: dayOffset, to: lastDay) {
                    days.append(date)
                }
            }
        }
        return days
    }
}
