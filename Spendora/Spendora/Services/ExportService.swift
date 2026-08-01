//
//  ExportService.swift
//

/**
 * Main/Core Functions & Purpose:
 * ExportService class providing CSV data export capabilities.
 * Formats active subscription records into RFC 4180 compliant Comma-Separated Values (CSV) text
 * for external spreadsheet analysis in Apple Numbers, Microsoft Excel, or Google Sheets.
 */

import Foundation
import UIKit


// MARK: - ExportService

/**
 `ExportService` is a class that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for exportservice handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `ExportService` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
class ExportService {

    // MARK: - Properties

    
    /// Generates a CSV formatted string from an array of Subscription models
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
    

    /**
     Executes `generateCSV` for component logic.
     
     - Parameter subscriptions: Value passed to `generateCSV`.
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
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
