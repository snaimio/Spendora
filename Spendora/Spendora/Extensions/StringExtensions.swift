//
//  StringExtensions.swift
//

import Foundation


// MARK: - String Extension

/**
 Extension on `String` providing utility methods and helpers.
 */
extension String {
    
    /// Check if string is empty or only whitespace
    var isBlank: Bool {  // isBlank property
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    /// Capitalize first letter of each word
    var capitalizedWords: String {  // capitalizedWords property
        split(separator: " ")
            .map { $0.capitalized }
            .joined(separator: " ")
    }
    
    /// Remove all whitespace and newlines
    var trimmed: String {  // trimmed property
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Convert to valid currency amount
    var asCurrencyAmount: Double? {  // asCurrencyAmount property
        Double(
            replacingOccurrences(of: "$", with: "")
                .replacingOccurrences(of: ",", with: "")
        )
    }
}
