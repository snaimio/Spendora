//
//  SettingsView+Actions.swift
//

/**
 * Main/Core Functions & Purpose:
 * Extension for SettingsView containing data export/import actions (CSV, PDF, JSON backup) and application data reset routines.
 */

import SwiftUI
import SwiftData
import WidgetKit


// MARK: - SettingsView Extension

/**
 Extension on `SettingsView` providing utility methods and helpers.
 */
extension SettingsView {
    

    /**
     Executes `shareApp` for component logic.
     
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
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
    

    /**
     Executes `resetAllData` for component logic.
     
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
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
    

    /**
     Executes `exportCSV` for component logic.
     
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
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
    

    /**
     Executes `exportPDF` for component logic.
     
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func exportPDF() {
        guard let fileURL = PDFExportService.generatePDF(subscriptions: subscriptions) else {
            print("Failed to generate PDF")
            return
        }
        shareItems = [fileURL]
        showingShareSheet = true
        showingExportSuccess = true
    }
    

    /**
     Executes `exportBackup` for component logic.
     
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func exportBackup() {
        guard let fileURL = BackupService.shared.exportBackup(subscriptions: subscriptions) else {
            print("Failed to generate backup")
            return
        }
        shareItems = [fileURL]
        showingShareSheet = true
    }
    

    /**
     Executes `importBackup` for component logic.
     
     - Parameter url: Value passed to `importBackup`.
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
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
