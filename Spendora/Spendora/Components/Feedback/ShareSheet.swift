//
//  ShareSheet.swift
//

import SwiftUI
import UIKit


// MARK: - ShareSheet

/**
 `ShareSheet` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for sharesheet handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `ShareSheet` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct ShareSheet: UIViewControllerRepresentable {

    // MARK: - Properties

    let items: [Any]  // items property
    let excludedActivityTypes: [UIActivity.ActivityType]?  // excludedActivityTypes property
    
    init(items: [Any], excludedActivityTypes: [UIActivity.ActivityType]? = nil) {
        self.items = items
        self.excludedActivityTypes = excludedActivityTypes
    }
    

    /**
     Executes `makeUIViewController` for component logic.
     
     - Parameter context: Value passed to `makeUIViewController`.
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        controller.excludedActivityTypes = excludedActivityTypes
        return controller
    }
    
    func updateUIViewController(
        _ uiViewController: UIActivityViewController,
        context: Context
    ) {
        // No updates needed
    }
}
