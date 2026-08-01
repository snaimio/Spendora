//
//  SortOption.swift
//

/**
 * Main/Core Functions & Purpose:
 * Enum defining all user-selectable sorting options for the subscriptions list on the main Dashboard.
 * Supports sorting by Alphabetical order, Highest Cost, Lowest Cost, Renewal Date, Category, and Recently Added.
 */

import Foundation


// MARK: - SortOption

/**
 `SortOption` is a enum that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for sortoption handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `SortOption` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
enum SortOption: String, CaseIterable {

    // MARK: - Properties

    case alphabetical = "Alphabetical"
    case cost = "Most Expensive"
    case cheapest = "Cheapest"
    case renewalDate = "Renewal Date"
    case category = "Category"
    case recentlyAdded = "Recently Added"
}
