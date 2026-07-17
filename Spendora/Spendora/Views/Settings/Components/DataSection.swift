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
        Section("Data") {
            PremiumSettingsRow(
                icon: "tablecells",
                title: "Export CSV",
                subtitle: "Spreadsheet format"
            ) {
                Button {
                    exportCSV()
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            PremiumSettingsRow(
                icon: "doc.text.fill",
                title: "Export PDF Report",
                subtitle: "Professional report"
            ) {
                Button {
                    exportPDF()
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            PremiumSettingsRow(
                icon: "arrow.up.doc",
                title: "Backup Data",
                subtitle: "JSON backup file"
            ) {
                Button {
                    exportBackup()
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
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
