//
//  SubscriptionCalendarView.swift
//  Spendora
//

import SwiftUI

// MARK: - SubscriptionCalendarView (Golden UX Interactive Calendar Screen)

struct SubscriptionCalendarView: View {

    // MARK: - Properties

    let subscriptions: [Subscription]
    @State private var selectedDate = Date()
    @State private var selectedSubscription: Subscription?
    @Environment(\.colorScheme) private var colorScheme
    
    private let calendar = Calendar.current
    private let daysInWeek = 7
    let generator = UIImpactFeedbackGenerator(style: .medium)

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                SpendoraBrandBackgroundView()
                
                ScrollView {
                    VStack(spacing: SpendoraTheme.Spacing.xxl) {
                        // CALENDAR CARD (Full width, 20pt radius, coral shadow)
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
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(SpendoraTheme.Colors.coral)
                                        .frame(width: 36, height: 36)
                                        .background(SpendoraTheme.Colors.coralTint)
                                        .clipShape(Circle())
                                }
                                
                                Spacer()
                                
                                // Month/year header: 20pt semibold charcoal centered
                                Text(selectedDate.formatted(.dateTime.month(.wide).year()))
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(SpendoraTheme.Colors.textPrimary)
                                
                                Spacer()
                                
                                Button {
                                    generator.impactOccurred()
                                    withAnimation(.easeInOut(duration: 0.25)) {
                                        selectedDate = calendar.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
                                    }
                                } label: {
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(SpendoraTheme.Colors.coral)
                                        .frame(width: 36, height: 36)
                                        .background(SpendoraTheme.Colors.coralTint)
                                        .clipShape(Circle())
                                }
                            }
                            .padding(.horizontal, 4)
                            
                            // Day Headers: 11pt semibold uppercase secondary (SUN MON TUE WED THU FRI SAT)
                            HStack {
                                ForEach(["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"], id: \.self) { day in
                                    Text(day)
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundColor(SpendoraTheme.Colors.textSecondary)
                                        .frame(maxWidth: .infinity)
                                }
                            }
                            .padding(.vertical, 4)
                            
                            // Calendar Grid: 44x44pt touch cells
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: daysInWeek), spacing: 8) {
                                ForEach(daysInMonth(date: selectedDate), id: \.self) { date in
                                    let isToday = calendar.isDateInToday(date)
                                    let isInMonth = calendar.isDate(date, equalTo: selectedDate, toGranularity: .month)
                                    let daySubs = subscriptionsForDate(date)
                                    
                                    CalendarDayCell(
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
                        .padding(SpendoraTheme.Spacing.lg)
                        .spendoraCard(cornerRadius: SpendoraTheme.Radius.hero)
                        
                        // UPCOMING BILLING DAYS SECTION
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 6) {
                                Image(systemName: "calendar.badge.clock")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(SpendoraTheme.Colors.coral)
                                
                                Text("UPCOMING BILLING DAYS")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(SpendoraTheme.Colors.coralWarm)
                                    .tracking(1.2)
                            }
                            .padding(.horizontal, 4)
                            
                            if subscriptionsWithBillingDates.isEmpty {
                                HStack(spacing: 12) {
                                    Image(systemName: "calendar.badge.checkmark")
                                        .font(.system(size: 28))
                                        .foregroundColor(SpendoraTheme.Colors.success)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("All clear this month")
                                            .font(.system(size: 15, weight: .bold))
                                            .foregroundColor(SpendoraTheme.Colors.textPrimary)
                                        Text("No upcoming subscription renewals found.")
                                            .font(.system(size: 13))
                                            .foregroundColor(SpendoraTheme.Colors.textSecondary)
                                    }
                                }
                                .padding(16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .spendoraCard(cornerRadius: 16)
                            } else {
                                VStack(spacing: 10) {
                                    ForEach(subscriptionsWithBillingDates.prefix(5), id: \.id) { sub in
                                        HStack(spacing: 10) {
                                            // Left 3pt coral accent bar full height
                                            RoundedRectangle(cornerRadius: 1.5)
                                                .fill(SpendoraTheme.Colors.coral)
                                                .frame(width: 3, height: 44)
                                            
                                            // Service icon 40x40pt 12pt radius
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                    .fill(sub.categoryEnum.color.opacity(0.15))
                                                    .frame(width: 40, height: 40)
                                                
                                                Image(systemName: UniqueSubscriptionThemeHelper.resolveIcon(for: sub))
                                                    .font(.system(size: 17, weight: .semibold))
                                                    .foregroundColor(sub.categoryEnum.color)
                                            }
                                            
                                            // Service name 16pt semibold charcoal & date 13pt secondary
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(sub.displayName)
                                                    .font(.system(size: 16, weight: .semibold))
                                                    .foregroundColor(SpendoraTheme.Colors.textPrimary)
                                                    .lineLimit(1)
                                                
                                                HStack(spacing: 6) {
                                                    Text(sub.formattedNextBillingDate)
                                                        .font(.system(size: 13, weight: .regular))
                                                        .foregroundColor(SpendoraTheme.Colors.textSecondary)
                                                    
                                                    CountdownChip(daysRemaining: sub.daysUntilBilling, isCancelled: sub.isCancelled)
                                                }
                                            }
                                            
                                            Spacer()
                                            
                                            // Amount right aligned 16pt semibold coral monospaced
                                            Text(CurrencyManager.shared.format(sub.isOneTime ? sub.cost : sub.monthlyCost))
                                                .font(Font.system(size: 16, weight: .semibold, design: .default).monospacedDigit())
                                                .foregroundColor(SpendoraTheme.Colors.coral)
                                        }
                                        .padding(14)
                                        .spendoraCard(cornerRadius: 16)
                                        .pressableCard()
                                        .onTapGesture {
                                            generator.impactOccurred()
                                            selectedSubscription = sub
                                        }
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

// MARK: - CalendarDayCell (36x36pt Indicators within 44x44 Touch Target)

struct CalendarDayCell: View {
    let date: Date
    let isToday: Bool
    let isInMonth: Bool
    let subscriptions: [Subscription]

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
    }
}
