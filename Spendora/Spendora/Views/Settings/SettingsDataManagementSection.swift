//
//  SettingsDataManagementSection.swift
//  Spendora
//
//  Capstone 2026 - Mobile Application Development
//  Author: Sheikh Naim
//

/**
 * Main/Core Functions & Purpose:
 * SettingsDataManagementSection component containing CSV/PDF export, JSON backup, file import, and master data reset triggers.
 */

import SwiftUI

struct SettingsDataManagementSection: View {
    let exportCSV: () -> Void
    let exportPDF: () -> Void
    let exportBackup: () -> Void
    let importBackup: () -> Void
    let resetData: () -> Void
    
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
