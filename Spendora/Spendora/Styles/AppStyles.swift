//
//  AppStyles.swift
//

import SwiftUI


// MARK: - AppStyles

/**
 `AppStyles` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for appstyles handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `AppStyles` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct AppStyles {

    // MARK: - Properties

    
    // MARK: - Typography

// MARK: - Typography

/**
 `Typography` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for typography handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `Typography` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
    struct Typography {

    // MARK: - Properties

        static let largeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
        static let title = Font.system(size: 28, weight: .semibold, design: .rounded)
        static let headline = Font.system(size: 20, weight: .semibold, design: .rounded)
        static let body = Font.system(size: 16, weight: .regular, design: .rounded)
        static let caption = Font.system(size: 13, weight: .regular, design: .rounded)
        static let captionBold = Font.system(size: 13, weight: .semibold, design: .rounded)
    }
    
    // MARK: - Spacing

// MARK: - Spacing

/**
 `Spacing` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for spacing handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `Spacing` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
    struct Spacing {

    // MARK: - Properties

        static let tiny: CGFloat = 4
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let xLarge: CGFloat = 32
    }
    
    // MARK: - Corner Radius

// MARK: - Radius

/**
 `Radius` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for radius handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `Radius` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
    struct Radius {

    // MARK: - Properties

        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let xLarge: CGFloat = 32
    }
    
    // MARK: - Shadows

// MARK: - Shadow

/**
 `Shadow` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for shadow handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `Shadow` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
    struct Shadow {

    // MARK: - Properties

        static let soft = Color.white.opacity(0.03)
        static let medium = Color.white.opacity(0.06)
        static let strong = Color.white.opacity(0.10)
    }
}
