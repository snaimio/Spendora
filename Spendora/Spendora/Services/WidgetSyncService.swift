//
//  WidgetSyncService.swift
//  Spendora
//
//  Created by Sheikh Naim on 2026-06-19.
//

import Foundation
import WidgetKit
import SwiftUI

class WidgetSyncService {

    // MARK: - Update Widget Data

    static func update(subscriptions: [Subscription]) {
        // Calculate total monthly spending
        let totalMonthly = subscriptions.reduce(0) {
            $0 + $1.monthlyCost
        }

        // Find next upcoming subscription
        let nextSub = subscriptions
            .filter { !$0.isOverdue }
            .sorted { $0.nextBillingDate < $1.nextBillingDate }
            .first

        // Save to shared UserDefaults (App Group)
        let defaults = UserDefaults(
            suiteName: "group.com.spendora.app"
        )

        defaults?.set(
            totalMonthly,
            forKey: "totalMonthly"
        )

        defaults?.set(
            nextSub?.displayName ?? "None",
            forKey: "nextSubName"
        )

        defaults?.set(
            nextSub?.nextBillingDate.timeIntervalSince1970 ?? 0,
            forKey: "nextSubDate"
        )

        // Reload widget timelines
        WidgetCenter.shared.reloadAllTimelines()

        print(
            "✅ Widget data updated - Total: $\(totalMonthly), Next: \(nextSub?.displayName ?? "None")"
        )
    }

    // MARK: - Update Widget with Specific Data

    static func update(
        totalMonthly: Double,
        nextSubName: String,
        nextSubDate: Date
    ) {
        let defaults = UserDefaults(
            suiteName: "group.com.spendora.app"
        )

        defaults?.set(
            totalMonthly,
            forKey: "totalMonthly"
        )

        defaults?.set(
            nextSubName,
            forKey: "nextSubName"
        )

        defaults?.set(
            nextSubDate.timeIntervalSince1970,
            forKey: "nextSubDate"
        )

        WidgetCenter.shared.reloadAllTimelines()

        print(
            "✅ Widget data updated manually - Total: $\(totalMonthly), Next: \(nextSubName)"
        )
    }

    // MARK: - Clear Widget Data

    static func clearWidgetData() {
        let defaults = UserDefaults(
            suiteName: "group.com.spendora.app"
        )

        defaults?.removeObject(forKey: "totalMonthly")
        defaults?.removeObject(forKey: "nextSubName")
        defaults?.removeObject(forKey: "nextSubDate")

        WidgetCenter.shared.reloadAllTimelines()

        print("🗑️ Widget data cleared")
    }
}
