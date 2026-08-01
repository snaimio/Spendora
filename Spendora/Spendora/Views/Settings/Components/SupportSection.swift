//
//  SupportSection.swift
//

import SwiftUI


// MARK: - SupportSection

/**
 `SupportSection` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for supportsection handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `SupportSection` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct SupportSection: View {

    // MARK: - Properties

    let shareApp: () -> Void  // shareApp property
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        Section("Information & Support") {
            NavigationLink {
                AboutCapstoneView()
            } label: {
                HStack {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.brandPrimary)
                        .frame(width: 28)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("About Spendora & Capstone")
                            .font(.system(.body, design: .rounded))
                        Text("Capstone details & architecture")
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            PremiumSettingsRow(
                icon: "square.and.arrow.up",
                title: "Share App",
                subtitle: "Share Spendora with friends"
            ) {
                Button {
                    shareApp()
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            PremiumSettingsRow(
                icon: "envelope.fill",
                title: "Contact Support",
                subtitle: "Help & feedback"
            ) {
                Button {
                    openMailSupport()
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    

    /**
     Executes `openMailSupport` for component logic.
     
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    private func openMailSupport() {
        let email = "support@spendora.app"
        let subject = "Spendora Support Request"
        let body = "Please describe your issue here..."
        
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let mailtoString = "mailto:\(email)?subject=\(encodedSubject)&body=\(encodedBody)"
        
        guard let url = URL(string: mailtoString) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            // Fallback: Copy email to clipboard
            UIPasteboard.general.string = email
            
            // Show alert
            let alert = UIAlertController(
                title: "Email Address Copied",
                message: "Support email (support@spendora.app) has been copied to your clipboard.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootVC = windowScene.windows.first?.rootViewController {
                rootVC.present(alert, animated: true)
            }
        }
    }
}
