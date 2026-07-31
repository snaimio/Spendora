//
//  CloudSyncView.swift
//  Spendora
//
//  Capstone 2026 - Mobile Application Development
//  Author: Sheikh Naim
//

/**
 * Main/Core Functions & Purpose:
 * CloudSyncView card component embedded in Settings.
 * Provides controls for manual iCloud synchronization, automatic cloud sync toggling,
 * and restoring subscription records from Apple NSUbiquitousKeyValueStore.
 */

import SwiftUI
import SwiftData

struct CloudSyncView: View {
    @Query private var subscriptions: [Subscription]
    @Environment(\.modelContext) private var modelContext
    @StateObject private var cloudService = CloudSyncService.shared
    
    @State private var showingRestoreAlert = false
    @State private var restoreMessage = ""
    @State private var showingRestoreResult = false
    
    private let generator = UIImpactFeedbackGenerator(style: .medium)

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Header
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.brandPrimary.opacity(0.12))
                        .frame(width: 40, height: 40)
                    Image(systemName: "icloud.fill")
                        .foregroundColor(.brandPrimary)
                        .font(.title3)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("iCloud Backup & Sync")
                        .font(.system(.headline, design: .rounded))
                        .foregroundColor(.textPrimary)
                    
                    if let lastSync = cloudService.lastSyncDate {
                        Text("Last synced: \(lastSync.formatted(date: .abbreviated, time: .shortened))")
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.textSecondary)
                    } else {
                        Text("Never synced")
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.textSecondary)
                    }
                }

                Spacer()

                if cloudService.isSyncing {
                    ProgressView()
                        .controlSize(.small)
                } else {
                    switch cloudService.syncStatus {
                    case .success:
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.title3)
                    case .failed:
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundColor(.red)
                            .font(.title3)
                    default:
                        EmptyView()
                    }
                }
            }

            // Auto Sync Toggle
            Toggle(isOn: $cloudService.autoSyncEnabled) {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.triangle.2.circlepath.icloud.fill")
                        .foregroundColor(.brandPrimary)
                        .font(.subheadline)
                    Text("Auto Cloud Sync")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.textPrimary)
                }
            }
            .tint(.brandPrimary)
            
            Divider()

            // Status Message Pill
            HStack {
                Text(cloudService.syncStatus.message)
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.textSecondary)
                Spacer()
            }

            // Action Buttons
            HStack(spacing: 10) {
                // Sync Now Button
                Button {
                    generator.impactOccurred()
                    cloudService.syncSubscriptions(subscriptions)
                } label: {
                    HStack {
                        Image(systemName: "arrow.triangle.2.circlepath")
                        Text(cloudService.isSyncing ? "Syncing..." : "Sync Now")
                    }
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(
                        LinearGradient(
                            colors: [.brandPrimary, .brandSecondary],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(cloudService.isSyncing)
                
                // Restore Button
                Button {
                    generator.impactOccurred()
                    showingRestoreAlert = true
                } label: {
                    HStack {
                        Image(systemName: "icloud.and.arrow.down")
                        Text("Restore")
                    }
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color.brandPrimary.opacity(0.12))
                    .foregroundColor(.brandPrimary)
                    .cornerRadius(12)
                }
                .disabled(cloudService.isSyncing)
            }
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
        .alert("Restore from iCloud?", isPresented: $showingRestoreAlert) {
            Button("Restore Data", role: .destructive) {
                cloudService.restoreFromCloud(modelContext: modelContext) { result in
                    switch result {
                    case .success(let count):
                        restoreMessage = "Successfully restored \(count) subscriptions from iCloud backup."
                    case .failure(let err):
                        restoreMessage = "Restore failed: \(err.localizedDescription)"
                    }
                    showingRestoreResult = true
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will merge subscriptions from your iCloud backup into your current list.")
        }
        .alert("iCloud Restore Status", isPresented: $showingRestoreResult) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(restoreMessage)
        }
    }
}
