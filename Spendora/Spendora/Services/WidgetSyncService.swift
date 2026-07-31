/**
 * Main/Core Functions & Purpose:
 * WidgetSyncService class syncing live subscription statistics to iOS Home Screen Widgets.
 * Writes current monthly total, next upcoming charge name, cost, and due date into shared App Group UserDefaults (`group.com.trios2026sn.Spendora`),
 * and forces WidgetCenter to reload all Widget timelines immediately.
 */

import Foundation
import WidgetKit
import SwiftUI

class WidgetSyncService {

    /// Calculates current subscription totals and syncs payload to App Group UserDefaults
    static func update(subscriptions: [Subscription]) {
        let activeSubs = subscriptions.filter { !$0.isCancelled }
        
        let totalMonthly = activeSubs.reduce(0) { $0 + $1.monthlyCost }
        let totalYearly = activeSubs.reduce(0) { $0 + $1.yearlyCost }

        let nextSub = activeSubs
            .filter { !$0.isOverdue }
            .sorted { $0.nextBillingDate < $1.nextBillingDate }
            .first

        let defaults = UserDefaults(suiteName: "group.com.trios2026sn.Spendora")

        defaults?.set(totalMonthly, forKey: "totalMonthly")
        defaults?.set(totalYearly, forKey: "totalYearly")
        defaults?.set(activeSubs.count, forKey: "activeCount")
        defaults?.set(nextSub?.displayName ?? "None", forKey: "nextSubName")
        defaults?.set(nextSub?.monthlyCost ?? 0, forKey: "nextSubCost")
        defaults?.set(nextSub?.nextBillingDate.timeIntervalSince1970 ?? 0, forKey: "nextSubDate")
        defaults?.set(CurrencyManager.shared.currentCurrency.symbol, forKey: "currencySymbol")

        WidgetCenter.shared.reloadAllTimelines()

        print("✅ Widget data updated - Total: \(totalMonthly), Next: \(nextSub?.displayName ?? "None")")
    }

    static func update(
        totalMonthly: Double,
        nextSubName: String,
        nextSubDate: Date
    ) {
        let defaults = UserDefaults(suiteName: "group.com.trios2026sn.Spendora")

        defaults?.set(totalMonthly, forKey: "totalMonthly")
        defaults?.set(nextSubName, forKey: "nextSubName")
        defaults?.set(nextSubDate.timeIntervalSince1970, forKey: "nextSubDate")

        WidgetCenter.shared.reloadAllTimelines()

        print("✅ Widget data updated manually - Total: \(totalMonthly), Next: \(nextSubName)")
    }

    static func clearWidgetData() {
        let defaults = UserDefaults(suiteName: "group.com.trios2026sn.Spendora")

        defaults?.removeObject(forKey: "totalMonthly")
        defaults?.removeObject(forKey: "totalYearly")
        defaults?.removeObject(forKey: "activeCount")
        defaults?.removeObject(forKey: "nextSubName")
        defaults?.removeObject(forKey: "nextSubCost")
        defaults?.removeObject(forKey: "nextSubDate")
        defaults?.removeObject(forKey: "currencySymbol")

        WidgetCenter.shared.reloadAllTimelines()

        print("🗑️ Widget data cleared")
    }
}
