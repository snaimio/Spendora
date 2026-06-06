//
//  PDFExportService.swift
//  Spendora
//

import Foundation
import SwiftUI

class PDFExportService {
    static func generatePDF(subscriptions: [Subscription]) -> URL? {
        let pdfDocument = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 595, height: 842))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = dateFormatter.string(from: Date())
        
        let totalMonthly = subscriptions.reduce(0) { $0 + $1.monthlyCost }
        let totalYearly = subscriptions.reduce(0) { $0 + $1.yearlyCost }
        
        let pdfData = pdfDocument.pdfData { context in
            context.beginPage()
            
            // Title
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 24)
            ]
            "Spendora Subscription Report".draw(at: CGPoint(x: 50, y: 50), withAttributes: titleAttributes)
            
            // Date
            let dateAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12)
            ]
            "Generated: \(dateString)".draw(at: CGPoint(x: 50, y: 90), withAttributes: dateAttributes)
            
            // Totals
            let totalsY = 130
            let totals = [
                "Total Monthly Spending: \(CurrencyManager.shared.format(totalMonthly))",
                "Total Yearly Spending: \(CurrencyManager.shared.format(totalYearly))",
                "Active Subscriptions: \(subscriptions.count)"
            ]
            
            for (index, text) in totals.enumerated() {
                text.draw(at: CGPoint(x: 50, y: totalsY + (index * 25)), withAttributes: [
                    .font: UIFont.boldSystemFont(ofSize: 14)
                ])
            }
            
            // Subscriptions Table Header
            let headerY = 220
            let headerAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 12)
            ]
            "Name".draw(at: CGPoint(x: 50, y: headerY), withAttributes: headerAttributes)
            "Cost".draw(at: CGPoint(x: 200, y: headerY), withAttributes: headerAttributes)
            "Cycle".draw(at: CGPoint(x: 300, y: headerY), withAttributes: headerAttributes)
            "Next Billing".draw(at: CGPoint(x: 380, y: headerY), withAttributes: headerAttributes)
            
            // Draw line
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 50, y: headerY + 20))
            path.addLine(to: CGPoint(x: 545, y: headerY + 20))
            path.stroke()
            
            // Subscriptions List
            let rowAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 11)
            ]
            
            for (index, sub) in subscriptions.enumerated() {
                let y = headerY + 35 + (index * 25)
                if y > 800 { break } // Page break would go here
                
                sub.displayName.draw(at: CGPoint(x: 50, y: y), withAttributes: rowAttributes)
                CurrencyManager.shared.format(sub.cost).draw(at: CGPoint(x: 200, y: y), withAttributes: rowAttributes)
                (sub.isYearly ? "Yearly" : "Monthly").draw(at: CGPoint(x: 300, y: y), withAttributes: rowAttributes)
                sub.formattedNextBillingDate.draw(at: CGPoint(x: 380, y: y), withAttributes: rowAttributes)
            }
        }
        
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsPath.appendingPathComponent("Spendora_Report_\(Date().timeIntervalSince1970).pdf")
        
        do {
            try pdfData.write(to: fileURL)
            return fileURL
        } catch {
            print("Error generating PDF: \(error)")
            return nil
        }
    }
    
    static func sharePDF(from viewController: UIViewController, fileURL: URL) {
        let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        viewController.present(activityVC, animated: true)
    }
}
