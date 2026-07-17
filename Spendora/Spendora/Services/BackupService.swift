//
//  BackupService.swift
//  Spendora
//

import Foundation
import SwiftData

class BackupService {
    static let shared = BackupService()

    func exportBackup(subscriptions: [Subscription]) -> URL? {
        var backupData: [[String: Any]] = []

        for sub in subscriptions {
            let dict: [String: Any] = [
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

            let url = FileManager.default.temporaryDirectory
                .appendingPathComponent(
                    "Spendora_Backup_\(Date().timeIntervalSince1970).json"
                )

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

            let nextBillingDate: Date

            if let timestamp = item["nextBillingDate"] as? TimeInterval {
                nextBillingDate = Date(timeIntervalSince1970: timestamp)
            } else {
                nextBillingDate = Date()
            }

            let trialEndDate: Date?

            if let timestamp = item["trialEndDate"] as? TimeInterval,
               timestamp > 0 {
                trialEndDate = Date(timeIntervalSince1970: timestamp)
            } else {
                trialEndDate = nil
            }

            let subscription = Subscription(
                name: name,
                cost: cost,
                isYearly: item["isYearly"] as? Bool ?? false,
                nextBillingDate: nextBillingDate,
                category: item["category"] as? String ?? "Other",
                notes: item["notes"] as? String,
                isTrial: item["isTrial"] as? Bool ?? false,
                trialEndDate: trialEndDate,
                expectedPrice: item["expectedPrice"] as? Double,
                priceAlertEnabled: item["priceAlertEnabled"] as? Bool ?? false,
                customCategory: item["customCategory"] as? String,
                paymentMethod: item["paymentMethod"] as? String,
                tags: item["tags"] as? [String] ?? [],
                colorHex: item["colorHex"] as? String
            )

            modelContext.insert(subscription)
            imported += 1
        }

        try modelContext.save()

        return imported
    }
}
