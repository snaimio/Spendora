//
//  CloudSyncService.swift
//  Spendora
//

import Foundation
import SwiftUI
import Combine
import SwiftData

class CloudSyncService: ObservableObject {
    static let shared = CloudSyncService()
    
    @Published var isSyncing = false
    @Published var lastSyncDate: Date?
    @Published var syncStatus: SyncStatus = .idle
    @Published var totalSyncedItems: Int = 0
    @Published var autoSyncEnabled: Bool {
        didSet {
            UserDefaults.standard.set(autoSyncEnabled, forKey: "spendora_auto_cloud_sync_enabled")
        }
    }
    
    enum SyncStatus: Equatable {
        case idle
        case syncing
        case success(Int)
        case failed(String)
        
        var message: String {
            switch self {
            case .idle: return "Ready to sync with iCloud"
            case .syncing: return "Syncing with iCloud..."
            case .success(let count): return "Successfully synced \(count) subscriptions to iCloud"
            case .failed(let err): return "Sync failed: \(err)"
            }
        }
    }
    
    private let iCloudKey = "spendora_cloud_subscriptions_backup"
    private let lastSyncKey = "spendora_last_cloud_sync_timestamp"
    
    private init() {
        self.autoSyncEnabled = UserDefaults.standard.bool(forKey: "spendora_auto_cloud_sync_enabled")
        if let timestamp = UserDefaults.standard.object(forKey: lastSyncKey) as? Date {
            self.lastSyncDate = timestamp
        } else if let cloudTimestamp = NSUbiquitousKeyValueStore.default.object(forKey: lastSyncKey) as? Date {
            self.lastSyncDate = cloudTimestamp
        }
        
        // Listen for iCloud external changes from other devices
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(iCloudDataChangedRemotely(_:)),
            name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
            object: NSUbiquitousKeyValueStore.default
        )
        
        // Initial sync of Ubiquitous Store
        NSUbiquitousKeyValueStore.default.synchronize()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Real iCloud Backup & Sync
    func syncSubscriptions(_ subscriptions: [Subscription]) {
        guard !isSyncing else { return }
        
        isSyncing = true
        syncStatus = .syncing
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            // 1. Export subscriptions to JSON data payload
            guard let payload = BackupService.shared.exportBackupData(subscriptions: subscriptions) else {
                DispatchQueue.main.async {
                    self.isSyncing = false
                    self.syncStatus = .failed("Could not serialize subscription data")
                }
                return
            }
            
            let now = Date()
            
            // 2. Save payload to Apple NSUbiquitousKeyValueStore (iCloud Key-Value Store)
            NSUbiquitousKeyValueStore.default.set(payload, forKey: self.iCloudKey)
            NSUbiquitousKeyValueStore.default.set(now, forKey: self.lastSyncKey)
            
            // 3. Force immediate background iCloud synchronization
            let success = NSUbiquitousKeyValueStore.default.synchronize()
            
            // 4. Save local backup file to app documents
            self.saveLocalDocumentBackup(payload: payload)
            
            DispatchQueue.main.async {
                self.isSyncing = false
                if success {
                    self.lastSyncDate = now
                    self.totalSyncedItems = subscriptions.count
                    self.syncStatus = .success(subscriptions.count)
                    UserDefaults.standard.set(now, forKey: self.lastSyncKey)
                } else {
                    self.syncStatus = .failed("iCloud Storage unavailable or disabled")
                }
            }
        }
    }
    
    // MARK: - Restore from iCloud Store
    func restoreFromCloud(modelContext: ModelContext, completion: @escaping (Result<Int, Error>) -> Void) {
        NSUbiquitousKeyValueStore.default.synchronize()
        
        guard let data = NSUbiquitousKeyValueStore.default.data(forKey: iCloudKey) else {
            completion(.failure(NSError(domain: "SpendoraCloud", code: 404, userInfo: [NSLocalizedDescriptionKey: "No iCloud backup found"])))
            return
        }
        
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("restore_icloud_\(Date().timeIntervalSince1970).json")
        
        do {
            try data.write(to: tempURL)
            let importedCount = try BackupService.shared.importBackup(from: tempURL, modelContext: modelContext)
            try? FileManager.default.removeItem(at: tempURL)
            completion(.success(importedCount))
        } catch {
            completion(.failure(error))
        }
    }
    
    private func saveLocalDocumentBackup(payload: Data) {
        if let docsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let backupFile = docsDir.appendingPathComponent("Spendora_Auto_iCloud_Backup.json")
            try? payload.write(to: backupFile)
        }
    }
    
    @objc private func iCloudDataChangedRemotely(_ notification: Notification) {
        DispatchQueue.main.async {
            if let cloudDate = NSUbiquitousKeyValueStore.default.object(forKey: self.lastSyncKey) as? Date {
                self.lastSyncDate = cloudDate
            }
        }
    }
}

// MARK: - Production iCloud Sync View
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
                        .fill(Color.blue.opacity(0.12))
                        .frame(width: 40, height: 40)
                    Image(systemName: "icloud.fill")
                        .foregroundColor(.blue)
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
                        .foregroundColor(.blue)
                        .font(.subheadline)
                    Text("Auto Cloud Sync")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.textPrimary)
                }
            }
            .tint(.blue)
            
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
                    .background(Color.blue)
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
                    .background(Color.blue.opacity(0.12))
                    .foregroundColor(.blue)
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
