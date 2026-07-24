//
//  ExportService.swift
//  Spendora
//

import Foundation
import UIKit

class ExportService {
    
    static func generateCSVString(subscriptions: [Subscription]) -> String {
        var csvString = "Name,Cost,Yearly,Next Billing Date,Category,Monthly Equivalent,Trial Status,Payment Method\n"
        
        for sub in subscriptions {
            let name = sub.displayName.replacingOccurrences(of: ",", with: " ")
            let cost = String(format: "%.2f", sub.cost)
            let yearly = sub.isYearly ? "Yes" : "No"
            let billingDate = sub.formattedNextBillingDate
            let category = sub.category
            let monthlyEquivalent = String(format: "%.2f", sub.monthlyCost)
            let trialStatus = sub.trialStatus
            let paymentMethod = sub.paymentMethod ?? "Not Set"
            
            csvString += "\"\(name)\","
            csvString += "\(cost),"
            csvString += "\(yearly),"
            csvString += "\"\(billingDate)\","
            csvString += "\"\(category)\","
            csvString += "\(monthlyEquivalent),"
            csvString += "\"\(trialStatus)\","
            csvString += "\"\(paymentMethod)\"\n"
        }
        
        return csvString
    }
    
    static func generateCSV(subscriptions: [Subscription]) -> URL? {
        let csvString = generateCSVString(subscriptions: subscriptions)
        
        let tempDir = FileManager.default.temporaryDirectory
        let fileName = "Spendora_Export_\(Date().timeIntervalSince1970).csv"
        let fileURL = tempDir.appendingPathComponent(fileName)
        
        do {
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            return fileURL
        } catch {
            print("Error creating CSV file: \(error)")
            return nil
        }
    }
}
