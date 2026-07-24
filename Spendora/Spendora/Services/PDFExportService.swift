//
//  PDFExportService.swift
//  Spendora
//

import UIKit
import SwiftUI

class PDFExportService {
    
    static func generatePDFData(subscriptions: [Subscription]) -> Data? {
        let pdfMetaData = [
            kCGPDFContextCreator: "Spendora",
            kCGPDFContextAuthor: "Spendora User",
            kCGPDFContextTitle: "Subscription Report"
        ]

        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageWidth = 612.0
        let pageHeight = 792.0

        let renderer = UIGraphicsPDFRenderer(
            bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight),
            format: format
        )

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium

        let totalMonthly = subscriptions.reduce(0) { $0 + $1.monthlyCost }
        let totalYearly = subscriptions.reduce(0) { $0 + $1.yearlyCost }

        let pdfData = renderer.pdfData { context in
            context.beginPage()

            let titleFont = UIFont.boldSystemFont(ofSize: 22)
            let headerFont = UIFont.boldSystemFont(ofSize: 14)
            let textFont = UIFont.systemFont(ofSize: 12)

            "Spendora Subscription Report".draw(
                at: CGPoint(x: 50, y: 50),
                withAttributes: [.font: titleFont]
            )

            "Generated: \(dateFormatter.string(from: Date()))".draw(
                at: CGPoint(x: 50, y: 90),
                withAttributes: [
                    .font: UIFont.systemFont(ofSize: 12),
                    .foregroundColor: UIColor.gray
                ]
            )

            let totalsY = 140

            "Total Monthly: \(String(format: "$%.2f", totalMonthly))".draw(
                at: CGPoint(x: 50, y: totalsY),
                withAttributes: [.font: headerFont]
            )

            "Total Yearly: \(String(format: "$%.2f", totalYearly))".draw(
                at: CGPoint(x: 50, y: totalsY + 25),
                withAttributes: [.font: headerFont]
            )

            "Active Subscriptions: \(subscriptions.count)".draw(
                at: CGPoint(x: 50, y: totalsY + 50),
                withAttributes: [.font: headerFont]
            )

            let headerY = 210

            "Name".draw(at: CGPoint(x: 50, y: headerY), withAttributes: [.font: headerFont])
            "Cost".draw(at: CGPoint(x: 220, y: headerY), withAttributes: [.font: headerFont])
            "Cycle".draw(at: CGPoint(x: 330, y: headerY), withAttributes: [.font: headerFont])
            "Next Billing".draw(at: CGPoint(x: 430, y: headerY), withAttributes: [.font: headerFont])

            let path = UIBezierPath()
            path.move(to: CGPoint(x: 40, y: headerY + 20))
            path.addLine(to: CGPoint(x: 560, y: headerY + 20))
            path.stroke()

            var yPosition = CGFloat(headerY + 35)
            let pageHeightCGFloat = CGFloat(pageHeight)

            for sub in subscriptions {
                guard yPosition < pageHeightCGFloat - 60 else { break }

                sub.displayName.draw(at: CGPoint(x: 50, y: yPosition), withAttributes: [.font: textFont])
                String(format: "$%.2f", sub.cost).draw(at: CGPoint(x: 220, y: yPosition), withAttributes: [.font: textFont])
                (sub.isYearly ? "Yearly" : "Monthly").draw(at: CGPoint(x: 330, y: yPosition), withAttributes: [.font: textFont])
                sub.formattedNextBillingDate.draw(at: CGPoint(x: 430, y: yPosition), withAttributes: [.font: textFont])

                yPosition += 22
            }
        }
        
        return pdfData
    }
    
    static func generatePDF(subscriptions: [Subscription]) -> URL? {
        guard let pdfData = generatePDFData(subscriptions: subscriptions) else {
            return nil
        }
        
        let tempDir = FileManager.default.temporaryDirectory
        let fileName = "Spendora_Report_\(Date().timeIntervalSince1970).pdf"
        let fileURL = tempDir.appendingPathComponent(fileName)
        
        do {
            try pdfData.write(to: fileURL)
            return fileURL
        } catch {
            print("Failed to save PDF: \(error)")
            return nil
        }
    }
}
