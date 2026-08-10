//
//  SubscriptionCalendarView.swift
//  Spendora
//

import SwiftUI

// MARK: - SubscriptionCalendarView

/**
 `SubscriptionCalendarView` presents Spendora's interactive subscription billing calendar
 wrapped inside adaptive 3D cards with Spendora Teal brand identity.
 */
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
                        // CARD 1: Calendar Grid Container Card (Spendora Teal Theme)
                        VStack(spacing: 16) {
                            // Month Navigation Header
                            HStack {
                                Button {
                                    withAnimation(.easeInOut(duration: 0.25)) {
                                        selectedDate = calendar.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
                                    }
                                } label: {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(Color(hex: "#00D4AA"))
                                        .padding(8)
                                        .background(Color(hex: "#00D4AA").opacity(0.12))
                                        .clipShape(Circle())
                                }
                                
                                Spacer()
                                
                                Text(selectedDate.formatted(.dateTime.month(.wide).year()))
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundColor(.textPrimary)
                                
                                Spacer()
                                
                                Button {
                                    withAnimation(.easeInOut(duration: 0.25)) {
                                        selectedDate = calendar.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
                                    }
                                } label: {
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(Color(hex: "#00D4AA"))
                                        .padding(8)
                                        .background(Color(hex: "#00D4AA").opacity(0.12))
                                        .clipShape(Circle())
                                }
                            }
                            .padding(.horizontal, 4)
                            
                            // Day Headers (Sun Mon Tue Wed Thu Fri Sat)
                            HStack {
                                ForEach(calendar.shortWeekdaySymbols, id: \.self) { day in
                                    Text(day.uppercased())
                                        .font(.system(size: 11, weight: .bold, design: .rounded))
                                        .foregroundColor(.textSecondary)
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
                        .padding(18)
                        .spendora3DCard(cornerRadius: 22)
                        
                        // CARD 2: Upcoming Billing Schedule Card
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 6) {
                                Image(systemName: "calendar.badge.clock")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(Color(hex: "#00D4AA"))
                                
                                Text("UPCOMING BILLING DAYS")
                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                                    .foregroundColor(.textSecondary)
                                    .tracking(1.2)
                            }
                            
                            if subscriptionsWithBillingDates.isEmpty {
                                HStack {
                                    Spacer()
                                    Text("No upcoming billing charges found.")
                                        .font(.system(size: 13, weight: .medium, design: .rounded))
                                        .foregroundColor(.textSecondary)
                                        .padding(.vertical, 14)
                                    Spacer()
                                }
                            } else {
                                VStack(spacing: 8) {
                                    ForEach(subscriptionsWithBillingDates.prefix(5), id: \.id) { sub in
                                        HStack(spacing: 12) {
                                            Circle()
                                                .fill(sub.categoryEnum.color)
                                                .frame(width: 10, height: 10)
                                            
                                            Text(sub.displayName)
                                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                                .foregroundColor(.textPrimary)
                                            
                                            Spacer()
                                            
                                            Text(CurrencyManager.shared.format(sub.isOneTime ? sub.cost : sub.monthlyCost))
                                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                                .foregroundColor(Color(hex: "#FF6B6B"))
                                            
                                            Text(sub.formattedNextBillingDate)
                                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                                                .foregroundColor(.textSecondary)
                                        }
                                        .padding(12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(colorScheme == .dark ? Color.white.opacity(0.04) : Color.black.opacity(0.025))
                                        )
                                    }
                                }
                            }
                        }
                        .padding(18)
                        .spendora3DCard(cornerRadius: 22)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 36)
                }
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
            .filter { !$0.isOverdue && !$0.isCancelled }
            .sorted { $0.nextBillingDate < $1.nextBillingDate }
    }
    
    private func subscriptionsForDate(_ date: Date) -> [Subscription] {
        subscriptions.filter {
            !$0.isCancelled && calendar.isDate($0.nextBillingDate, inSameDayAs: date)
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
