//
//  PDFExportService.swift
//  Spendora
//

import UIKit

class PDFExportService {
    static func generatePDF(subscriptions: [Subscription]) -> URL? {
        let pdfMetaData = [
            kCGPDFContextCreator: "Spendora",
            kCGPDFContextAuthor: "Spendora User",
            kCGPDFContextTitle: "Subscription Report"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageWidth = 612.0
        let pageHeight = 792.0
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), format: format)

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium

        let totalMonthly = subscriptions.reduce(0) { $0 + $1.monthlyCost }
        let totalYearly = subscriptions.reduce(0) { $0 + $1.yearlyCost }

        let pdfData = renderer.pdfData { context in
            context.beginPage()

            let titleFont = UIFont.boldSystemFont(ofSize: 22)
            let headerFont = UIFont.boldSystemFont(ofSize: 14)
            let textFont = UIFont.systemFont(ofSize: 12)

            // Title
            "Spendora Subscription Report".draw(at: CGPoint(x: 50, y: 50), withAttributes: [.font: titleFont])

            // Date
            "Generated: \(dateFormatter.string(from: Date()))".draw(at: CGPoint(x: 50, y: 90), withAttributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.gray])

            // Totals
            let totalsY = 140
            "Total Monthly: \(CurrencyManager.shared.format(totalMonthly))".draw(at: CGPoint(x: 50, y: totalsY), withAttributes: [.font: headerFont])
            "Total Yearly: \(CurrencyManager.shared.format(totalYearly))".draw(at: CGPoint(x: 50, y: totalsY + 25), withAttributes: [.font: headerFont])
            "Active Subscriptions: \(subscriptions.count)".draw(at: CGPoint(x: 50, y: totalsY + 50), withAttributes: [.font: headerFont])

            // Table Header
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
                CurrencyManager.shared.format(sub.cost).draw(at: CGPoint(x: 220, y: yPosition), withAttributes: [.font: textFont])
                (sub.isYearly ? "Yearly" : "Monthly").draw(at: CGPoint(x: 330, y: yPosition), withAttributes: [.font: textFont])
                sub.formattedNextBillingDate.draw(at: CGPoint(x: 430, y: yPosition), withAttributes: [.font: textFont])

                yPosition += 22
            }
        }

        let url = FileManager.default.temporaryDirectory.appendingPathComponent("Spendora_Report.pdf")
        try? pdfData.write(to: url)
        return url
    }
}
