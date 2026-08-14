//
//  HomeView+Widget.swift
//  Spendora
//

import SwiftUI
import WidgetKit

// MARK: - HomeView Extension

extension HomeView {
    
    /**
     Synchronizes active subscription calculations, next charge, and currency formatting to iOS Widgets.
     */
    func updateWidgetData() {
        WidgetSyncService.update(subscriptions: subscriptions)
        
        if CloudSyncService.shared.autoSyncEnabled {
            CloudSyncService.shared.syncSubscriptions(subscriptions)
        }
    }
}
