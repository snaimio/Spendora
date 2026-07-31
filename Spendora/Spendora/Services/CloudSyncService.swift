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
