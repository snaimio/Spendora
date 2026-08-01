//
//  SettingsDataManagementSection.swift
//

/**
 * Main/Core Functions & Purpose:
 * SettingsDataManagementSection component containing CSV/PDF export, JSON backup, file import, and master data reset triggers.
 */

import SwiftUI


// MARK: - SettingsDataManagementSection

/**
 `SettingsDataManagementSection` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for settingsdatamanagementsection handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `SettingsDataManagementSection` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct SettingsDataManagementSection: View {

    // MARK: - Properties

    let exportCSV: () -> Void  // exportCSV property
    let exportPDF: () -> Void  // exportPDF property
    let exportBackup: () -> Void  // exportBackup property
    let importBackup: () -> Void  // importBackup property
    let resetData: () -> Void  // resetData property
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        Section("Data & Privacy") {
            // Export CSV
            Button(action: exportCSV) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.brandPrimary)
                        .frame(width: 28)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Export to CSV")
                            .font(.system(.body, design: .rounded))
                        Text("Download subscription data as CSV")
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Export PDF
            Button(action: exportPDF) {
                HStack {
                    Image(systemName: "doc.richtext")
                        .foregroundColor(.brandPrimary)
                        .frame(width: 28)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Export to PDF")
                            .font(.system(.body, design: .rounded))
                        Text("Generate report document")
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Backup JSON
            Button(action: exportBackup) {
                HStack {
                    Image(systemName: "arrow.up.doc")
                        .foregroundColor(.brandPrimary)
                        .frame(width: 28)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Create Backup")
                            .font(.system(.body, design: .rounded))
                        Text("Export full app data as JSON")
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Restore JSON
            Button(action: importBackup) {
                HStack {
                    Image(systemName: "arrow.down.doc")
                        .foregroundColor(.brandPrimary)
                        .frame(width: 28)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Restore Backup")
                            .font(.system(.body, design: .rounded))
                        Text("Import from JSON file")
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Reset
            Button(role: .destructive, action: resetData) {
                HStack {
                    Image(systemName: "trash.fill")
                        .foregroundColor(.red)
                        .frame(width: 28)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Reset All Data")
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(.red)
                        Text("Delete all subscriptions")
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
