//
//  StringExtensions.swift
//  Spendora
//

import Foundation

extension String {
    
    /// Check if string is empty or only whitespace
    var isBlank: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    /// Capitalize first letter of each word
    var capitalizedWords: String {
        split(separator: " ")
            .map { $0.capitalized }
            .joined(separator: " ")
    }
    
    /// Remove all whitespace and newlines
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Convert to valid currency amount
    var asCurrencyAmount: Double? {
        Double(replacingOccurrences(of: "$", with: "")
            .replacingOccurrences(of: ",", with: ""))
    }
}
