/**
 * Main/Core Functions & Purpose:
 * Extension for HomeView providing updateWidgetData method for App Group shared storage and timeline refresh.
 */

import SwiftUI
import WidgetKit

extension HomeView {
    
    func updateWidgetData() {
        let total = subscriptions.reduce(0) { $0 + $1.monthlyCost }
        let next = subscriptions
            .filter { !$0.isOverdue }
            .sorted { $0.nextBillingDate < $1.nextBillingDate }
            .first
        
        guard let defaults = UserDefaults(suiteName: "group.com.trios2026sn.Spendora") else {
            return
        }
        
        defaults.set(total, forKey: "totalMonthly")
        defaults.set(next?.displayName ?? "None", forKey: "nextSubName")
        defaults.set(next?.nextBillingDate.timeIntervalSince1970 ?? 0, forKey: "nextSubDate")
        defaults.set(next?.monthlyCost ?? 0.0, forKey: "nextSubCost")
        
        WidgetCenter.shared.reloadAllTimelines()
        
        if CloudSyncService.shared.autoSyncEnabled {
            CloudSyncService.shared.syncSubscriptions(subscriptions)
        }
    }
}
