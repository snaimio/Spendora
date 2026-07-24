//
//  SortOption.swift
//  Spendora
//

import Foundation

enum SortOption: String, CaseIterable {
    case alphabetical = "Alphabetical"
    case cost = "Most Expensive"
    case cheapest = "Cheapest"
    case renewalDate = "Renewal Date"
    case category = "Category"
    case recentlyAdded = "Recently Added"
}
