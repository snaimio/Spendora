//
//  MagicFinderCategoryDetector.swift
//  Spendora
//
//  Capstone 2026 - Mobile Application Development
//  Author: Sheikh Naim
//

/**
 * Main/Core Functions & Purpose:
 * Extension for MagicFinderService containing automated text-based subscription category detection logic.
 */

import Foundation

extension MagicFinderService {
    
    func detectCategory(from text: String) -> String? {
        let lowercased = text.lowercased()
        
        // Entertainment
        if lowercased.contains("music")
            || lowercased.contains("tv")
            || lowercased.contains("movie")
            || lowercased.contains("show")
            || lowercased.contains("netflix")
            || lowercased.contains("spotify")
            || lowercased.contains("disney")
            || lowercased.contains("hulu")
            || lowercased.contains("youtube")
            || lowercased.contains("hbo")
            || lowercased.contains("max")
            || lowercased.contains("peacock")
            || lowercased.contains("paramount")
            || lowercased.contains("starz")
            || lowercased.contains("showtime")
            || lowercased.contains("crunchyroll")
            || lowercased.contains("audible")
            || lowercased.contains("kindle") {
            return "Entertainment"
        }
        
        // Productivity
        if lowercased.contains("work")
            || lowercased.contains("office")
            || lowercased.contains("cloud")
            || lowercased.contains("storage")
            || lowercased.contains("microsoft")
            || lowercased.contains("google")
            || lowercased.contains("dropbox")
            || lowercased.contains("notion") {
            return "Productivity"
        }
        
        // Health & Fitness
        if lowercased.contains("fitness")
            || lowercased.contains("health")
            || lowercased.contains("gym")
            || lowercased.contains("workout")
            || lowercased.contains("fitbit")
            || lowercased.contains("myfitnesspal")
            || lowercased.contains("headspace")
            || lowercased.contains("calm")
            || lowercased.contains("strava")
            || lowercased.contains("peloton")
            || lowercased.contains("whoop")
            || lowercased.contains("zwift") {
            return "Health & Fitness"
        }
        
        // Shopping
        if lowercased.contains("shop")
            || lowercased.contains("delivery")
            || lowercased.contains("prime")
            || lowercased.contains("amazon") {
            return "Shopping"
        }
        
        // Food & Dining
        if lowercased.contains("food")
            || lowercased.contains("meal")
            || lowercased.contains("cook")
            || lowercased.contains("hellofresh") {
            return "Food & Dining"
        }
        
        // Education
        if lowercased.contains("learn")
            || lowercased.contains("course")
            || lowercased.contains("class")
            || lowercased.contains("duolingo") {
            return "Education"
        }
        
        return nil
    }
}
