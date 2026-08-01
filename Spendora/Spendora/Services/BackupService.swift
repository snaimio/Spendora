//
//  BackupService.swift
//

import Foundation
import SwiftData


// MARK: - BackupService

/**
 `BackupService` is a class that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for backupservice handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `BackupService` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
class BackupService {

    // MARK: - Properties

    static let shared = BackupService()


    /**
     Executes `exportBackupData` for component logic.
     
     - Parameter subscriptions: Value passed to `exportBackupData`.
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func exportBackupData(subscriptions: [Subscription]) -> Data? {
        var backupData: [[String: Any]] = []  // backupData property

        for sub in subscriptions {
            let dict: [String: Any] = [  // dict property
                "id": sub.id.uuidString,
                "name": sub.name,
                "cost": sub.cost,
                "isYearly": sub.isYearly,
                "category": sub.category,
                "paymentMethod": sub.paymentMethod ?? "",
                "nextBillingDate": sub.nextBillingDate.timeIntervalSince1970,
                "createdAt": sub.createdAt.timeIntervalSince1970,
                "isTrial": sub.isTrial,
                "trialEndDate": sub.trialEndDate?.timeIntervalSince1970 ?? 0,
                "priceAlertEnabled": sub.priceAlertEnabled,
                "expectedPrice": sub.expectedPrice ?? 0,
                "notes": sub.notes ?? "",
                "customCategory": sub.customCategory ?? "",
                "colorHex": sub.colorHex ?? "",
                "tags": sub.tags ?? []
            ]

            backupData.append(dict)
        }

        do {
            let data = try JSONSerialization.data(
                withJSONObject: backupData,
                options: .prettyPrinted
            )
            return data
        } catch {
            print("Backup export failed: \(error)")
            return nil
        }
    }


    /**
     Executes `exportBackup` for component logic.
     
     - Parameter subscriptions: Value passed to `exportBackup`.
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func exportBackup(subscriptions: [Subscription]) -> URL? {
        guard let data = exportBackupData(subscriptions: subscriptions) else {
            return nil
        }
        
        let tempDir = FileManager.default.temporaryDirectory
        let fileName = "Spendora_Backup_\(Date().timeIntervalSince1970).json"
        let url = tempDir.appendingPathComponent(fileName)

        do {
            try data.write(to: url)
            return url
        } catch {
            print("Backup export failed: \(error)")
            return nil
        }
    }

    func importBackup(
        from url: URL,
        modelContext: ModelContext
    ) throws -> Int {

        let data = try Data(contentsOf: url)

        guard let json = try JSONSerialization.jsonObject(with: data)
            as? [[String: Any]]
        else {
            return 0
        }

        var imported = 0

        for item in json {
            guard let name = item["name"] as? String,
                  let cost = item["cost"] as? Double
            else {
                continue
            }

            let nextBillingDate: Date  // nextBillingDate property

            if let timestamp = item["nextBillingDate"] as? TimeInterval {
                nextBillingDate = Date(timeIntervalSince1970: timestamp)
            } else {
                nextBillingDate = Date()
            }

            let trialEndDate: Date?  // trialEndDate property

            if let timestamp = item["trialEndDate"] as? TimeInterval,
               timestamp > 0 {
                trialEndDate = Date(timeIntervalSince1970: timestamp)
            } else {
                trialEndDate = nil
            }

            let subscription = Subscription(
                name: name,
                cost: cost,
                category: item["category"] as? String ?? "Other",
                isYearly: item["isYearly"] as? Bool ?? false,
                nextBillingDate: nextBillingDate,
                notes: item["notes"] as? String,
                colorHex: item["colorHex"] as? String,
                isTrial: item["isTrial"] as? Bool ?? false,
                trialEndDate: trialEndDate,
                expectedPrice: item["expectedPrice"] as? Double,
                priceAlertEnabled: item["priceAlertEnabled"] as? Bool ?? false,
                customCategory: item["customCategory"] as? String,
                paymentMethod: item["paymentMethod"] as? String,
                tags: item["tags"] as? [String] ?? []
            )

            modelContext.insert(subscription)
            imported += 1
        }

        try modelContext.save()

        return imported
    }
}
