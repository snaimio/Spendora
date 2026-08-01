//
//  DataSection.swift
//

import SwiftUI


// MARK: - DataSection

/**
 `DataSection` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for datasection handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `DataSection` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct DataSection: View {

    // MARK: - Properties

    let subscriptions: [Subscription]  // subscriptions property
    let exportCSV: () -> Void  // exportCSV property
    let exportPDF: () -> Void  // exportPDF property
    let exportBackup: () -> Void  // exportBackup property
    let onRestore: () -> Void  // onRestore property
    let onReset: () -> Void  // onReset property
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
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
