//
//  ExportService.swift
//  Spendora
//

import Foundation
import UIKit

class ExportService {
    static func generateCSV(subscriptions: [Subscription]) -> URL? {
        var csvString = "Name,Cost,Yearly,Next Billing Date,Category,Monthly Equivalent,Trial Status\n"

        for sub in subscriptions {
            csvString += "\"\(sub.displayName)\","
            csvString += "\(sub.cost),"
            csvString += "\(sub.isYearly ? "Yes" : "No"),"
            csvString += "\"\(sub.formattedNextBillingDate)\","
            csvString += "\"\(sub.category)\","
            csvString += "\(sub.monthlyCost),"
            csvString += "\"\(sub.trialStatus)\"\n"
        }

        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]

        let fileName = "Spendora_Export_\(Date().timeIntervalSince1970).csv"
        let fileURL = documentsPath.appendingPathComponent(fileName)

        do {
            try csvString.write(
                to: fileURL,
                atomically: true,
                encoding: .utf8
            )
            return fileURL
        } catch {
            print("Error generating CSV: \(error)")
            return nil
        }
    }

    static func shareCSV(
        from viewController: UIViewController,
        fileURL: URL
    ) {
        let activityVC = UIActivityViewController(
            activityItems: [fileURL],
            applicationActivities: nil
        )

        viewController.present(
            activityVC,
            animated: true
        )
    }
}
