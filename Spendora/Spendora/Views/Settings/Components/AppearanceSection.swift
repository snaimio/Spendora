//
//  AppearanceSection.swift
//

import SwiftUI


// MARK: - AppearanceSection

/**
 `AppearanceSection` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for appearancesection handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `AppearanceSection` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct AppearanceSection: View {

    // MARK: - Properties

    @State private var isDarkMode = false
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        Section("Appearance") {
            PremiumSettingsRow(
                icon: "moon.fill",
                title: "Dark Mode",
                subtitle: "Match system appearance"
            ) {
                Toggle("", isOn: Binding(
                    get: {
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let window = windowScene.windows.first {
                            return window.overrideUserInterfaceStyle == .dark
                        }
                        return false
                    },
                    set: { isDark in
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let window = windowScene.windows.first {
                            window.overrideUserInterfaceStyle = isDark ? .dark : .light
                        }
                    }
                ))
                .toggleStyle(SwitchToggleStyle(tint: .brandPrimary))
                .labelsHidden()
            }
        }
    }
}
