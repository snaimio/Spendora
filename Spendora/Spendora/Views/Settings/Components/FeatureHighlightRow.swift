//
//  FeatureHighlightRow.swift
//

/**
 * Main/Core Functions & Purpose:
 * FeatureHighlightRow helper component displaying icon, title, and description for capstone highlights.
 */

import SwiftUI


// MARK: - FeatureHighlightRow

/**
 `FeatureHighlightRow` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for featurehighlightrow handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `FeatureHighlightRow` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct FeatureHighlightRow: View {

    // MARK: - Properties

    let icon: String  // icon property
    let title: String  // title property
    let subtitle: String  // subtitle property
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.brandPrimary)
                .frame(width: 28)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.semibold)
                
                Text(subtitle)
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.secondary)
            }
        }
    }
}
