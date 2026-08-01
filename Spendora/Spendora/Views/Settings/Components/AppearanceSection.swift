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

    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        Section("Appearance") {
            PremiumSettingsRow(
                icon: "moon.fill",
                title: "Dark Mode",
                subtitle: isDarkMode ? "Dark Theme Enabled" : "Light Theme Enabled"
            ) {
                Toggle("", isOn: Binding(
                    get: { isDarkMode },
                    set: { newValue in
                        isDarkMode = newValue
                        updateInterfaceStyle(isDark: newValue)
                    }
                ))
                .toggleStyle(SwitchToggleStyle(tint: .brandPrimary))
                .labelsHidden()
            }
        }
        .onAppear {
            updateInterfaceStyle(isDark: isDarkMode)
        }
    }

    private func updateInterfaceStyle(isDark: Bool) {
        let style: UIUserInterfaceStyle = isDark ? .dark : .light
        for scene in UIApplication.shared.connectedScenes {
            if let windowScene = scene as? UIWindowScene {
                windowScene.windows.forEach { window in
                    window.overrideUserInterfaceStyle = style
                }
            }
        }
    }
}
