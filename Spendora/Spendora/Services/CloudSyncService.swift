//
//  CloudSyncService.swift
//  Spendora
//

import Foundation
import SwiftUI
import Combine

class CloudSyncService: ObservableObject {
    static let shared = CloudSyncService()
    
    @Published var isSyncing = false
    @Published var lastSyncDate: Date?
    @Published var syncStatus: SyncStatus = .idle
    
    enum SyncStatus {
        case idle
        case syncing
        case success
        case failed(String)
    }
    
    // Simulate sync (no real CloudKit)
    func syncSubscriptions(_ subscriptions: [Subscription]) {
        isSyncing = true
        syncStatus = .syncing
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isSyncing = false
            self.lastSyncDate = Date()
            self.syncStatus = .success
        }
    }
}

// MARK: - Cloud Sync View
struct CloudSyncView: View {
    @StateObject private var cloudService = CloudSyncService.shared
    @State private var isCloudAvailable = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "icloud")
                    .foregroundColor(.blue)
                    .font(.title2)
                
                Text("iCloud Sync")
                    .font(.headline)
                
                Spacer()
                
                if cloudService.isSyncing {
                    ProgressView()
                        .controlSize(.small)
                } else {
                    switch cloudService.syncStatus {
                    case .success:
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    case .failed:
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundColor(.red)
                    default:
                        EmptyView()
                    }
                }
            }
            
            if let lastSync = cloudService.lastSyncDate {
                Text("Last synced: \(lastSync.formatted(date: .abbreviated, time: .shortened))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Button {
                cloudService.syncSubscriptions([])
            } label: {
                HStack {
                    Image(systemName: cloudService.isSyncing ? "arrow.triangle.2.circlepath" : "arrow.triangle.2.circlepath")
                    Text(cloudService.isSyncing ? "Syncing..." : "Sync Now")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .disabled(cloudService.isSyncing)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8)
        .onAppear {
            // Simulate cloud availability (always true for demo)
            isCloudAvailable = true
        }
    }
}
