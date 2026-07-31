//
//  SettingsView+Actions.swift
//  Spendora
//
//  Capstone 2026 - Mobile Application Development
//  Author: Sheikh Naim
//

/**
 * Main/Core Functions & Purpose:
 * Extension for SettingsView containing data export/import actions (CSV, PDF, JSON backup) and application data reset routines.
 */

import SwiftUI
import SwiftData
import WidgetKit

extension SettingsView {
    
    func shareApp() {
        let appStoreURL = AppConstants.AppInfo.appStoreURL
        let activityVC = UIActivityViewController(
            activityItems: [
                "Check out Spendora! Track your subscriptions easily. \(appStoreURL)"
            ],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
    
    func resetAllData() {
        NotificationService.shared.cancelAll()
        for subscription in subscriptions {
            modelContext.delete(subscription)
        }
        do {
            try modelContext.save()
            let defaults = UserDefaults(suiteName: "group.com.trios2026sn.Spendora")
            defaults?.removeObject(forKey: "totalMonthly")
            defaults?.removeObject(forKey: "nextSubName")
            defaults?.synchronize()
            WidgetCenter.shared.reloadAllTimelines()
            showingResetConfirmation = true
        } catch {
            print("Failed to reset data: \(error)")
        }
    }
    
    func exportCSV() {
        let csvString = ExportService.generateCSVString(subscriptions: subscriptions)
        let tempDir = FileManager.default.temporaryDirectory
        let fileName = "Spendora_Export_\(Date().timeIntervalSince1970).csv"
        let fileURL = tempDir.appendingPathComponent(fileName)
        
        do {
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            shareItems = [fileURL]
            showingShareSheet = true
            showingExportSuccess = true
        } catch {
            print("Error creating CSV file: \(error)")
        }
    }
    
    func exportPDF() {
        guard let fileURL = PDFExportService.generatePDF(subscriptions: subscriptions) else {
            print("Failed to generate PDF")
            return
        }
        shareItems = [fileURL]
        showingShareSheet = true
        showingExportSuccess = true
    }
    
    func exportBackup() {
        guard let fileURL = BackupService.shared.exportBackup(subscriptions: subscriptions) else {
            print("Failed to generate backup")
            return
        }
        shareItems = [fileURL]
        showingShareSheet = true
    }
    
    func importBackup(from url: URL) {
        do {
            let count = try BackupService.shared.importBackup(from: url, modelContext: modelContext)
            showingResetConfirmation = true
            print("Imported \(count) subscriptions")
        } catch {
            print("Restore failed: \(error)")
        }
    }
}
