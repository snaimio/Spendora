/**
 * Main/Core Functions & Purpose:
 * Enum defining all user-selectable sorting options for the subscriptions list on the main Dashboard.
 * Supports sorting by Alphabetical order, Highest Cost, Lowest Cost, Renewal Date, Category, and Recently Added.
 */

import Foundation

enum SortOption: String, CaseIterable {
    case alphabetical = "Alphabetical"
    case cost = "Most Expensive"
    case cheapest = "Cheapest"
    case renewalDate = "Renewal Date"
    case category = "Category"
    case recentlyAdded = "Recently Added"
}
