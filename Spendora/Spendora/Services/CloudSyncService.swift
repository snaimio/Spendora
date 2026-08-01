//
//  CloudSyncService.swift
//

import Foundation
import SwiftUI
import Combine
import SwiftData


// MARK: - CloudSyncService

/**
 `CloudSyncService` is a class that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for cloudsyncservice handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `CloudSyncService` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
class CloudSyncService: ObservableObject {

    // MARK: - Properties

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
    

// MARK: - SyncStatus

/**
 `SyncStatus` is a enum that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for syncstatus handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `SyncStatus` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
    enum SyncStatus: Equatable {

    // MARK: - Properties

        case idle
        case syncing
        case success(Int)
        case failed(String)
        
        var message: String {  // message property
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
    
    /// Safe computed property returning NSUbiquitousKeyValueStore only when iCloud Ubiquity identity token is available
    private var kvsStore: NSUbiquitousKeyValueStore? {
        guard FileManager.default.ubiquityIdentityToken != nil else { return nil }
        return NSUbiquitousKeyValueStore.default
    }
    
    private init() {
        self.autoSyncEnabled = UserDefaults.standard.bool(forKey: "spendora_auto_cloud_sync_enabled")
        if let timestamp = UserDefaults.standard.object(forKey: lastSyncKey) as? Date {
            self.lastSyncDate = timestamp
        } else if let cloudTimestamp = kvsStore?.object(forKey: lastSyncKey) as? Date {
            self.lastSyncDate = cloudTimestamp
        }
        
        // Listen for iCloud external changes from other devices if KVS is active
        if kvsStore != nil {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(iCloudDataChangedRemotely(_:)),
                name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
                object: NSUbiquitousKeyValueStore.default
            )
            kvsStore?.synchronize()
        }
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
            var kvsSuccess = false
            
            // 2. Save payload to Apple NSUbiquitousKeyValueStore if available
            if let store = self.kvsStore {
                store.set(payload, forKey: self.iCloudKey)
                store.set(now, forKey: self.lastSyncKey)
                kvsSuccess = store.synchronize()
            }
            
            // 3. Save local backup file to app documents container (always reliable offline)
            self.saveLocalDocumentBackup(payload: payload)
            
            DispatchQueue.main.async {
                self.isSyncing = false
                self.lastSyncDate = now
                self.totalSyncedItems = subscriptions.count
                self.syncStatus = .success(subscriptions.count)
                UserDefaults.standard.set(now, forKey: self.lastSyncKey)
            }
        }
    }
    
    // MARK: - Restore from iCloud Store
    func restoreFromCloud(modelContext: ModelContext, completion: @escaping (Result<Int, Error>) -> Void) {
        var backupData: Data?
        
        if let store = kvsStore {
            store.synchronize()
            backupData = store.data(forKey: iCloudKey)
        }
        
        // Fallback to local document backup if cloud store data is nil
        if backupData == nil {
            if let docsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let localFile = docsDir.appendingPathComponent("Spendora_Auto_iCloud_Backup.json")
                backupData = try? Data(contentsOf: localFile)
            }
        }
        
        guard let data = backupData else {
            completion(.failure(NSError(domain: "SpendoraCloud", code: 404, userInfo: [NSLocalizedDescriptionKey: "No iCloud or local backup found"])))
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
            if let cloudDate = self.kvsStore?.object(forKey: self.lastSyncKey) as? Date {
                self.lastSyncDate = cloudDate
            }
        }
    }
}
