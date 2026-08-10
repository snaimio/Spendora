//
//  SettingsDataManagementSection.swift
//  Spendora
//

import SwiftUI

// MARK: - SettingsDataManagementSection (Golden UX Data Management Section)

struct SettingsDataManagementSection: View {

    // MARK: - Properties

    let exportCSV: () -> Void
    let exportPDF: () -> Void
    let exportBackup: () -> Void
    let importBackup: () -> Void
    let resetData: () -> Void

    // MARK: - Body

    var body: some View {
        Section {
            // Export CSV
            Button(action: exportCSV) {
                PremiumSettingsRow(
                    icon: "square.and.arrow.up",
                    title: "Export to CSV",
                    subtitle: "Download subscription data as CSV spreadsheet"
                )
            }
            .buttonStyle(.plain)
            
            // Export PDF
            Button(action: exportPDF) {
                PremiumSettingsRow(
                    icon: "doc.richtext",
                    title: "Export to PDF",
                    subtitle: "Generate executive annual report"
                )
            }
            .buttonStyle(.plain)
            
            // Backup JSON
            Button(action: exportBackup) {
                PremiumSettingsRow(
                    icon: "arrow.up.doc",
                    title: "Create Backup",
                    subtitle: "Export full app records as JSON"
                )
            }
            .buttonStyle(.plain)
            
            // Restore JSON
            Button(action: importBackup) {
                PremiumSettingsRow(
                    icon: "arrow.down.doc",
                    title: "Restore Backup",
                    subtitle: "Import from encrypted JSON backup"
                )
            }
            .buttonStyle(.plain)
            
            // Danger Row: Reset All Data
            Button(role: .destructive, action: resetData) {
                PremiumSettingsRow(
                    icon: "trash.fill",
                    title: "Reset All Data",
                    subtitle: "Permanently erase all local subscription records",
                    isDestructive: true
                )
            }
            .buttonStyle(.plain)
        } header: {
            Text("DATA & PRIVACY")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(SpendoraTheme.Colors.coralWarm)
        }
    }
}
