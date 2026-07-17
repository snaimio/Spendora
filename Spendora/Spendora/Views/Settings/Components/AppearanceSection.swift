//
//  AppearanceSection.swift
//  Spendora
//

import SwiftUI

struct AppearanceSection: View {
    @State private var isDarkMode = false
    
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
