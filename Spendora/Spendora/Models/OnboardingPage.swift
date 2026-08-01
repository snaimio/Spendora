//
//  OnboardingPage.swift
//

/**
 * Main/Core Functions & Purpose:
 * OnboardingPage model defining metadata, icon, title, description, accent color, and optional image asset name for welcome slides.
 */

import SwiftUI


// MARK: - OnboardingPage

/**
 `OnboardingPage` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for onboardingpage handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `OnboardingPage` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct OnboardingPage {

    // MARK: - Properties

    let icon: String  // icon property
    let title: String  // title property
    let description: String  // description property
    let color: Color  // color property
    var customImageName: String? = nil  // customImageName property
}
