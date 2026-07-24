//
//  SupportSection.swift
//  Spendora
//

import SwiftUI

struct SupportSection: View {
    let shareApp: () -> Void
    
    var body: some View {
        Section("Support") {
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
    
    private func openMailSupport() {
        let email = "support@spendora.com"
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
                message: "No mail app found. The support email has been copied to your clipboard.",
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
