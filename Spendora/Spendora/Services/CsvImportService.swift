//
//  CSVImportService.swift
//  Spendora
//

import Foundation
import SwiftData

class CSVImportService {
    static func importCSV(from url: URL, modelContext: ModelContext) throws -> Int {
        let content = try String(contentsOf: url, encoding: .utf8)
        let rows = content.components(separatedBy: .newlines)
        var importedCount = 0
        
        for row in rows.dropFirst() { // Skip header
            let columns = row.components(separatedBy: ",")
            guard columns.count >= 5 else { continue }
            
            let name = columns[0].trimmingCharacters(in: .whitespacesAndNewlines)
            guard let cost = Double(columns[1]) else { continue }
            let isYearly = columns[2].lowercased() == "yes"
            let category = columns[4].trimmingCharacters(in: .whitespacesAndNewlines)
            
            let subscription = Subscription(
                name: name,
                cost: cost,
                isYearly: isYearly,
                nextBillingDate: Date(),
                category: category
            )
            
            modelContext.insert(subscription)
            importedCount += 1
        }
        
        try modelContext.save()
        return importedCount
    }
}
