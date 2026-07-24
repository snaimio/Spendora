//
//  DataSection.swift
//  Spendora
//

import SwiftUI

struct DataSection: View {
    let subscriptions: [Subscription]
    let exportCSV: () -> Void
    let exportPDF: () -> Void
    let exportBackup: () -> Void
    let onRestore: () -> Void
    let onReset: () -> Void
    
    var body: some View {
        Section("Export & Backup") {
            // Export Options - Consolidated
            PremiumSettingsRow(
                icon: "doc.text.fill",
                title: "Export Data",
                subtitle: "CSV (Spreadsheet) or PDF (Report)"
            ) {
                Menu {
                    Button {
                        exportCSV()
                    } label: {
                        Label("CSV (Spreadsheet)", systemImage: "tablecells")
                    }
                    
                    Button {
                        exportPDF()
                    } label: {
                        Label("PDF (Report)", systemImage: "doc.text.fill")
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Backup
            PremiumSettingsRow(
                icon: "arrow.up.doc",
                title: "Backup Data",
                subtitle: "Save JSON backup file"
            ) {
                Button {
                    exportBackup()
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Restore
            PremiumSettingsRow(
                icon: "arrow.down.doc",
                title: "Restore Backup",
                subtitle: "Import from JSON file"
            ) {
                Button {
                    onRestore()
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Reset
            PremiumSettingsRow(
                icon: "trash.fill",
                title: "Reset All Data",
                subtitle: "Delete all subscriptions"
            ) {
                Button(role: .destructive) {
                    onReset()
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .foregroundColor(.red)
        }
    }
}
